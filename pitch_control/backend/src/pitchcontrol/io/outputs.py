"""Output manager: Enttec DMX USB Pro, Art-Net and PitchPlease v2.2 serial."""

from __future__ import annotations

import logging
import socket
import time

from ..config.models import OutputSettings
from .protocols import artdmx_packet, enttec_pro_packet, pitchpls_v2_packet
from .workers import LatestFrameWorker, SerialWorker

log = logging.getLogger(__name__)

ENTTEC_BAUD = 57600  # ignored by the FTDI chip of the Enttec Pro, any value works


class ArtNetWorker(LatestFrameWorker):
    name = "artnet"

    def __init__(self) -> None:
        self.sock: socket.socket | None = None
        super().__init__()

    def open(self) -> None:
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        self.sock.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)
        self.connected = True
        self.last_error = None

    def write(self, frame: object) -> None:
        """``frame``: list of (ip, ArtDMX packet)."""
        assert self.sock is not None
        for ip, packet in frame:  # type: ignore[union-attr]
            self.sock.sendto(packet, (ip, 6454))

    def close(self) -> None:
        if self.sock is not None:
            self.sock.close()
        self.sock = None
        self.connected = False


class OutputManager:
    def __init__(self, settings: OutputSettings):
        self.settings = settings
        # parallel to settings.enttec; None = disabled
        self.enttec: list[SerialWorker | None] = []
        self._enttec_errors: dict[int, str] = {}  # interfaces that were not started, and why
        self.artnet: ArtNetWorker | None = None
        self.v2: SerialWorker | None = None
        self._sequence = 0
        self._last_v2: bytes | None = None
        self._last_v2_time = 0.0

    def start(self) -> None:
        s = self.settings
        self.enttec, self._enttec_errors = [], {}
        taken: dict[str, int] = {}  # device -> interface that uses it
        for i, e in enumerate(s.enttec):
            worker = None
            if e.enabled:
                key = e.device.serial_number or e.device.port
                if key and key in taken:
                    # two writers on one port would garble both streams
                    self._enttec_errors[i] = f"same device as interface {taken[key] + 1}"
                    log.warning("enttec%d: %s, not started", i + 1, self._enttec_errors[i])
                else:
                    if key:
                        taken[key] = i
                    worker = SerialWorker(e.device, ENTTEC_BAUD, f"enttec{i + 1}")
                    worker.start()
            self.enttec.append(worker)
        if s.artnet.enabled:
            self.artnet = ArtNetWorker()
            self.artnet.start()
        if s.pitchpls_v2.enabled:
            self.v2 = SerialWorker(s.pitchpls_v2.device, s.pitchpls_v2.baudrate, "pitchpls_v2")
            self.v2.start()

    def stop(self) -> None:
        for w in (*self.enttec, self.artnet, self.v2):
            if w is not None:
                w.stop()
        self.enttec, self._enttec_errors = [], {}
        self.artnet = self.v2 = None

    def restart(self, settings: OutputSettings) -> None:
        self.stop()
        self.settings = settings
        self.start()

    def send(self, universes: dict[int, bytearray], v2_strips: list[list[int]]) -> None:
        s = self.settings
        for worker, e in zip(self.enttec, s.enttec):
            if worker is not None:
                worker.submit(enttec_pro_packet(universes.get(e.universe, bytes(512))))
        if self.artnet is not None and s.artnet.targets:
            self._sequence = self._sequence % 255 + 1
            packets = []
            for t in s.artnet.targets:
                port_address = t.artnet_universe if t.artnet_universe is not None else t.universe
                data = universes.get(t.universe, bytes(512))
                packets.append((t.ip, artdmx_packet(port_address, data, self._sequence)))
            self.artnet.submit(packets)
        if self.v2 is not None:
            frame = pitchpls_v2_packet(v2_strips, s.pitchpls_v2.strips, s.pitchpls_v2.pixels_per_strip, s.pitchpls_v2.mode)
            now = time.monotonic()
            # like vvvv: send on change, and at least every 2 s as keep-alive
            if frame != self._last_v2 or now - self._last_v2_time > 2.0:
                self.v2.submit(frame)
                self._last_v2, self._last_v2_time = frame, now

    def status(self) -> dict:
        return {
            # one entry per configured interface, None where it is off
            "enttec": [self._enttec_status(i, w) for i, w in enumerate(self.enttec)],
            "artnet": self.artnet.status() if self.artnet else None,
            "pitchpls_v2": self.v2.status() if self.v2 else None,
        }

    def _enttec_status(self, i: int, worker: SerialWorker | None) -> dict | None:
        if worker is not None:
            return worker.status()
        if i in self._enttec_errors:
            return {"connected": False, "error": self._enttec_errors[i], "frames": 0}
        return None
