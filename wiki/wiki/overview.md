---
date_created: 2026-07-09
date_modified: 2026-07-09
---

# PitchPlease — Project Overview

> Hobby project: audio-reactive LED lighting system, evolving through three hardware versions. Controlled by a custom vvvv gamma patch.

## What It Is

PitchPlease is a custom audio-reactive LED controller built for live music and performance use. A control computer runs a vvvv gamma patch that analyzes audio and sends light data to LED hardware. The hardware has gone through three major versions, each expanding capability.

## Version History

**[[v1]] — Arduino mono-color (archived)**
Two 1m LED strips, each showing a single RGB color at a time. Arduino controlled via serial from vvvv. Custom PCB (Dec 2019). Superseded by v2.

**[[v2]] — WS2811 addressable strips (archived/still functional)**
Switched to WS2811 12V addressable strips where every ~5 cm segment can have a different color. Two sub-versions:
- V2a: 2 strips, original Arduino, 57600 baud
- V2b: 4 strips, Arduino R4, 921600 baud

**[[v3]] — ESP32 + DMX (current)**
Major architecture shift. ESP32 microcontroller receives DMX512 from the vvvv patch via USB-DMX interface. 4× 140 cm WS2811 strips per device. Two physical devices built (DMX addresses 100 and 200). Custom PCB and 3D-printed case.

## Control Software

The vvvv gamma 7.0 patch (`vl/root_gamma_6-6.vl` — filename pending rename) runs on a connected computer and drives all hardware versions:
- v1, v2: via serial (USB)
- v3: via DMX (Enttec Pro directly, or ArtNet → QLC+ → Enttec Open)

See [[vvvv-patch]] for details.

## Repository Structure

| Path | Contents |
|---|---|
| `arduino/pitch_please_mono/` | V1 firmware (archived) |
| `arduino/pitch_please_w2811/` | V2a firmware (archived) |
| `arduino/pitch_please_w2811_4_channel_r4/` | V2b firmware (archived) |
| `arduino/pitch_please_w2811_4-channel/` | Unknown intermediate firmware |
| `v3_esp32_dmx/firmware/` | V3 firmware (active) |
| `v3_esp32_dmx/hardware/` | V3 PCB (Fritzing/Gerber) and 3D case files |
| `pcbs/` | V1 PCB design (archived) |
| `vl/` | vvvv gamma patch + shaders + scenes |
| `cases/` | Early rack enclosure 3D files (pre-v3) |
| `standalone_esp32/` | Deprecated v3 prototype (to be deleted) |
| `util/` | Installers and controller config |
| `wiki/` | This wiki |

## See Also

- [[hardware]] — Cross-version hardware comparison
- [[vvvv-patch]] — Control software
- [[v1]], [[v2]], [[v3]] — Per-version detail pages
