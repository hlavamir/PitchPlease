"""Strobo / idle phase, ported from vvvv ``UpdatePhase``.

phase 0 = audio peak, 0.5 = strobo has decayed, 1 = idle fully faded in.
"""

from __future__ import annotations

from dataclasses import dataclass


def map_clamp(x: float, in_min: float, in_max: float, out_min: float, out_max: float) -> float:
    if in_max == in_min:
        return out_max if x >= in_max else out_min
    t = (x - in_min) / (in_max - in_min)
    t = min(max(t, 0.0), 1.0)
    return out_min + t * (out_max - out_min)


@dataclass
class PhaseTracker:
    time_since_peak: float = 1e6  # start in idle
    phase: float = 1.0
    strobo: float = 0.0  # 1 at the peak, 0 when strobo decayed
    idle: float = 1.0  # 0 until strobo decayed, 1 when idle fully attacked
    on_peak: bool = False

    def update(
        self,
        dt: float,
        trigger_fraction: float,
        strobo_control: float,
        strobo_decay: float,
        idle_attack: float,
        manual: bool,
    ) -> None:
        threshold = (1.0 - 0.95 * strobo_control) ** 1.5
        min_time = map_clamp(strobo_control, 0.0, 1.0, 10.0, 0.5)
        next_peak_allowed = self.time_since_peak > min_time
        audio_peak = trigger_fraction > threshold and next_peak_allowed
        manual_peak = manual and self.phase >= 0.5
        self.on_peak = audio_peak or manual_peak

        if self.on_peak:
            self.time_since_peak = 0.0
        else:
            self.time_since_peak += dt

        t = self.time_since_peak
        s = map_clamp(t, 0.0, strobo_decay, 0.0, 1.0)
        i = map_clamp(t, strobo_decay, strobo_decay + idle_attack, 0.0, 1.0)
        self.phase = 0.5 * (s + i)
        self.strobo = 1.0 - s
        self.idle = i
