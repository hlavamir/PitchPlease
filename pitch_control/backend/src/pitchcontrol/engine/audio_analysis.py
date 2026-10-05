"""Audio analysis: FFT → 32 log-spaced bands → per-band normalisation and peak detection.

Replaces VL.Audio's 128-sample FFT (375 Hz bins) with a 2048-sample FFT (23.4 Hz
bins at 48 kHz) evaluated every 512 samples, grouped into log-spaced bands
between 35 Hz and 10 kHz (see wiki: port-design, Audio Analysis).

The per-frame part (``AudioFeatures``) ports the vvvv ``AudioData`` class, but
normalises every band by its own running maximum instead of one shared maximum.
"""

from __future__ import annotations

import math
import threading
from dataclasses import dataclass, field

import numpy as np

from ..config.models import AudioSettings


# --------------------------------------------------------------------------- band layout


@dataclass
class BandLayout:
    edges: np.ndarray  # Hz, len = bands + 1
    bin_lo: np.ndarray  # first FFT bin of each band
    bin_hi: np.ndarray  # last FFT bin + 1
    centres: np.ndarray  # geometric centre frequency of each band

    @property
    def count(self) -> int:
        return len(self.centres)


def band_edges(bands: int, fmin: float, fmax: float, min_width: float) -> np.ndarray:
    """Log-spaced edges where every band is at least ``min_width`` Hz wide.

    Low bands that would be narrower than one FFT bin are widened to one bin, and
    the remaining range above is re-spread logarithmically.
    """
    edges = [fmin]
    while len(edges) <= bands:
        remaining = bands - (len(edges) - 1)
        f = edges[-1]
        ratio = (fmax / f) ** (1.0 / remaining)
        edges.append(max(f * ratio, f + min_width))
    return np.array(edges)


def make_layout(settings: AudioSettings) -> BandLayout:
    bin_hz = settings.sample_rate / settings.fft_size
    edges = band_edges(settings.bands, settings.fmin, settings.fmax, bin_hz)
    centres = np.sqrt(edges[:-1] * edges[1:])
    # a band reads every FFT bin whose centre frequency lies inside it
    bin_lo = np.ceil(edges[:-1] / bin_hz - 1e-9).astype(int)
    bin_hi = np.ceil(edges[1:] / bin_hz - 1e-9).astype(int)
    # a band without a bin centre inside reads the bin nearest to its centre
    empty = bin_hi <= bin_lo
    nearest = np.round(centres / bin_hz).astype(int)
    bin_lo = np.where(empty, nearest, bin_lo)
    bin_hi = np.where(empty, nearest + 1, bin_hi)
    return BandLayout(edges=edges, bin_lo=bin_lo, bin_hi=bin_hi, centres=centres)


def trigger_weights(centres: np.ndarray, full_hz: float, zero_hz: float) -> np.ndarray:
    """Strobo trigger weight per band: 1 below ``full_hz``, 0 above ``zero_hz``,
    falling linearly over octaves in between."""
    octaves = np.log2(np.maximum(centres, 1e-6) / full_hz)
    span = math.log2(zero_hz / full_hz)
    return np.clip(1.0 - octaves / span, 0.0, 1.0)


# --------------------------------------------------------------------------- spectrum analyser


