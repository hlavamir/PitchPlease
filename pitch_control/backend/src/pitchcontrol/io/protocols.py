"""Wire formats: Enttec DMX USB Pro, Art-Net ArtDMX, PitchPlease v2.2 serial."""

from __future__ import annotations

import struct


def enttec_pro_packet(universe: bytes | bytearray) -> bytes:
    """"Output Only Send DMX Packet" (label 6): start code 0 followed by up to 512 channels."""
    data = bytes([0]) + bytes(universe[:512])
    n = len(data)
    return bytes([0x7E, 6, n & 0xFF, (n >> 8) & 0xFF]) + data + bytes([0xE7])


def artdmx_packet(universe: int, data: bytes | bytearray, sequence: int = 0) -> bytes:
    """Art-Net 4 ArtDMX packet. ``universe`` is the 15-bit port address (net/subnet/universe)."""
    payload = bytes(data[:512])
    if len(payload) % 2:
        payload += b"\x00"
    return (
        b"Art-Net\x00"
        + struct.pack("<H", 0x5000)  # OpDmx
        + struct.pack(">H", 14)  # protocol version
        + bytes([sequence & 0xFF, 0])  # sequence, physical
        + bytes([universe & 0xFF, (universe >> 8) & 0x7F])  # SubUni, Net
        + struct.pack(">H", len(payload))
        + payload
    )


def pitchpls_v2_packet(strips: list[list[int]], strips_count: int = 4, pixels_per_strip: int = 19, mode: int = 0) -> bytes:
    """v2.2 firmware frame: strips × pixels × RGB (each byte ≤ 254), mode byte, terminator 255.

    ``strips``: per strip a flat list of RGB bytes. Missing strips / pixels are sent as black.
    """
    out = bytearray()
    for i in range(strips_count):
        data = strips[i] if i < len(strips) else []
        data = list(data[: pixels_per_strip * 3]) + [0] * max(0, pixels_per_strip * 3 - len(data))
        out += bytes(min(b, 254) for b in data)
    out.append(min(max(mode, 0), 254))
    out.append(255)
    return bytes(out)
