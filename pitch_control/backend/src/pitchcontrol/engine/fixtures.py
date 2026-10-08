"""Runtime fixtures: pixel placement, per-pixel colour (port of ``LightFixture.Update``)
and conversion to DMX bytes through the fixture profile."""

from __future__ import annotations

import math
from dataclasses import dataclass, field

import numpy as np

from ..config.models import HSB, FixtureInstance, FixtureType
from .colors import GroupColors, hsv_to_rgb
from .phase import map_clamp


def pixel_positions(inst: FixtureInstance, count: int) -> np.ndarray:
    """UV position of every pixel: explicit list, or spread along ``length`` at ``rotation``."""
    if inst.pixel_positions:
        pts = np.array(inst.pixel_positions, dtype=np.float64)
        if len(pts) < count:  # repeat the last point if the list is short
            pts = np.vstack([pts, np.repeat(pts[-1:], count - len(pts), axis=0)])
        return pts[:count]
    t = ((np.arange(count) + 0.5) / count - 0.5) * inst.length
    a = math.radians(inst.rotation)
    direction = np.array([math.cos(a), math.sin(a)])
    return np.array(inst.position, dtype=np.float64) + t[:, None] * direction


@dataclass
class GroupBrightness:
    strobo: float  # maximum strobo brightness of the group
    idle: float  # maximum idle brightness of the group


@dataclass
class Fixture:
    inst: FixtureInstance
    ftype: FixtureType
    uv: np.ndarray = field(init=False)
    rgb: np.ndarray = field(init=False)  # last computed colours, (n, 3), 0..1
    previous_phase: float = 1.0
    strobe_trigger: bool = False  # "On Strobo": a new peak this frame on a strobo fixture
    last_output: list[int] = field(default_factory=list)  # bytes sent last frame (output monitor)

    def __post_init__(self) -> None:
        self.uv = pixel_positions(self.inst, self.pixels)
        self.rgb = np.zeros((self.pixels, 3))

    # -- effective settings (instance overrides type)
    @property
    def pixels(self) -> int:
        return self.inst.pixels or self.ftype.pixels

    @property
    def react_to_strobo(self) -> bool:
        r = self.inst.react_to_strobo
        return self.ftype.react_to_strobo if r is None else r

    @property
    def gamma(self) -> float:
        g = self.inst.gamma
        return self.ftype.gamma if g is None else g

    @property
    def strobo_color(self) -> HSB:
        return self.inst.strobo_color or self.ftype.strobo_color

    # -- per frame
    def update(
        self,
        mask: np.ndarray,
        phase: float,
        colors: GroupColors,
        group: GroupBrightness,
        macros,
    ) -> None:
        inst = self.inst
        react = self.react_to_strobo
        strobo_f = map_clamp(phase, 0.0, 0.5, 1.0, 0.0)
        if react:
            idle_f = map_clamp(phase, 0.5, 1.0, 0.0, 1.0)
        else:
            # non-strobo fixtures go dark on a peak and recover during the strobo phase (intentional)
            strobo_f, idle_f = 0.0, 1.0 - strobo_f
        b_strobo = min(max(group.strobo * strobo_f, 0.0), 1.0)
        b_idle = min(max(group.idle * idle_f, 0.0), 1.0)
        self.strobe_trigger = react and phase < self.previous_phase
        self.previous_phase = phase

        # colour of the idle phase (hue / saturation sources)
        own = colors.get(inst.group)
        hue_col = own if inst.hue_source == "group" else colors.get(inst.hue_source) if inst.hue_source in ("A", "B") else None
        sat_col = (
            own
            if inst.saturation_source == "group"
            else colors.get(inst.saturation_source)
            if inst.saturation_source in ("A", "B")
            else None
        )
        hue = inst.hue if hue_col is None else hue_col.h
        sat = inst.saturation if sat_col is None else sat_col.s

        n = self.pixels
        if inst.brightness_source == "const":
            value = np.full(n, inst.brightness)
            h = np.full(n, hue)
            s = np.full(n, sat)
        else:
            rng = inst.idle_mask_range
            if rng.macro and not macros.on(rng.macro):
                lo, hi, curve = 0.0, 1.0, 0.0
            else:
                lo, hi, curve = rng.min, rng.max, rng.curve
            m = np.clip(mask, 0.0, 1.0) ** (2.0**curve)
            remapped = lo + (hi - lo) * m
            idle_value = b_idle * remapped * own.b  # palette B = max idle brightness
            if b_idle > 0.0:
                value, h, s = idle_value, np.full(n, hue), np.full(n, sat)
            else:
                sc = self.strobo_color
                value = np.full(n, (b_strobo**3) * sc.b)
                h, s = np.full(n, sc.h), np.full(n, sc.s)

        if inst.dimmer_macro:
            value = value * macros.value(inst.dimmer_macro)
        # perceptual colours (what the preview shows); the device curve is applied on output
        self.rgb = hsv_to_rgb(h, s, np.clip(value, 0.0, 1.0))

    # -- output
    def pixel_bytes(self, fmt: str) -> list[int]:
        # the same for every transport (DMX, Art-Net, serial): perceptual -> device values per
        # channel, before the white of RGBW is taken out (light adds up in PWM duty, not perceptually)
        rgb = np.clip(self.rgb, 0.0, 1.0)
        if self.gamma != 1.0:
            rgb = rgb**self.gamma
        if fmt == "RGB":
            data = rgb
        elif fmt == "RGBW":
            w = rgb.min(axis=1, keepdims=True)
            data = np.hstack([rgb - w, w])
        else:  # "R": single channel per pixel
            data = rgb.max(axis=1, keepdims=True)
        return [int(round(x * 255)) for x in data.reshape(-1)]

    def dmx_bytes(self, macros) -> list[int]:
        out: list[int] = []
        for ch in self.ftype.channels:
            if ch.pixels:
                out += self.pixel_bytes(ch.pixels)
            elif ch.value is not None:
                value = self.inst.channel_values.get(ch.name, ch.value) if ch.name else ch.value
                out.append(int(value) & 0xFF)
            elif ch.macro:
                out.append(int(round(min(max(macros.value(ch.macro), 0.0), 1.0) * 255)))
            elif ch.shutter:
                use = self.inst.real_strobo and self.strobe_trigger
                out.append(ch.shutter.strobo if use else ch.shutter.open)
        return out
