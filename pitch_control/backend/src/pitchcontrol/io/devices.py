"""USB serial device discovery and matching (by serial number / VID:PID, port path as fallback)."""

from __future__ import annotations

import logging

from serial.tools import list_ports

from ..config.models import DeviceRef

log = logging.getLogger(__name__)


def list_serial_devices() -> list[dict]:
    devices = []
    # USB devices first; built-in ports (Bluetooth, debug consoles) have no VID and are listed last
    for p in sorted(list_ports.comports(), key=lambda p: (p.vid is None, p.device)):
        description = p.product or (p.description if p.description and p.description != "n/a" else None)
        label = description or p.device.rsplit("/", 1)[-1]
        if p.serial_number:
            label += f" — {p.serial_number}"
        label += f" ({p.device})"
        devices.append(
            {
                "port": p.device,
                "description": description,
                "manufacturer": p.manufacturer,
                "serial_number": p.serial_number,
                "vid": p.vid,
                "pid": p.pid,
                "label": label,
            }
        )
    return devices


def resolve_port(ref: DeviceRef) -> str | None:
    """Find the current port path of a configured device."""
    if ref is None:
        return None
    ports = list(list_ports.comports())
    if ref.serial_number:
        for p in ports:
            if p.serial_number == ref.serial_number and (ref.vid is None or p.vid == ref.vid):
                return p.device
    if ref.vid is not None and ref.pid is not None and not ref.serial_number:
        matches = [p for p in ports if p.vid == ref.vid and p.pid == ref.pid]
        if len(matches) == 1:
            return matches[0].device
    if ref.port:
        return ref.port
    return None
