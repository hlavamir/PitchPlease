---
date_created: 2026-07-09
date_modified: 2026-10-08
---

# Hardware

> Cross-version hardware summary. For full details on each version see [[v1]], [[v2]], [[v3]].

## Comparison Table

| | V1 | V2.0 | V2.2 | V3 |
|---|---|---|---|---|
| MCU | Arduino Uno R3 | Arduino | Arduino R4 | AZDelivery ESP32-WROOM-32 (USB-C, CP2102) |
| Strips | 2 | 2 | 4 | 4 |
| Strip type | Basic RGB, non-addressable (4-pin R/G/B/+) | WS2811 12V, 60 LEDs/m | WS2811 12V, 60 LEDs/m | WS2811 12V, 60 LEDs/m |
| Strip length | 1m | 1m profile (2×19 segments/tube) | 1m profile (2×19 segments/tube) | 130 cm tube (24 segments/strip) |
| LEDs/strip | N/A | 38 (2 physical strips chained) | 38 (2 physical strips chained) | 72 (24 segments × 3 LEDs/segment) |
| Control protocol | Serial 57600 | Serial 57600 | Serial 921600 | DMX512 (XLR-3) |
| PSU | — | 12V 3A | 12V 6A | 12V 10A |
| PCB | Custom (Fritzing, 2019) | — | — | Custom (Fritzing, 2025) |
| Case | — | — | — | 3D printed (Rhino) |
| Status | Archived (1 device intact) | Archived (backup) | Archived (shoebox prototype) | Active |

## V3 PCB

Designed in Fritzing, under `v3_esp32_dmx/pcb/`. Key components: ESP32 (AZ-Delivery USB-C), 2× MAX485 RS-485 transceiver modules for DMX In/Out, SN74AHCT125 level-shifting buffer. Three sketch revisions:

- **v3-0** (`250802_v3-0_esp32_dmx.fzz`, Aug 2025): original board. Gerbers in `250805 pcb v3-0/`.
- **v3-2-0** (`260822_v3-2-0_esp32_dmx.fzz`, 2026-08-22): fixed undersized ESP32/MAX485 solder holes, removed the broken GPIO33→RE/DE trace. Gerbers + PCB view SVG in `260822 pcb v3-2-0/`.
- **v3-2-1** (`260823_v3-2-1_esp32_dmx.fzz`, 2026-08-23): removed the unused STPDWN step-down footprint and its two decoupling caps; cosmetic terminal relabeling. Gerbers + PCB view SVG in `260823 pcb v3-2-1/`.

Full fix history and verified circuit topology: [[v3]].

Fritzing custom parts (ESP32 and MAX485 footprints, both loose SVGs and importable `.fzpz` packages) are in `v3_esp32_dmx/pcb/fritzing custom parts/`, one subfolder per part.

## V3 Case

3D-printed enclosure designed in Rhino 3D, under `v3_esp32_dmx/case/`. Two design iterations:

- **v3-0** (`3d print v3-0/`, Aug–Sep 2025): body, front cap, end cap, inner spacer
- **v3-1** (`3d print v3-1/`, Nov–Dec 2025): revised body, front cap, end caps, inner spacers (start + end), middle block, internal frame

Files exported as STEP (`.stp`) and 3MF. The Rhino source files are `250603_v3_esp32_dmx.3dm` and `251124_v3-1_esp32_dmx.3dm`.

## V1 PCB

Designed in Fritzing (`pcbs/pitch_please_191222.fzz`), also available as DWG. Full etching layer exports (copper, mask, silk — top and bottom, mirrored and non-mirrored) included as PDF and SVG. Fabrication order in `pcbs/order_191223/`.

## MIDI Controller

The Novation Launch Control XL Mk3 is used with the vvvv patch for live performance control (scene switching, parameter adjustment).

## USB-DMX Interfaces (V3)

Two Enttec interfaces are used depending on setup:
- **Enttec Pro** — direct USB-DMX, used for direct connection from vvvv
- **Enttec Open** — used when routing via ArtNet + QLC+

## See Also

- [[v1]] — V1 details
- [[v2]] — V2 details
- [[v3]] — V3 details
- [[vvvv-patch]] — Software side of the signal chain