class SpectrumAnalyzer:
    """Consumes mono samples, produces band levels (0..1) with an attack/release envelope.

    ``push`` may be called from the audio thread; ``read_frame`` from the engine.
    """

    def __init__(self, settings: AudioSettings):
        self.settings = settings
        self.layout = make_layout(settings)
        n = settings.fft_size
        self.window = np.hanning(n).astype(np.float32)
        # scale so a full-scale sine reads ~0 dB in its bin
        self.power_scale = (2.0 / self.window.sum()) ** 2
        self.ring = np.zeros(n, dtype=np.float32)
        self.pending = 0  # samples received since the last FFT
        self.envelope = np.zeros(self.layout.count)
        self.frame_max = np.zeros(self.layout.count)
        self.release_coeff = math.exp(-settings.hop / settings.sample_rate / max(settings.release_s, 1e-4))
        self.lock = threading.Lock()

    def push(self, samples: np.ndarray) -> None:
        samples = np.asarray(samples, dtype=np.float32) * self.settings.gain
        hop = self.settings.hop
        with self.lock:
            pos = 0
            while pos < len(samples):
                take = min(hop - self.pending, len(samples) - pos)
                chunk = samples[pos : pos + take]
                self.ring = np.roll(self.ring, -take)
                self.ring[-take:] = chunk
                self.pending += take
                pos += take
                if self.pending >= hop:
                    self.pending = 0
                    self._analyse()

    def _analyse(self) -> None:
        spectrum = np.fft.rfft(self.ring * self.window)
        power = (spectrum.real**2 + spectrum.imag**2) * self.power_scale
        # mean power per band (cumulative sum makes this one vectorised step)
        csum = np.concatenate(([0.0], np.cumsum(power)))
        lo, hi = self.layout.bin_lo, np.minimum(self.layout.bin_hi, len(power))
        band_power = (csum[hi] - csum[lo]) / np.maximum(hi - lo, 1)
        db = 10.0 * np.log10(band_power + 1e-20)
        level = np.clip((db - self.settings.floor_db) / self.settings.range_db, 0.0, 1.0)
        # instant attack, exponential release
        self.envelope = np.maximum(level, self.envelope * self.release_coeff)
        self.frame_max = np.maximum(self.frame_max, self.envelope)

    def read_frame(self) -> np.ndarray:
        """Highest envelope value per band since the previous call."""
        with self.lock:
            out = self.frame_max.copy()
            self.frame_max = self.envelope.copy()
        return out


# --------------------------------------------------------------------------- per-frame features (AudioData port)


@dataclass
class AudioFeatures:
    """Port of the vvvv ``AudioData`` class (per-band normalisation instead of one shared max)."""

    bands: int
    weights: np.ndarray
    normalisation_decay: float = 0.998
    normalisation_floor: float = 0.25
    norm_max: np.ndarray = field(init=False)
    peak_max: np.ndarray = field(init=False)
    peak_min: np.ndarray = field(init=False)
    values: np.ndarray = field(init=False)
    peak: np.ndarray = field(init=False)
    peak_score: np.ndarray = field(init=False)

    def __post_init__(self) -> None:
        n = self.bands
        self.norm_max = np.full(n, self.normalisation_floor)
        self.peak_max = np.full(n, 0.01)
        self.peak_min = np.zeros(n)
        self.values = np.zeros(n)
        self.peak = np.zeros(n, dtype=bool)
        self.peak_score = np.zeros(n)

    def update(self, levels: np.ndarray) -> None:
        # per-band adaptive normalisation
        self.norm_max = np.maximum.reduce(
            [self.norm_max * self.normalisation_decay, np.full_like(levels, self.normalisation_floor), levels]
        )
        v = np.clip(levels / self.norm_max, 0.0, 1.0)

        # peak detection (as AudioData.Update): compare against the previous frame's max
        old_max, old_min = self.peak_max, self.peak_min
        self.peak = v > old_max
        self.peak_score = np.where(self.peak, v - old_min, self.peak_score)
        new_min = np.clip(np.minimum(v, old_min + 0.001), 0.0, 0.99)
        decayed_max = np.clip(np.maximum(v, old_max * 0.998), 0.01, 1.0)
        self.peak_max = np.maximum(decayed_max, new_min + 0.01)
        self.peak_min = new_min
        self.values = v

    @property
    def trigger_fraction(self) -> float:
        """Weighted fraction of bands that are peaking (low end counts most)."""
        total = float(self.weights.sum())
        return float((self.weights * self.peak).sum() / total) if total > 0 else 0.0
