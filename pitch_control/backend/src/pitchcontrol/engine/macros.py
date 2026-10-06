"""Macros: every controllable parameter, fed by the UI, MIDI and scenes.

A macro stores a *control value* in 0..1 (what a fader or MIDI CC sets). The
*value in range* maps it to ``min..max`` after quantising to ``steps``, exactly
like the vvvv ``Macro`` record.
"""

from __future__ import annotations

import logging
import math
import threading
from dataclasses import dataclass
from typing import Literal

log = logging.getLogger(__name__)

Kind = Literal["fader", "toggle", "button", "momentary", "radio"]
Page = Literal["general", "dimmers", "scenes", "system"]

# pages the MIDI controller can drive; the "Page …" radio macros select the active one
CONTROL_PAGES = ["general", "dimmers"]


@dataclass(frozen=True)
class MacroDef:
    name: str
    min: float = 0.0
    max: float = 1.0
    steps: int = 128
    kind: Kind = "fader"
    page: Page = "general"
    default: float = 0.0  # control value
    display_name: str = ""
    radio_group: str | None = None
    legacy_index: int | None = None  # index in the vvvv macros.ini / scene files
    # apply on release (UI) / once the knob stops moving (MIDI) instead of continuously,
    # so a colour does not sweep through the whole gradient during a show
    deferred: bool = False
    # how the UI shows the value in range: value × display_scale, with unit and decimals
    display_scale: float = 1.0
    unit: str = ""
    decimals: int = 2

    @property
    def label(self) -> str:
        return self.display_name or self.name


def _defs() -> list[MacroDef]:
    d: list[MacroDef] = [
        MacroDef("Strobo Decay", 0.1, 3.0, legacy_index=0),
        MacroDef("Strobo Brightness", legacy_index=1),
        MacroDef("Idle Attack", 0.1, 20.0, legacy_index=2),
        MacroDef("Idle Brightness", legacy_index=3),
        MacroDef("Hue A", -0.5, 0.5, legacy_index=4, deferred=True, display_scale=360, unit="°", decimals=0),
        # renamed from "Glitches": it sets how much the audio drives the mask (see vvvv-patch-logic)
        MacroDef("Audio Reactivity", legacy_index=5),
        MacroDef("Hue B", -0.5, 0.5, legacy_index=6, deferred=True, display_scale=360, unit="°", decimals=0),
        MacroDef("Strobo", 0.0, 0.95, legacy_index=7),
        MacroDef("Saturation A", default=1.0, deferred=True, display_scale=100, unit="%", decimals=0),
        MacroDef("Saturation B", default=1.0, deferred=True, display_scale=100, unit="%", decimals=0),
        MacroDef("Swap Colors", steps=2, kind="toggle", legacy_index=8),
        MacroDef("Auto Color Change", steps=2, kind="toggle", legacy_index=9),
        MacroDef("Vertical Symmetry", steps=2, kind="toggle", legacy_index=10),
        MacroDef("Strobo Bright. A", legacy_index=16),
        MacroDef("Idle Bright. A", legacy_index=17),
        MacroDef("Strobo Bright. B", legacy_index=18),
        MacroDef("Idle Bright. B", legacy_index=19),
        MacroDef("Shader Speed", -2.0, 2.0, legacy_index=20),
        MacroDef("Shader Param", legacy_index=21),
        MacroDef("Invert Discoball", steps=2, kind="toggle", legacy_index=29),
        MacroDef("Fog Machine", steps=2, kind="momentary", legacy_index=30),
        MacroDef("Manual Strobo", steps=2, kind="momentary", legacy_index=31),
    ]
    for i, letter in enumerate("ABCD"):
        d.append(
            MacroDef(
                f"Preset {letter}",
                steps=2,
                kind="radio",
                radio_group="preset",
                default=1.0 if i == 0 else 0.0,
                legacy_index=12 + i,
            )
        )
    dimmer_names = [
        "D PitchPls! v3",
        "D PitchPls! v2",
        "D Pinspots",
        "D Panels DJ",
        "D Panel Back",
        "D Chillout Z",
    ]
    for i in range(16):
        d.append(
            MacroDef(
                f"Dimmer {i + 1:02d}",
                page="dimmers",
                default=1.0,
                display_name=dimmer_names[i] if i < len(dimmer_names) else "",
                legacy_index=32 + i,
            )
        )
    # active control page (UI tab / controller page), like the vvvv "General" / "Dimmers" tab macros
    for i, page in enumerate(CONTROL_PAGES):
        d.append(
            MacroDef(
                f"Page {page.title()}",
                steps=2,
                kind="radio",
                radio_group="page",
                page="system",
                default=1.0 if i == 0 else 0.0,
                legacy_index=92 + i,
            )
        )
    for i in range(8):
        d.append(MacroDef(f"Scene {i + 1} Save", steps=2, kind="button", page="scenes", legacy_index=64 + 2 * i))
        d.append(MacroDef(f"Scene {i + 1} Load", steps=2, kind="button", page="scenes", legacy_index=65 + 2 * i))
    return d


