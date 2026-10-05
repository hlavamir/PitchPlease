"""MIDI controller input: CC messages → macros, using a ``controllers/*.json`` mapping."""

from __future__ import annotations

import logging
import time
from collections import deque

from ..config.models import Controller

log = logging.getLogger(__name__)

try:
    import mido
except ImportError:  # pragma: no cover
    mido = None


def list_midi_inputs() -> list[str]:
    if mido is None:
        return []
    try:
        return list(mido.get_input_names())
    except Exception as exc:  # noqa: BLE001
        log.warning("cannot list MIDI inputs: %s", exc)
        return []


class MidiInput:
    def __init__(self, controller: Controller | None, port_override: str | None, macros):
        self.controller = controller
        self.port_override = port_override
        self.macros = macros
        self.port = None
        self.port_name: str | None = None
        self.error: str | None = None
        self.by_cc = {m.cc: m for m in controller.mappings} if controller else {}
        self.recent: deque[dict] = deque(maxlen=20)  # MIDI monitor for the Inputs page
        self.received = 0
        self._ignored_channels: set[int] = set()

    def start(self) -> None:
        if mido is None or self.controller is None:
            return
        match = (self.port_override or self.controller.port_match or "").lower()
        names = list_midi_inputs()
        name = next((n for n in names if match and match in n.lower()), None)
        if name is None:
            self.error = f"MIDI input matching '{match}' not found"
            log.warning(self.error)
            return
        try:
            self.port = mido.open_input(name, callback=self.handle)
            self.port_name = name
            self.error = None
            log.info("MIDI input: %s (controller '%s')", name, self.controller.name)
        except Exception as exc:  # noqa: BLE001
            self.error = str(exc)
            log.error("MIDI input failed: %s", exc)

    def handle(self, msg) -> None:
        if msg.type in ("clock", "active_sensing"):
            return
        self.received += 1
        entry = {"t": round(time.time(), 2), "text": str(msg), "macro": None, "note": ""}
        self.recent.append(entry)
        if msg.type != "control_change" or self.controller is None:
            entry["note"] = "not a CC message"
            return
        if msg.channel != self.controller.channel - 1:
            entry["note"] = f"channel {msg.channel + 1}, mapping expects {self.controller.channel}"
            if msg.channel not in self._ignored_channels:
                self._ignored_channels.add(msg.channel)
                log.warning(
                    "MIDI: ignoring CC on channel %d (controller '%s' is mapped to channel %d)",
                    msg.channel + 1,
                    self.controller.name,
                    self.controller.channel,
                )
            return
        mapping = self.by_cc.get(msg.control)
        if mapping is None:
            entry["note"] = f"CC {msg.control} not mapped"
            return
        entry["macro"] = mapping.macro
        value = msg.value / 127.0
        if mapping.mode == "absolute":
            self.macros.set(mapping.macro, value)
        elif mapping.mode == "momentary":
            self.macros.set(mapping.macro, 1.0 if msg.value > 63 else 0.0)
        elif mapping.mode == "toggle" and msg.value > 63:
            self.macros.toggle(mapping.macro)

    def stop(self) -> None:
        if self.port is not None:
            try:
                self.port.close()
            except Exception:  # noqa: BLE001
                pass
        self.port = None

    def status(self) -> dict:
        return {
            "port": self.port_name,
            "error": self.error,
            "controller": self.controller.name if self.controller else None,
            "channel": self.controller.channel if self.controller else None,
            "received": self.received,
            "recent": list(self.recent)[::-1],
        }
