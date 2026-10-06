"""HTTP + WebSocket API for the web frontend.

The engine runs independently; this server only reads its state and forwards
user input. If the browser disconnects, the lights keep running.
"""

from __future__ import annotations

import asyncio
import logging
import time
import os
import subprocess
import sys
import webbrowser
from dataclasses import asdict
from pathlib import Path

from fastapi import FastAPI, HTTPException, WebSocket, WebSocketDisconnect
from fastapi.responses import FileResponse
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel

from ..config.loader import report_unknown_keys
from ..config.models import Controller, FixtureType, Rig, Settings
from ..engine.engine import Engine
from ..engine.macros import MACRO_DEFS
from ..io.audio_in import list_input_devices
from ..io.devices import list_serial_devices
from ..io.midi_in import list_midi_inputs

log = logging.getLogger(__name__)


class MacroUpdate(BaseModel):
    name: str
    value: float


class Activate(BaseModel):
    name: str


class SceneName(BaseModel):
    name: str | None = None


def create_app(engine: Engine, static_dir: Path | None = None, desktop: dict | None = None) -> FastAPI:
    """``desktop``: set by the standalone app (``url``, ``data_dir``) to enable the app-only actions."""
    app = FastAPI(title="PitchControl", version="0.1.0")
    store = engine.store

    # ------------------------------------------------------------------ app info
    @app.get("/api/app-info")
    def app_info():
        return {"desktop": desktop is not None, "config_dir": str(store.root), **(desktop or {})}

    @app.post("/api/open-browser")
    def open_browser():
        if desktop is None:
            raise HTTPException(404)
        webbrowser.open(desktop["url"])
        return {"ok": True}

    @app.post("/api/open-data-folder")
    def open_data_folder():
        if desktop is None:
            raise HTTPException(404)
        folder = desktop["data_dir"]
        if sys.platform == "win32":
            os.startfile(folder)  # type: ignore[attr-defined]
        else:
            subprocess.Popen(["open" if sys.platform == "darwin" else "xdg-open", folder])
        return {"ok": True}

    # ------------------------------------------------------------------ macros
    @app.get("/api/macros/defs")
    def macro_defs():
        return [asdict(m) | {"label": m.label} for m in MACRO_DEFS]

    @app.post("/api/macros")
    def set_macro(update: MacroUpdate):
        if not engine.macros.set(update.name, update.value):
            raise HTTPException(404, f"unknown macro '{update.name}'")
        return {"ok": True}

    @app.post("/api/macros/{name}/toggle")
    def toggle_macro(name: str):
        if name not in engine.macros.defs:
            raise HTTPException(404, f"unknown macro '{name}'")
        engine.macros.toggle(name)
        return {"ok": True}

    # ------------------------------------------------------------------ state
    @app.get("/api/state")
    def state():
        return engine.state()

    @app.get("/api/universes")
    def universes():
        return engine.universe_dump()

    @app.get("/api/audio/bands")
    def bands():
        with engine.lock:
            layout = engine.analyzer.layout
            return {
                "edges": [round(x, 1) for x in layout.edges.tolist()],
                "centres": [round(x, 1) for x in layout.centres.tolist()],
                "trigger_weights": [round(x, 3) for x in engine.features.weights.tolist()],
            }

    # ------------------------------------------------------------------ settings
    @app.get("/api/settings")
    def get_settings():
        return store.settings.model_dump(mode="json")

    @app.put("/api/settings")
    def put_settings(data: dict):
        new = Settings.model_validate(data)
        report_unknown_keys(new, "settings (from UI)")
        old = store.settings
        with engine.lock:
            store.settings = new
        store.save_settings()
        if new.outputs != old.outputs and engine.enable_hardware:
            engine.outputs.restart(new.outputs)
        if new.audio != old.audio:
            engine.restart_audio() if engine.enable_hardware else engine.rebuild_audio_analysis()
        if new.active_controller != old.active_controller or new.midi_input != old.midi_input:
            store.load_controller(new.active_controller)
            engine.restart_midi()
        if new.masks != old.masks:
            engine.rebuild_masks()
        if new.active_rig != old.active_rig:
            store.load_rig(new.active_rig)
            engine.rebuild_fixtures()
        return {"ok": True}

    # ------------------------------------------------------------------ fixtures & rigs
    @app.get("/api/fixture-types")
    def fixture_types():
        return {name: t.model_dump(mode="json", exclude_none=True) for name, t in store.fixture_types.items()}

    @app.put("/api/fixture-types/{name}")
    def put_fixture_type(name: str, data: dict):
        ftype = FixtureType.model_validate(data | {"name": name})
        report_unknown_keys(ftype, f"fixture type '{name}' (from UI)")
        store.save_fixture_type(ftype)
        store.fixture_types[name] = ftype
        engine.rebuild_fixtures()
        return {"ok": True}

    rig_state = {"unsaved": False}  # live rig changes not yet written to the file

    @app.get("/api/rigs")
    def rigs():
        return {"active": store.rig.name, "available": store.list_names(store.rigs_dir), "unsaved": rig_state["unsaved"]}

    @app.get("/api/rig")
    def get_rig():
        return store.rig.model_dump(mode="json", exclude_none=True)

    @app.put("/api/rig")
    def put_rig(data: dict, persist: bool = True):
        """Apply a rig to the engine; ``persist=false`` applies it live without writing the file."""
        rig = Rig.model_validate(data)
        if persist:
            report_unknown_keys(rig, "rig (from UI)")
        if not rig.name:
            rig.name = store.rig.name
        with engine.lock:
            store.rig = rig
            problems = store.validate_rig() if persist else []
        if persist:
            store.save_rig()
        rig_state["unsaved"] = not persist
        engine.rebuild_fixtures()
        return {"ok": True, "problems": problems}

    @app.post("/api/rig/reload")
    def reload_rig():
        """Discard live (unsaved) rig changes: reload the rig file."""
        store.load_rig(store.rig.name or store.settings.active_rig)
        rig_state["unsaved"] = False
        engine.rebuild_fixtures()
        return store.rig.model_dump(mode="json", exclude_none=True)

    @app.post("/api/rig/activate")
    def activate_rig(body: Activate):
        if body.name not in store.list_names(store.rigs_dir):
            raise HTTPException(404, f"rig '{body.name}' not found")
        store.settings.active_rig = body.name
        store.save_settings()
        store.load_rig(body.name)
        rig_state["unsaved"] = False
        engine.rebuild_fixtures()
        return {"ok": True}

    # ------------------------------------------------------------------ controllers & devices
    @app.get("/api/controllers")
    def controllers():
        return {"active": store.settings.active_controller, "available": store.list_names(store.controllers_dir)}

    @app.get("/api/controllers/{name}")
    def controller(name: str):
        path = store.controllers_dir / f"{name}.json"
        if not path.exists():
            raise HTTPException(404)
        return Controller.model_validate_json(path.read_text()).model_dump(mode="json")

    @app.get("/api/devices/serial")
    def serial_devices():
        return list_serial_devices()

    @app.get("/api/devices/audio")
    def audio_devices():
        return list_input_devices()

    @app.get("/api/devices/midi")
    def midi_devices():
        return list_midi_inputs()

    # ------------------------------------------------------------------ scenes
    @app.get("/api/scenes")
    def scenes():
        out = []
        for i in range(8):
            sc = store.load_scene(i)
            out.append({"index": i, "name": sc.name if sc else None, "exists": sc is not None})
        return out

    @app.post("/api/scenes/{index}/save")
    def save_scene(index: int, body: SceneName | None = None):
        if not 0 <= index < 8:
            raise HTTPException(404)
        engine.save_scene(index, body.name if body else None)
        return {"ok": True}

    @app.post("/api/scenes/{index}/load")
    def load_scene(index: int):
        if not 0 <= index < 8 or not engine.load_scene(index):
            raise HTTPException(404, "scene not found")
        return {"ok": True}

    # ------------------------------------------------------------------ live websocket
    @app.websocket("/ws")
    async def ws(socket: WebSocket):
        await socket.accept()
        sender = asyncio.create_task(_push_state(socket, engine))
        try:
            while True:
                msg = await socket.receive_json()
                if msg.get("type") == "macro":
                    engine.macros.set(str(msg.get("name")), float(msg.get("value", 0)))
                elif msg.get("type") == "toggle":
                    engine.macros.toggle(str(msg.get("name")))
                elif msg.get("type") == "macro_deferred":  # keyboard: hue/saturation apply once keys rest
                    engine.macros.set_deferred(str(msg.get("name")), float(msg.get("value", 0)), time.monotonic())
                elif msg.get("type") == "cancel_pending":
                    engine.macros.cancel_deferred(str(msg.get("name")))
        except WebSocketDisconnect:
            pass
        finally:
            sender.cancel()

    # ------------------------------------------------------------------ frontend
    if static_dir is not None and (static_dir / "index.html").exists():
        app.mount("/assets", StaticFiles(directory=static_dir / "assets"), name="assets")

        @app.get("/{path:path}", include_in_schema=False)
        def spa(path: str):
            file = static_dir / path
            if path and file.is_file():
                return FileResponse(file)
            return FileResponse(static_dir / "index.html")

    return app


async def _push_state(socket: WebSocket, engine: Engine) -> None:
    """Send engine state (JSON) and the 256×256 preview (binary) at ``preview_fps``."""
    try:
        while True:
            await socket.send_json(engine.state())
            await socket.send_bytes(await asyncio.to_thread(engine.render_preview))
            await asyncio.sleep(1.0 / max(engine.store.settings.preview_fps, 1.0))
    except (WebSocketDisconnect, RuntimeError, asyncio.CancelledError):
        pass
    except Exception:  # noqa: BLE001
        log.exception("websocket push failed")
