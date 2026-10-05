"""The 2D "scene": mask generators evaluated per pixel on the CPU.

Each generator is a pure numpy function of UV coordinates (u right, v down,
0..1, like Stride texture coordinates) and the current animation state. The
same code is evaluated for every fixture pixel (output) and for a 256×256 grid
(preview).

Ported from vvvv ``MaskGenerator`` (see wiki: vvvv-patch-logic):

- preset 0 Gradient, 1 BackAndForth, 2 RotatingLine, 3 Noise
- linear crossfade between the previous and the new preset
- the line presets are rebuilt as distance-to-line gradients (instead of a
  blurred rectangle texture)
"""

from __future__ import annotations

import math
import random
from dataclasses import dataclass, field

import numpy as np

from .noise import noise_mask

PRESET_NAMES = ["Gradient", "Back and Forth", "Rotating Line", "Noise"]


def band(u: np.ndarray, v: np.ndarray, angle_turns: float, offset: float, half_width: float, falloff: float):
    """1 inside a straight band through the scene centre, soft edges outside.

    ``angle_turns`` is the direction of the band (0 = horizontal), ``offset``
    moves the band along its normal, ``half_width`` is the flat core.
    """
    a = angle_turns * 2.0 * math.pi
    # normal of a band running along (cos a, sin a)
    nx, ny = -math.sin(a), math.cos(a)
    d = (u - 0.5) * nx + (v - 0.5) * ny - offset
    t = np.clip((np.abs(d) - half_width) / max(falloff, 1e-6), 0.0, 1.0)
    return 1.0 - t * t * (3.0 - 2.0 * t)  # 1 - smoothstep


@dataclass
class MaskParams:
    """Inputs of one frame, mostly derived from macros."""

    preset: int = 0
    shader_param: float = 0.0  # 0..1
    line_falloff: float = 0.12


@dataclass
class MaskGenerator:
    transition_s: float = 2.5
    time: float = 0.0  # animation time (resets on every peak, as in vvvv)
    time_offset: float = 0.0  # random offset applied on every peak (noise only)
    noise_offset: float = 0.0  # vertical drift of the noise
    current: int = 0
    previous: int = 0
    transition: float = 1.0  # 0 → previous preset, 1 → current preset
    rng: random.Random = field(default_factory=lambda: random.Random(666))

    def update(self, dt: float, preset: int, speed_exponent: float, shader_param: float, on_peak: bool) -> None:
        if preset != self.current:
            self.previous = self.current
            self.current = preset
            self.transition = 0.0
        self.transition = min(1.0, self.transition + dt / max(self.transition_s, 1e-6))

        if on_peak:
            # vvvv "Mask Reset": animation time restarts, noise jumps to a random time
            self.time = 0.0
            self.time_offset = self.rng.uniform(0.0, 64.0)
        else:
            self.time += dt * (2.0**speed_exponent)
        offset_speed = -1.0 + 2.0 * shader_param  # lerp(-1, 1, Shader Param)
        self.noise_offset += dt * offset_speed * 0.2

    # -- generators
    def evaluate_preset(self, preset: int, u: np.ndarray, v: np.ndarray, p: MaskParams) -> np.ndarray:
        t = self.time
        if preset == 0:  # Gradient: along v, along u when Shader Param > 0.5
            return np.clip(u if p.shader_param > 0.5 else v, 0.0, 1.0).astype(np.float64)
        if preset == 1:  # Back and Forth: a 1/3-wide band sliding ±0.25 along its normal
            orientation = -0.5 + p.shader_param  # lerp(-0.5, 0.5)
            angle = round(orientation * 4.0) * 0.125  # 45° steps (approximation of the vvvv rotation)
            offset = 0.25 * math.sin(2.0 * math.pi * (0.1 * t + 0.75))
            return band(u, v, angle, offset, half_width=1.0 / 6.0, falloff=p.line_falloff)
        if preset == 2:  # Rotating Line: band through the centre rotating at 0.1 turns per time unit
            thickness = 0.5 + p.shader_param  # lerp(0.5, 1.5) in vvvv's [-1, 1] texture space
            angle = 0.1 * t + 0.25
            return band(u, v, angle, 0.0, half_width=thickness / 4.0, falloff=p.line_falloff)
        # Noise
        return noise_mask(u, v, time=(t + self.time_offset) * 0.2, offset=self.noise_offset)

    def evaluate(self, u: np.ndarray, v: np.ndarray, p: MaskParams) -> np.ndarray:
        cur = self.evaluate_preset(self.current, u, v, p)
        if self.transition >= 1.0 or self.previous == self.current:
            return cur
        prev = self.evaluate_preset(self.previous, u, v, p)
        return prev + (cur - prev) * self.transition


# --------------------------------------------------------------------------- audio → mask


def sample_linear_clamp(table: np.ndarray, x: np.ndarray) -> np.ndarray:
    """Sample a 1D texture (texel centres at (i + 0.5) / n) with linear filtering and clamping."""
    n = len(table)
    pos = np.clip(np.asarray(x) * n - 0.5, 0.0, n - 1)
    return np.interp(pos, np.arange(n), table)


@dataclass
class PeaksMap:
    """Port of ``AddAudioDataToIdleMask``: per-band values that the mask brightness looks up."""

    bands: int
    dampened: np.ndarray = field(init=False)
    blue: np.ndarray = field(init=False)
    control: float = 0.0

    def __post_init__(self) -> None:
        self.dampened = np.zeros(self.bands)
        self.blue = np.zeros(self.bands)

    def update(self, peak: np.ndarray, peak_score: np.ndarray, reactivity: float) -> None:
        g = min(max(reactivity, 0.0), 1.0)
        damper = min(1.0 - g**4, 0.9999)
        sort_amount = (1.0 - g) ** 4
        exponent = 2.0 ** (1.0 - 2.0 * g)  # map g 0..1 → 1..-1, then 2^x
        sorted_desc = np.sort(self.dampened)[::-1]
        mixed = self.dampened + (sorted_desc - self.dampened) * sort_amount
        current = peak.astype(np.float64) * peak_score
        self.dampened = np.maximum(current, mixed * damper)
        self.blue = np.clip(self.dampened, 0.0, 1.0) ** exponent
        self.control = 1.0 - (1.0 - min(max(3.0 * g, 0.0), 1.0)) ** 4

    def apply(self, mask: np.ndarray) -> np.ndarray:
        """``MixIdleMaskWithPeaksMap`` with FilterBase's Control lerp."""
        looked_up = sample_linear_clamp(self.blue, 1.0 - mask)
        return mask + (looked_up - mask) * self.control


def mixed_mask(gen: MaskGenerator, peaks: PeaksMap, u, v, params: MaskParams, symmetry: bool) -> np.ndarray:
    out = peaks.apply(gen.evaluate(u, v, params))
    if symmetry:
        out = 0.5 * (out + peaks.apply(gen.evaluate(1.0 - u, v, params)))
    return out
