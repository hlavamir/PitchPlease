"""Fog machines: periodic bursts plus a manual trigger macro."""

from __future__ import annotations

from ..config.models import FogMachine


class FogController:
    def __init__(self) -> None:
        self.time = 0.0
        self.active: dict[str, bool] = {}

    def update(self, dt: float, machines: list[FogMachine], macros, universes: dict[int, bytearray]) -> None:
        self.time += dt
        self.active = {}
        for m in machines:
            on = False
            if m.enabled and m.interval_s > 0:
                on = (self.time % m.interval_s) < m.duration_s
            if m.manual_macro and macros.on(m.manual_macro):
                on = True
            self.active[m.name] = on
            uni = universes.setdefault(m.universe, bytearray(512))
            uni[m.channel - 1] = m.on_value if on else m.off_value
