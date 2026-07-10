---
date_created: 2026-07-09
date_modified: 2026-07-09
---

# Log

Append-only chronological record of wiki activity.

---

## [2026-07-09] init | Wiki initialized from codebase scan

Bootstrapped the wiki by reading the full repository. Created the following pages:

- `CLAUDE.md` — schema and conventions
- `overview.md` — project description and signal flow
- `hardware.md` — ESP32 AudioKit, WS2811 strips, rack enclosure, Kontrol F1
- `firmware-esp32.md` — standalone firmware: audio, FFT, LED, web control
- `vvvv-patch.md` — vvvv gamma patch, HLSL shaders, scene system, serial receiver
- `index.md` — page catalog

Sources read: `standalone_esp32/src/*.ino`, `standalone_esp32/src/*.h`, `arduino/*.ino`, `vl/shaders/*.sdsl`, `README.md`, directory tree.

---

## [2026-07-09] update | Schema rules added

Added four new rules to `CLAUDE.md`:
1. `raw/` + `wiki/` folder structure — `raw/` collects only explicitly ingested files (docs, chats); existing codebase is untouched
2. YAML frontmatter with `date_created` / `date_modified` required on all files in both folders; `date_modified` updated on every change
3. Conflict resolution — newer `date_modified` wins; older record marked as outdated (not silently overwritten)
4. Ask, don't assume — unclear items go to Open Questions and are surfaced in the next session

Applied frontmatter to all existing wiki pages. Created `wiki/raw/README.md`.

---

## [2026-07-09] note | v3 open questions answered

- DMX connectors confirmed as XLR-3 (3-pin). Updated [[v3]] Hardware section and [[hardware]] comparison table.
- Two more units planned (DMX addresses TBD). Updated [[v3]] Physical Devices section.
- Removed both from Open Questions.

---

## [2026-07-09] note | v3 known PCB issues

Added Known PCB Issues section to [[v3]]: (1) ESP32 solder holes too small — Fritzing part needs redesign; (2) two legs of one MAX485 module need to be disconnected — reason/legs TBD, flagged for clarification.

---

## [2026-07-09] note | v3 future dev — axis flip mode

Added to [[v3]] Future Development section: axis flip mode — resample the 24-pixel brightness curve at t = 0, 0.333, 0.666, 1.0 to get 4 values, one per strip. Also noted WiFi bridge idea (phone → vvvv, not phone → ESP32). Moved WiFi bridge from Open Questions to Future Development.

---

## [2026-07-09] ingest | Chat transcript saved to raw/

Saved today's conversation as `wiki/raw/2026-07-09_chat_project-description.md`. Covers: project overview, all 3 hardware versions, standalone_esp32 context, vvvv version clarification, DMX/ArtNet routing, v2 intermediate version explanation, v3 firmware clarification, repo restructuring.

---

## [2026-07-09] update | Repo restructured into version subfolders

Repo reorganised by Miro. Updated all path references across the wiki:

- `arduino/` removed — contents moved to `v1/firmware/` and `v2_ws2811/firmware/`
- `pcbs/` removed — contents moved to `v1/hardware/pcb/`
- `cases/` moved to `testing/cases/` — obsolete 3D print tests for a planned but never-built 19" rack version (screw hole tests, connector tests, etc.)
- `standalone_esp32/` moved to `testing/standalone_esp32/`
- `v2` folder is named `v2_ws2811` (not `v2`)

Pages updated: [[overview]] (repo structure table), [[v1]] (firmware + PCB paths), [[v2]] (all three firmware paths), [[firmware-esp32]] (testing/ path).

---

## [2026-07-09] ingest | Clarifications on v2 intermediate and v3 firmware

- `arduino/pitch_please_w2811_4-channel/` identified as an intermediate v2b version using Arduino R3: 4 strips connected but bandwidth at 57600 baud was insufficient to drive all 4 independently, so only 2 strip's data was received and duplicated to the other 2. Fixed by switching to Arduino R4 (921600 baud). Updated [[v2]] accordingly.
- v3 PlatformIO project (`v3_esp32_dmx_platformio/`) confirmed as active firmware; Arduino IDE project (`v3_esp32_dmx/`) is outdated and pending deletion. Source files are in `src/` (tracked by git). Updated [[v3]] accordingly. Removed resolved open question.

