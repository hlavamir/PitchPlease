---
date_created: 2026-07-09
date_modified: 2026-07-09
source: cowork chat
---

# Chat: Project Description & Clarifications
*2026-07-09 — conversation with Miro*

---

## Project overview

PitchPlease is a hobby project — building audio reactive lights. The repo contains scattered files relevant to different versions of the project: hardware, firmware and control software.

---

## Hardware versions

### Version 1

First version was arduino controlling 2x 1m long LED strips, that could do only 1 color per strip. Controlled from VVVV control software/patch. Arduino firmware: `v1/firmware/pitch_please_mono/`. Custom PCB layout: `v1/hardware/pcb/`.

### Version 2

Switch to using 2811 LED strips, that are addressable — every 5cm can have a different color.

**V2a:** Arduino driving 2x 1m long strips. Firmware: `v2_ws2811/firmware/pitch_please_w2811/`. Both controlled from ever-growing vvvv patch.

**V2b-intermediate:** Intermediate version controlling 4 strips using Arduino R3. Could not really receive enough data per frame for all 4 strips at 57600 baud, so it was only receiving 2 and then duplicating the colors to the other 2. Firmware: `v2_ws2811/firmware/pitch_please_w2811_4-channel/`.

**V2b:** Switched to 4 strips and Arduino R4 (when R4 was released), which can use a higher baud rate (921600) and run all 4 strips independently. Firmware: `v2_ws2811/firmware/pitch_please_w2811_4_channel_r4/`. Uses a different baud rate to communicate than V2a.

### Version 3

Major update — somewhat standalone ESP32, built into the same case with 4x 140cm 2811 strips. DMX compatible — has both in and out connectors. Two devices built so far, with hardcoded DMX addresses 100 and 200.

Firmware: `v3_esp32_dmx/firmware/v3_esp32_dmx_platformio/` (PlatformIO, current). The Arduino IDE project at `v3_esp32_dmx/firmware/v3_esp32_dmx/` is outdated, not yet deleted.

3D printed case and custom PCB layout: `v3_esp32_dmx/hardware/`.

---

## Control software

Custom VVVV (gamma 7.0) control patch: `vl/root_gamma_6-6.vl`. The filename is misleading — was created in gamma 6.6, recently switched to 7.0. Needs to be renamed.

vvvv is able to communicate with all hardware versions:
- v1 and v2: via serial
- v3: via USB-DMX interface (Enttec Pro) directly, or via local ArtNet to QLC+ and then USB-DMX interface (Enttec Open)

---

## standalone_esp32

`testing/standalone_esp32/` — only kept for archival reasons. Was the first take on v3, but not used in the end. Had the idea to run a local webserver on the ESP32 where the user could control the lights over WiFi — on the phone or laptop, simply in the browser.

Might still want to implement something like this in the actual v3 — would be nice to be able to control the lights remotely. But would just make a bridge from a phone to vvvv, not directly to the ESP32. Future dev. The standalone_esp32 folder itself is pretty much deprecated and might be deleted soon.

---

## Repo restructuring (2026-07-09)

Restructured repo into v1, v2 and v3 subfolders:

- `arduino/` removed — contents moved to `v1/firmware/` and `v2_ws2811/firmware/`
- `pcbs/` removed — contents moved to `v1/hardware/pcb/`
- `cases/` moved to `testing/cases/` — obsolete 3D print tests for a planned but never-built 19" rack version (screw hole tests, connector tests, etc.), pretty much all obsolete
- `standalone_esp32/` moved to `testing/standalone_esp32/`
- v2 folder named `v2_ws2811`
