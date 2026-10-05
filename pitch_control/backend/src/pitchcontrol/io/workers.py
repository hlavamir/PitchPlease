"""Background writer threads: the engine hands over the latest frame and never blocks on I/O."""

from __future__ import annotations

import logging
import threading
import time

import serial

from ..config.models import DeviceRef
from .devices import resolve_port

log = logging.getLogger(__name__)


class LatestFrameWorker:
    """Keeps only the newest submitted frame and writes it from its own thread."""

    name = "output"

    def __init__(self) -> None:
        self._frame: object | None = None
        self._event = threading.Event()
        self._stop = threading.Event()
        self._thread = threading.Thread(target=self._run, name=self.name, daemon=True)
        self.connected = False
        self.last_error: str | None = None
        self.frames_sent = 0

    def start(self) -> None:
        self._thread.start()

    def stop(self) -> None:
        self._stop.set()
        self._event.set()
        self._thread.join(timeout=2)
        self.close()

    def submit(self, frame: object) -> None:
        self._frame = frame
        self._event.set()

    def _run(self) -> None:
        while not self._stop.is_set():
            self._event.wait(timeout=0.5)
            self._event.clear()
            frame = self._frame
            if frame is None or self._stop.is_set():
                continue
            try:
                if not self.connected:
                    self.open()
                self.write(frame)
                self.frames_sent += 1
            except Exception as exc:  # noqa: BLE001 - hardware errors must never kill the thread
                if self.connected or self.last_error != str(exc):
                    log.warning("%s: %s", self.name, exc)
                self.last_error = str(exc)
                self.close()
                time.sleep(1.0)  # retry rate while the device is missing

    def status(self) -> dict:
        return {"connected": self.connected, "error": self.last_error, "frames": self.frames_sent}

    # -- to implement
    def open(self) -> None:
        self.connected = True

    def write(self, frame: object) -> None:
        raise NotImplementedError

    def close(self) -> None:
        self.connected = False


class SerialWorker(LatestFrameWorker):
    def __init__(self, ref: DeviceRef, baudrate: int, name: str) -> None:
        self.name = name
        self.ref = ref
        self.baudrate = baudrate
        self.port: serial.Serial | None = None
        super().__init__()

    def open(self) -> None:
        path = resolve_port(self.ref)
        if not path:
            raise ConnectionError("device not found (check the Output page)")
        self.port = serial.Serial(path, self.baudrate, timeout=0, write_timeout=1)
        self.connected = True
        self.last_error = None
        log.info("%s: opened %s at %d baud", self.name, path, self.baudrate)

    def write(self, frame: object) -> None:
        assert self.port is not None and isinstance(frame, (bytes, bytearray))
        self.port.write(frame)

    def close(self) -> None:
        if self.port is not None:
            try:
                self.port.close()
            except Exception:  # noqa: BLE001
                pass
        self.port = None
        self.connected = False
