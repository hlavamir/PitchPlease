"""Group colours A/B: macros, Auto Color palette and Swap Colors."""

from __future__ import annotations

import random
from dataclasses import dataclass, field

import numpy as np

from ..config.models import HSB


def hsv_to_rgb(h: np.ndarray, s: np.ndarray, v: np.ndarray) -> np.ndarray:
    """Vectorised HSV → RGB, all inputs 0..1 (hue wraps). Returns (..., 3)."""
    h = np.mod(h, 1.0) * 6.0
    i = np.floor(h).astype(int) % 6
    f = h - np.floor(h)
    p = v * (1.0 - s)
    q = v * (1.0 - s * f)
    t = v * (1.0 - s * (1.0 - f))
    r = np.choose(i, [v, q, p, p, t, v])
    g = np.choose(i, [t, v, v, q, p, p])
    b = np.choose(i, [p, p, t, v, v, q])
    return np.stack([r, g, b], axis=-1)


@dataclass
class AutoColors:
    """Port of ``GetAutoColors``: new random colours for A and B every 1–8 peaks.

    A and B are drawn independently, so they can be the same (a single-colour
    scene is intended to be possible).
    """

    peaks_left: int = 0
    index_a: int = 0
    index_b: int = 0
    rng_a: random.Random = field(default_factory=lambda: random.Random(666))
    rng_b: random.Random = field(default_factory=lambda: random.Random(667))
    rng_count: random.Random = field(default_factory=lambda: random.Random(666))

    def update(self, on_peak: bool, palette_size: int) -> None:
        if palette_size <= 0:
            return
        if on_peak:
            self.peaks_left -= 1
        if self.peaks_left <= 0:
            self.peaks_left = self.rng_count.randint(1, 8)
            self.index_a = self.rng_a.randrange(palette_size)
            self.index_b = self.rng_b.randrange(palette_size)


@dataclass
class GroupColors:
    a: HSB = field(default_factory=HSB)
    b: HSB = field(default_factory=HSB)
    auto: AutoColors = field(default_factory=AutoColors)

    def update(self, on_peak: bool, macros, palette: list[HSB]) -> None:
        self.auto.update(on_peak, len(palette))
        if macros.on("Auto Color Change") and palette:
            a = palette[self.auto.index_a % len(palette)]
            b = palette[self.auto.index_b % len(palette)]
        else:
            a = HSB(h=macros.value("Hue A") % 1.0, s=macros.value("Saturation A"), b=1.0)
            b = HSB(h=macros.value("Hue B") % 1.0, s=macros.value("Saturation B"), b=1.0)
        if macros.on("Swap Colors"):
            a, b = b, a
        self.a, self.b = a, b

    def get(self, group: str) -> HSB:
        return self.a if group == "A" else self.b
