"""Standalone desktop app: engine + server in the background, UI in a native window.

Data folder (``config/`` + ``logs/``), first match wins:

1. ``--data <folder>``
2. a path written in ``~/Documents/PitchControl/data_folder.txt``
3. the repo's ``pitch_control/`` folder: the source tree when run from source, or
   the repo path recorded at build time (``build_info.json``) — so rigs and
   fixtures edited in the app land in git
4. ``~/Documents/PitchControl`` (fallback, e.g. for a build made on GitHub)

Missing default files are copied in from the bundled config (never overwriting)
only in the fallback folder or a folder without a config yet; a repo config is
used as it is.

Closing the window stops the engine.
"""

from __future__ import annotations

import argparse
import atexit
import json
import logging
import os
import shutil
import socket
import sys
import threading
import time
import urllib.request
import webbrowser
from pathlib import Path

import uvicorn

from .config.loader import ConfigStore
from .engine.engine import Engine
from .logsetup import setup_logging
from .server.app import create_app

APP_NAME = "PitchControl"
DEFAULT_PORT = 8420
log = logging.getLogger("pitchcontrol.desktop")


def resource_dir() -> Path:
    """Folder with the bundled ``default_config`` and ``frontend_dist`` (PyInstaller or source tree)."""
    if getattr(sys, "frozen", False):
        return Path(getattr(sys, "_MEIPASS", Path(sys.executable).parent))
    return Path(__file__).resolve().parents[3]  # pitch_control/


def bundled_config(res: Path) -> Path:
    return res / "default_config" if (res / "default_config").exists() else res / "config"


def bundled_frontend(res: Path) -> Path:
    return res / "frontend_dist" if (res / "frontend_dist").exists() else res / "frontend" / "dist"


def user_dir() -> Path:
    return Path.home() / "Documents" / APP_NAME


def repo_folder(res: Path) -> Path | None:
    """The repo's ``pitch_control/`` folder, if it exists on this machine."""
    if not getattr(sys, "frozen", False):
        candidate = res  # running from source: resource_dir() is pitch_control/
    else:
        try:
            info = json.loads((res / "build_info.json").read_text(encoding="utf-8"))
            candidate = Path(info["pitch_control_dir"])
        except (OSError, ValueError, KeyError):
            return None
    return candidate if (candidate / "config").is_dir() else None


def choose_data_dir(arg: Path | None, res: Path) -> tuple[Path, str]:
    """Return (data folder, reason)."""
    if arg is not None:
        return arg, "--data"
    pointer = user_dir() / "data_folder.txt"
    if pointer.exists():
        target = Path(pointer.read_text(encoding="utf-8").strip()).expanduser()
        if (target / "config").is_dir():
            return target, f"from {pointer}"
    repo = repo_folder(res)
    if repo is not None:
        return repo, "repo"
    return user_dir(), "fallback"


def install_default_config(src: Path, dst: Path) -> list[Path]:
    """Copy every default file that is missing in ``dst``; never overwrite."""
    copied = []
    for file in src.rglob("*"):
        if not file.is_file() or "state" in file.relative_to(src).parts:
            continue
        target = dst / file.relative_to(src)
        if not target.exists():
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(file, target)
            copied.append(target)
    return copied


def free_port(preferred: int) -> int:
    for port in [preferred, *range(preferred + 1, preferred + 20)]:
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            if s.connect_ex(("127.0.0.1", port)) != 0:
                return port
    with socket.socket() as s:
        s.bind(("127.0.0.1", 0))
        return s.getsockname()[1]


def wait_until_up(url: str, timeout: float = 20.0) -> bool:
    end = time.monotonic() + timeout
    while time.monotonic() < end:
        try:
            urllib.request.urlopen(f"{url}/api/state", timeout=1).read()
            return True
        except OSError:
            time.sleep(0.2)
    return False


def main() -> None:
    # a windowed app (no console) has no stdout/stderr; uvicorn's logging needs them
    if sys.stdout is None:
        sys.stdout = open(os.devnull, "w")
    if sys.stderr is None:
        sys.stderr = open(os.devnull, "w")

    parser = argparse.ArgumentParser(description="PitchControl desktop app")
    parser.add_argument("--data", type=Path, default=None, help="folder with config/ and logs/ (default: the repo)")
    parser.add_argument("--port", type=int, default=DEFAULT_PORT)
    parser.add_argument("--host", default="127.0.0.1", help="use 0.0.0.0 to allow a phone on the LAN")
    parser.add_argument("--no-hardware", action="store_true", help="run without audio, MIDI and outputs")
    parser.add_argument("--no-window", action="store_true", help="no window: serve the UI and open the browser")
    parser.add_argument("--smoke-test", action="store_true", help="start, check the API, quit (for builds)")
    args, _ = parser.parse_known_args()  # macOS may add -psn_… arguments

    res = resource_dir()
    data, reason = choose_data_dir(args.data, res)
    config_dir = data / "config"
    setup_logging(data / "logs")
    copied = []
    # defaults go only into the Documents fallback or a brand-new folder, never into an existing config
    if reason == "fallback" or not (config_dir / "settings.json").exists():
        copied = install_default_config(bundled_config(res), config_dir)
    log.info("%s starting, data folder %s (%s, %d default files installed)", APP_NAME, data, reason, len(copied))

    store = ConfigStore(config_dir)
    store.load_all()
    engine = Engine(store, enable_hardware=not args.no_hardware)
    engine.start()

    port = free_port(args.port)
    url = f"http://127.0.0.1:{port}"
    app = create_app(engine, static_dir=bundled_frontend(res), desktop={"url": url, "data_dir": str(data)})
    server = uvicorn.Server(uvicorn.Config(app, host=args.host, port=port, log_level="warning"))
    server_thread = threading.Thread(target=server.run, name="server", daemon=True)
    server_thread.start()

    stopped = threading.Event()

    def shutdown() -> None:
        if stopped.is_set():
            return
        stopped.set()
        server.should_exit = True
        server_thread.join(timeout=5)
        engine.stop()
        log.info("%s stopped", APP_NAME)

    atexit.register(shutdown)

    if not wait_until_up(url):
        log.error("server did not start on %s", url)
        shutdown()
        sys.exit(1)
    log.info("UI at %s", url)

    if args.smoke_test:
        ok = b"fixtures" in urllib.request.urlopen(f"{url}/api/state", timeout=2).read()
        ok = ok and b"<div id=\"root\">" in urllib.request.urlopen(url, timeout=2).read()
        print("SMOKE TEST", "OK" if ok else "FAILED", url)
        shutdown()
        sys.exit(0 if ok else 1)

    if args.no_window:
        webbrowser.open(url)
        try:
            server_thread.join()
        except KeyboardInterrupt:
            pass
        shutdown()
        return

    import webview  # imported late: only the window needs it

    # open maximized: fits any screen (the UI is laid out for a 14" MacBook and up)
    window = webview.create_window(
        APP_NAME, url, width=1440, height=900, min_size=(1000, 700), background_color="#0e0f12", maximized=True
    )
    # on macOS, Quit (Cmd+Q) fires "closing" and then ends the process without returning
    # from webview.start(); pywebview waits for "closing" handlers, so stop the engine there
    window.events.closing += shutdown
    window.events.closed += shutdown
    webview.start()  # blocks until the window is closed
    shutdown()


if __name__ == "__main__":
    main()
