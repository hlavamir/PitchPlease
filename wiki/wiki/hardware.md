---
date_created: 2026-07-09
date_modified: 2026-07-09
---

# Hardware

> Cross-version hardware summary. For full details on each version see [[v1]], [[v2]], [[v3]].

## Comparison Table

| | V1 | V2a | V2b | V3 |
|---|---|---|---|---|
| MCU | Arduino | Arduino | Arduino R4 | ESP32 (AZ-Delivery USB-C) |
| Strips | 2 | 2 | 4 | 4 |
| Strip type | Mono RGB (PWM) | WS2811 12V | WS2811 12V | WS2811 12V |
| Strip length | 1m | 1m | 1m | 140 cm |
| LEDs/strip | N/A | 38 | 38 | 24 |
| Control protocol | Serial 57600 | Serial 57600 | Serial 921600 | DMX512 (XLR-3) |
| PCB | Custom (Fritzing, 2019) | — | — | Custom (Fritzing, 2025) |
| Case | — | — | — | 3D printed (Rhino) |
| Status | Archived | Archived | Archived | Active |

## V3 PCB

Designed in Fritzing (`v3_esp32_dmx/hardware/250802_v3_esp32_dmx.fzz`). Key components: ESP32 (AZ-Delivery USB-C), MAX485 RS-485 transceiver module for DMX. Gerber files exported August 2025 in `v3_esp32_dmx/hardware/250805 pcb/`. Fritzing parts for both components are included in `v3_esp32_dmx/hardware/fritzing parts/`.

## V3 Case

3D-printed enclosure designed in Rhino 3D. Two design iterations:

- **v3** (`3d print/`, Aug–Sep 2025): body, front cap, end cap, inner spacer
- **v3-1** (`3d print v3-1/`, Nov–Dec 2025): revised body, front cap, end caps, inner spacers (start + end), middle block, internal frame

Files exported as STEP (`.stp`) and 3MF. The Rhino source files are `250603_v3_esp32_dmx.3dm` and `251124_v3-1_esp32_dmx.3dm`.

## V1 PCB

Designed in Fritzing (`pcbs/pitch_please_191222.fzz`), also available as DWG. Full etching layer exports (copper, mask, silk — top and bottom, mirrored and non-mirrored) included as PDF and SVG. Fabrication order in `pcbs/order_191223/`.

## MIDI Controller

The Traktor Kontrol F1 is used with the vvvv patch for live performance control (scene switching, parameter adjustment). Config file: `util/Kontrol F1 Settings.nckf1`.

## USB-DMX Interfaces (V3)

Two Enttec interfaces are used depending on setup:
- **Enttec Pro** — direct USB-DMX, used for direct connection from vvvv
- **Enttec Open** — used when routing via ArtNet + QLC+

## See Also

- [[v1]] — V1 details
- [[v2]] — V2 details
- [[v3]] — V3 details
- [[vvvv-patch]] — Software side of the signal chain

## Open Questions

- What is the LED density (LEDs/meter) of the WS2811 strips used in v1 and v2?
- What power supply specs were used for v1 and v2?
- Are the v1 and v2 physical devices still intact?
