"""Audio input via sounddevice (PortAudio: CoreAudio on macOS, ASIO/WASAPI on Windows)."""

from __future__ import annotations

import logging
import os
from typing import Callable

import numpy as np

log = logging.getLogger(__name__)

# ASIO support in sounddevice's bundled PortAudio on Windows must be enabled before import
os.environ.setdefault("SD_ENABLE_ASIO", "1")

try:
    import sounddevice as sd
except OSError as exc:  # PortAudio missing
    sd = None
    log.error("sounddevice unavailable: %s", exc)


def list_input_devices() -> list[dict]:
    if sd is None:
        return []
    apis = sd.query_hostapis()
    out = []
    for i, d in enumerate(sd.query_devices()):
        if d["max_input_channels"] > 0:
            api = apis[d["hostapi"]]["name"]
            out.append(
                {
                    "index": i,
                    "name": d["name"],
                    "hostapi": api,
                    "label": f"{d['name']} ({api})",
                    "channels": d["max_input_channels"],
                    "default_samplerate": d["default_samplerate"],
                }
            )
    return out


def find_device(name: str | None) -> int | None:
    """Index of the first input device whose "name (host api)" label contains ``name``."""
    if not name:
        return None
    for d in list_input_devices():
        if name.lower() in d["label"].lower():
            return d["index"]
    log.warning("audio device '%s' not found, using the system default", name)
    return None


class AudioInput:
    def __init__(self, device: str | None, channels: list[int], sample_rate: int, on_samples: Callable[[np.ndarray], None]):
        self.device_name = device
        self.channels = [c for c in channels if c >= 1] or [1]
        self.sample_rate = sample_rate
        self.on_samples = on_samples
        self.stream = None
        self.error: str | None = None
        self.level = 0.0  # peak input level of the last block (for the Inputs page meter)

    def start(self) -> None:
        if sd is None:
            self.error = "sounddevice / PortAudio not available"
            return
        try:
            index = find_device(self.device_name)
            info = sd.query_devices(index if index is not None else sd.default.device[0])
            needed = max(self.channels)
            if needed > info["max_input_channels"]:
                raise ValueError(f"device has {info['max_input_channels']} inputs, channel {needed} requested")
            self.stream = sd.InputStream(
                device=index,
                channels=needed,
                samplerate=self.sample_rate,
                dtype="float32",
                callback=self._callback,
            )
            self.stream.start()
            self.error = None
            log.info("audio input: %s, channels %s, %d Hz", info["name"], self.channels, self.sample_rate)
        except Exception as exc:  # noqa: BLE001
            self.error = str(exc)
            log.error("audio input failed: %s", exc)
            self.stream = None

    def _callback(self, indata, frames, time_info, status) -> None:  # audio thread
        if status:
            log.debug("audio status: %s", status)
        mono = indata[:, [c - 1 for c in self.channels]].sum(axis=1)
        self.level = float(np.abs(mono).max()) if len(mono) else 0.0
        self.on_samples(mono)

    def stop(self) -> None:
        if self.stream is not None:
            try:
                self.stream.stop()
                self.stream.close()
            except Exception:  # noqa: BLE001
                pass
        self.stream = None

    def status(self) -> dict:
        return {"running": self.stream is not None, "error": self.error, "level": self.level}