MACRO_DEFS: list[MacroDef] = _defs()


def quantise(control: float, steps: int) -> float:
    control = min(max(control, 0.0), 1.0)
    if steps and steps > 1:
        return math.floor(control * (steps - 1) + 0.5) / (steps - 1)  # round half up
    return control


class MacroBank:
    """Thread-safe store of macro control values."""

    def __init__(self, defs: list[MacroDef] | None = None):
        self.defs: dict[str, MacroDef] = {m.name: m for m in (defs or MACRO_DEFS)}
        self._values: dict[str, float] = {m.name: m.default for m in self.defs.values()}
        self._pending_buttons: set[str] = set()
        self._deferred: dict[str, tuple[float, float]] = {}  # name -> (value, time of last change)
        self._lock = threading.Lock()
        self.version = 0  # increments on every change (used for change detection)

    # -- reading
    def control(self, name: str) -> float:
        return self._values.get(name, 0.0)

    def value(self, name: str) -> float:
        """Value in range (quantised, mapped to min..max)."""
        m = self.defs.get(name)
        if m is None:
            return 0.0
        return m.min + quantise(self._values[name], m.steps) * (m.max - m.min)

    def on(self, name: str) -> bool:
        return self._values.get(name, 0.0) > 0.5

    def snapshot(self) -> dict[str, float]:
        with self._lock:
            return dict(self._values)

    # -- writing
    def set(self, name: str, control: float) -> bool:
        m = self.defs.get(name)
        if m is None:
            log.warning("unknown macro '%s'", name)
            return False
        control = min(max(float(control), 0.0), 1.0)
        with self._lock:
            if m.kind == "radio" and m.radio_group:
                if control <= 0.5:
                    return True  # a radio button cannot be switched off directly
                for other in self.defs.values():
                    if other.radio_group == m.radio_group:
                        self._values[other.name] = 0.0
                control = 1.0
            if m.kind == "button":
                if control > 0.5:
                    self._pending_buttons.add(name)
                return True
            self._values[name] = control
            self.version += 1
        return True

    def toggle(self, name: str) -> None:
        self.set(name, 0.0 if self.on(name) else 1.0)

    def set_deferred(self, name: str, control: float, now: float) -> None:
        """Remember a value from a moving knob; ``apply_settled`` applies it once the knob rests."""
        if name not in self.defs:
            return
        with self._lock:
            self._deferred[name] = (min(max(float(control), 0.0), 1.0), now)

    def apply_settled(self, now: float, settle_s: float) -> None:
        with self._lock:
            ready = [n for n, (_, t) in self._deferred.items() if now - t >= settle_s]
            values = {n: self._deferred.pop(n)[0] for n in ready}
        for name, value in values.items():
            self.set(name, value)

    def cancel_deferred(self, name: str) -> None:
        with self._lock:
            self._deferred.pop(name, None)

    def pending(self) -> dict[str, float]:
        with self._lock:
            return {n: v for n, (v, _) in self._deferred.items()}

    def take_buttons(self) -> set[str]:
        """Return and clear the buttons pressed since the last call."""
        with self._lock:
            pressed, self._pending_buttons = self._pending_buttons, set()
        return pressed

    def load(self, values: dict[str, float], source: str = "") -> None:
        unknown = [k for k in values if k not in self.defs]
        if unknown:
            log.warning("%s: unknown macros ignored: %s", source or "macro snapshot", ", ".join(unknown))
        with self._lock:
            for name, control in values.items():
                m = self.defs.get(name)
                if m is None or m.kind == "button":
                    continue
                self._values[name] = min(max(float(control), 0.0), 1.0)
            self.version += 1

    @property
    def control_page(self) -> str:
        return CONTROL_PAGES[self.radio_index("page")]

    def set_control_page(self, page: str) -> None:
        if page in CONTROL_PAGES:
            self.set(f"Page {page.title()}", 1.0)

    def radio_index(self, group: str) -> int:
        members = [m for m in self.defs.values() if m.radio_group == group]
        for i, m in enumerate(members):
            if self._values[m.name] > 0.5:
                return i
        return 0


def from_legacy_values(values: list[float]) -> dict[str, float]:
    """Convert the 128 control values of a vvvv scene / macros.ini to ``{macro name: value}``."""
    out: dict[str, float] = {}
    for m in MACRO_DEFS:
        if m.legacy_index is not None and m.legacy_index < len(values) and m.kind != "button":
            out[m.name] = values[m.legacy_index]
    return out