---

## [2026-07-09] ingest | Project description — 3 hardware versions

Ingested verbal description of the project from conversation. Major wiki update:

- Created [[v1]], [[v2]], [[v3]] version pages
- Rewrote [[overview]] with full version history and repo map
- Rewrote [[hardware]] as cross-version comparison table
- Updated [[vvvv-patch]]: corrected vvvv version to 7.0 (filename `root_gamma_6-6.vl` is stale, pending rename), added DMX/ArtNet connection details for v3, corrected all serial baud rates
- Marked [[firmware-esp32]] as deprecated (based on `standalone_esp32/`, a prototype that was abandoned in favour of DMX-based v3)
- Updated [[index]]

Key facts established: v3 uses DMX512 (not serial), two devices at addresses 100 and 200, 4× 140cm WS2811 strips with 24 LEDs per strip, custom Fritzing PCB with MAX485 + ESP32. vvvv connects to v3 via Enttec Pro (direct) or ArtNet → QLC+ → Enttec Open.

Open questions logged: role of `arduino/pitch_please_w2811_4-channel/`, vvvv audio analysis internals, scene organization, PlatformIO scaffold status, XLR connector type, WiFi bridge future dev.

---

## [2026-07-09] update | Folder structure reorganized

Moved all wiki pages into `wiki/wiki/` and ingested sources into `wiki/raw/`, so the entire wiki lives self-contained under the `wiki/` subfolder. Updated `CLAUDE.md` to reflect the new structure.

---

## [2026-07-10] update | util/ folder cleared

All files in `util/` removed (obsolete). Removed references from [[vvvv-patch]] file layout table, [[overview]] repo structure table, and README.

---

## [2026-07-10] update | vvvv-patch — full rewrite

Rewrote [[vvvv-patch]] with complete documentation based on Miro's description and patch file inspection (`root_gamma_6-6.vl`). Now covers: full signal flow diagram, audio analysis pipeline (SignalToSpectrum → AudioData → normalised FFT → 1D texture), 2D shader stage (background shaders, UV-based audio warping, VerticalSymmetry, MixIdleMaskWithPeaksMap), light fixture sampling (UV positions, groups A/B, RGB/RGBW), strobo/idle state machine, full macro list (confirmed against patch), scene system (8 INI presets of macro state), MIDI controller (MidiHardwareController, VL.IO.Midi), DMX/serial output nodes. All open questions closed.

---

## [2026-07-10] update | vvvv-patch — QLC+ usage clarified

QLC+ / Enttec Open path is a fallback only: used when Enttec Pro is not available or an extra DMX universe is needed. Updated [[vvvv-patch]] connection table and closed open question.

---

## [2026-07-10] update | hardware open questions answered

- V1 strip type clarified: basic non-addressable RGB strip (4-pin R/G/B/+), not WS2811. Updated [[v1]] and [[hardware]].
- WS2811 LED density confirmed: 60 LEDs/m (3 LEDs per 5cm segment), used in v2 and v3. Updated [[hardware]] comparison table.
- PSU specs: v2a = 12V 3A, v2b = 12V 6A. Updated [[v2]] and [[hardware]]. All hardware open questions closed.

---

## [2026-07-10] update | v3 physical design documented

Added Physical Design section to [[v3]]: 130cm PLEXIGLAS® Satinice tubes (Ø60/54mm, frosted, 0D010 DF), plastic square profile backbone with 4 LED strips glued to each face, 3D printed end caps (one housing all electronics). Documented v3.0 vs v3.1 case iterations — v3.1 added a screw rod through the full pipe length to fix structural breakage in v3.0. Added level shifter (74AHCT125N) to component list. Added DollaTek ADS-5.5V as the abandoned onboard step-down part.

---

## [2026-07-10] update | v3 component links added

Added specific product details and Amazon links for: ESP32 (AZDelivery ESP32-WROOM-32, USB-C, CP2102), PSU (LXLQZXW 12V 10A 120W), and external step-down module (YOURRYONG DE, 9–36V → 5V 5A). Updated [[v3]] hardware section and comparison table in [[hardware]].

---

## [2026-07-10] update | v3 PCB — step-down module issue

