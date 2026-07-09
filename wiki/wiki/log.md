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

## [2026-07-09] new-page | WiFi bridge broken out into own page

Created [[wifi-bridge]] covering the future-dev WiFi bridge concept: phone → vvvv HTTP/WebSocket server → DMX → v3 devices. Page covers concept, vvvv implementation via `VL.IO.HTTP` + `VL.IO.WebSocket` NuGet packages, phone connection setup, candidate UI scope, and open questions. Updated [[v3]] Future Development section to reference [[wifi-bridge]], added [[wifi-bridge]] to [[index]] under a new "Future Development" section.