Added third known PCB issue: onboard STPDWN 12V→5V step-down footprint proved unreliable (ESP32 lost power after seconds). Workaround: external 12V→5V module. PCB fix: remove footprint, route external 5V. Updated [[v3]] Known PCB Issues preamble to note all three issues require a redesign.

---

## [2026-07-10] update | v3 MAX485 leg disconnection explained

RE and DE pins of the DMX Out MAX485 module were routed to GPIO33 in the PCB. Firmware approach to drive them couldn't be made to work. Workaround: physically cut the RE/DE legs on assembled boards. PCB fix for next revision: remove the GPIO33→RE/DE trace. PCB redesign already needed for ESP32 hole issue. Updated [[v3]] Known PCB Issues. Open question closed.

---

## [2026-07-10] update | v2 clarifications — strip length and LED modes

- Strip length confirmed: 1m aluminium profile (same physical construction as stated previously).
- v2a LED modes decoded from source code: Mode 0 = "double symmetry" (each strip independent, each 19-LED half is a palindrome of 10 values); Mode 1 = "all same, simple mirror" (both strips identical, all 20 buffer values as a simple palindrome). 10 values/strip was the serial bandwidth limit at 57600 baud. Updated [[v2]] v2a section with mode table and corrected standalone idle description.

---

## [2026-07-10] update | v2 open questions answered

- Physical construction documented: each firmware strip channel = 2× WS2811 strips (19 segments each) in a triangular aluminium profile. Strip B is reversed and chained to Strip A's end; LEDs interleave at a slight offset. Physical reversal produces the mirror effect — firmware only needs to send 19 values per channel. Updated [[v2]] with a Physical Construction section.
- Device status: V2a intact (backup for V2b). V2b (R4) intact but caseless "shoebox" prototype — used at events, may be scrapped for V3 parts eventually. Added Physical Devices table to [[v2]].
- Updated [[hardware]] comparison table with correct strip construction; closed open question on v2 physical devices.

---

## [2026-07-10] update | v1 open questions answered

- Arduino model confirmed: Uno R3. Updated [[v1]] and [[hardware]] comparison table.
- One physical v1 device still exists and is occasionally used standalone — runs an onboard idle animation on power-up without needing vvvv. Updated [[v1]] status section. Updated [[hardware]] open questions.

---

## [2026-07-10] update | wifi-bridge open questions answered

- Control surface scope: everything in the vvvv UI — brightnesses, audio sensitivity, shader presets/params, switches, scene load/save.
- Protocol: MIDI (0–127) confirmed sufficient. No parameter needs higher resolution. OSC ruled out.

---

## [2026-07-10] ingest | TouchOSC / MIDI bridge research

Saved `wiki/raw/2026-07-10_chat_touchosc-midi-bridge.md`. Rewrote [[wifi-bridge]] with concrete implementation detail:

- Recommended approach shifted from custom HTTP/WebSocket → TouchOSC via RTP-MIDI
- RTP-MIDI setup documented for macOS (built-in Audio MIDI Setup) and Windows (rtpMIDI, free)
- TouchOSC interface editor workflow: build on desktop, transfer via AirDrop/WiFi sync/Finder
- Network options: venue WiFi (unreliable) vs phone hotspot → laptop (recommended for live use)
- OSC noted as alternative to MIDI for higher precision (float vs 0–127)

---

## [2026-07-09] update | MIDI controller corrected + README updated

Corrected MIDI controller from Traktor Kontrol F1 → Novation Launch Control XL Mk3 in [[vvvv-patch]] and [[hardware]]. Updated `README.md` with project description, hardware version table (with wiki links), annotated folder structure, and a wiki navigation section.

---

## [2026-07-09] new-page | WiFi bridge broken out into own page

Created [[wifi-bridge]] covering the future-dev WiFi bridge concept: phone → vvvv HTTP/WebSocket server → DMX → v3 devices. Page covers concept, vvvv implementation via `VL.IO.HTTP` + `VL.IO.WebSocket` NuGet packages, phone connection setup, candidate UI scope, and open questions. Updated [[v3]] Future Development section to reference [[wifi-bridge]], added [[wifi-bridge]] to [[index]] under a new "Future Development" section.
