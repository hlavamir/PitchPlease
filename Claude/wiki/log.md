---
date_created: 2026-07-09
date_modified: 2026-10-07
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

## [2026-07-10] ingest | UI screenshots moved to wiki/images/

Screenshots `ui_general.png` and `ui_dimmers.png` added to `wiki/images/`. Embedded in [[vvvv-patch]] under a UI Screenshots section. Added `wiki/images/` to directory structure in `CLAUDE.md`. Saved image manifest to `wiki/raw/2026-07-10_images-added.md`.

---

## [2026-07-10] ingest | vvvv UI screenshots (General + Dimmers tabs)

Saved `wiki/raw/2026-07-10_vvvv-ui-screenshots.md`. Extracted and ingested into [[vvvv-patch]]: complete macro list with M-index numbers (M0–M47), all button labels including previously undocumented `Audio Filter` (M23) and `Art-Net Color`, shader presets named Preset A/B/C/D, fixture UV panel (devices at [100]/[200], point fixture at [30]), named dimmers (D PitchPlsl v3/v2, D Pinspots, D Panel Center), BB Vert/Horz Pos/Speed parameters (BB meaning unknown — open question), group A/B channel count (9 each).

---

## [2026-07-10] update | vvvv patch updated to 7.3 and renamed

Patch updated to vvvv gamma 7.3 and renamed from `root_gamma_6-6.vl` to `root_gamma_7-3.vl`. Updated all references in [[vvvv-patch]], [[overview]], and README. Removed stale filename note.

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

## [2026-07-10] update | v2 sub-version naming formalised

Renamed sub-versions throughout the wiki:
- v2a → **v2.0** (2 strips, Arduino, 57600 baud)
- v2b-intermediate → **v2.1** (4 strips, Arduino R3, 57600 baud — bandwidth limited)
- v2b → **v2.2** (4 strips, Arduino R4, 921600 baud)

Updated: [[v2]], [[overview]], [[hardware]], [[v1]], [[vvvv-patch]]. Raw files left unchanged (immutable records).

---

## [2026-07-10] update | fixtures.md simplified

Third-party fixtures other than the pinspots don't need detailed docs — setup varies per event and equipment is often mixed with a friend's gear. Miro only owns the Cameo Q Spot pinspots. Trimmed [[fixtures]] to keep full detail only for the pinspots; Beam Ball and LED panel reduced to brief event-history notes.

---

## [2026-07-10] update | Panel Center fixture documented

"D Panel Center" (M35) = a Stairville RGB LED panel (model unknown), rectangular grid of RGB LEDs that outputs a single colour per panel — treated as a generic single-pixel RGB fixture. Used as a centre wash at events. Updated [[vvvv-patch]] dimmer label and added a stub entry in [[fixtures]].

---

## [2026-07-10] ingest | Cameo Q Spot 15 RGBW manual + fixture table corrected

Ingested manual for the Cameo Q Spot 15 RGBW (18W RGBW LED spot, 5 DMX modes, XLR 3-pin). Two units used as pinspots at DMX addresses 6 and 10 — these appear as orange dots at [6] and [10] in the vvvv fixture UV panel. M34 "D Pinspots" is their master dimmer.

Also corrected: [0], [1], [2], [3] in the fixture panel are **v2b strip IDs**, not DMX addresses.

PDF saved to `wiki/raw/Cameo_Q_Spot_15_RGBW.pdf`. Ingest record: `wiki/raw/2026-07-10_cameo-qspot15-manual.md`. Updated [[fixtures]] (new Cameo Q Spot section) and [[vvvv-patch]] (fixture table, M34 label).

---

## [2026-07-10] update | Beam Ball — ArtNet/MadMapper control workflow

Clarified how the Beam Ball was actually used at events: a second laptop running MadMapper connected via ArtNet, with vvvv receiving the ArtNet stream. vvvv remaps the received signal and either uses the received hue (Art-Net Color mode) or overwrites with its own colour logic. The "Art-Net Color" button toggles between these two. The BB macros (M44–M47) were an earlier direct-DMX approach, with additional translation logic in vvvv for the speed→position conversion; superseded by the MadMapper workflow. Updated [[fixtures]] and [[vvvv-patch]].

---

## [2026-07-10] ingest | Stairville Beam Ball 100 Quad LED manual

Ingested PDF manual to resolve the "BB" open question in [[vvvv-patch]].

- **BB** = Stairville Beam Ball 100 Quad LED — 10×10W RGBW moving head, 540° pan, infinite tilt, DMX address 30 in vvvv.
- 7-channel DMX mode confirmed as the relevant mode: Ch1=Pan, Ch2=Tilt, Ch3=Speed, Ch4=Master Dimmer.
- BB macros: M44 (BB Vert Pos) → Tilt (ch2), M45 (BB Horz Pos) → Pan (ch1), M46–M47 (BB Vert/Horz Speed) → Movement Speed (ch3).
- Clarified that vvvv "Dimmers" tab is a misnomer: the 16 faders are generic static DMX channel outputs, not limited to brightness control.
- Fixture at [30] in the UV placement panel = Stairville Beam Ball.
- PDF saved to `wiki/raw/Stairville_Beam_Ball_100_Quad_LED_10x10w.pdf`. Ingest record: `wiki/raw/2026-07-10_stairville-beam-ball-manual.md`.
- Created new page [[fixtures]] with full specs and DMX map. Updated [[vvvv-patch]], [[index]].

---

## [2026-07-09] update | MIDI controller corrected + README updated

Corrected MIDI controller from Traktor Kontrol F1 → Novation Launch Control XL Mk3 in [[vvvv-patch]] and [[hardware]]. Updated `README.md` with project description, hardware version table (with wiki links), annotated folder structure, and a wiki navigation section.

---

## [2026-07-09] new-page | WiFi bridge broken out into own page

Created [[wifi-bridge]] covering the future-dev WiFi bridge concept: phone → vvvv HTTP/WebSocket server → DMX → v3 devices. Page covers concept, vvvv implementation via `VL.IO.HTTP` + `VL.IO.WebSocket` NuGet packages, phone connection setup, candidate UI scope, and open questions. Updated [[v3]] Future Development section to reference [[wifi-bridge]], added [[wifi-bridge]] to [[index]] under a new "Future Development" section.

---

## [2026-09-06] new-page | Discoball art installation + motor datasheet ingest

New side project, discussed and specced in chat before this ingest: a discoball resting in a rotating 3D-printed bowl bearing, driven via an internal ring gear (~8cm, slewing-ring style) by an off-axis stepper motor. Target rotation ~1–3 RPM ambient, up to ~60 RPM "strobe" mode, low-speed precision prioritized over top speed.

Key decisions captured: reusing the [[v3]] PCB v3.2 for the motor was considered and rejected (its 4 LED headers are 5V logic-level buffer outputs, not power drivers — no benefit over a plain breadboard build for this one-off). A DC gear motor + TB6612FNG was the initial plan but dropped once the wide (20×) speed range with low-speed precision became the actual requirement — open-loop PWM on a brushed DC motor is nonlinear at low duty due to static friction, whereas a stepper's speed (step-pulse frequency) has no such dead zone. Settled on a NEMA17 pancake stepper (StepperOnline 17HE08-1004S, 17Ncm/1A) driven by a TMC2209 (chosen for silent "stealthChop" operation, important for an ambient art piece) with VIO tied to the ESP32's 3.3V rail (no level shifter needed — TMC2209 logic supply is independent of motor voltage).

PDF label/datasheet for the purchased motor ingested: `raw/290906 Setpper Motor.pdf`. Ingest record: `raw/2026-09-06_stepperonline-17he08-1004s-datasheet.md` — confirms exact pinout (1=A+/black, 3=A−/blue, 2=B+/green, 4=B−/red), electrical specs (3.6Ω/phase, 4mH, 22g·cm² rotor inertia), and mechanical dimensions (5mm shaft w/ flat, 31mm bolt pattern, 23mm pancake body).

Created new page [[discoball]] covering the full concept, mechanical design, motor/driver selection rationale, wiring notes, and open questions (bearing friction interface undecided — flagged as the most likely weak point; ring gear module/tooth count and DMX channel mapping not yet finalised). Added new "Side Projects" section to [[index]].

---

## [2026-09-25] update | Discoball — slewing bearing terminology + reference video

Recorded that the correct technical term for the rotating holder/bearing with integrated drive gear under the discoball is a **slew bearing / slewing bearing** (internal-teeth variant), useful as a search term for printable designs. Saved a reference link: [Slew Bearing Design & Manufacture — Mahdi Designs](https://www.youtube.com/watch?v=CtQzOOL7SQg) (only the title and channel were looked up; the video itself was not reviewed). Added a "Terminology: slewing bearing" subsection and a See Also link to [[discoball]]. New Open Question recorded: Miro wrote "internal thread", interpreted as internal gear teeth — unconfirmed.


---

## [2026-09-25] ingest | Discoball — slewing bearing inspiration images, "internal thread" resolved

Miro clarified that "internal thread" in the previous entry meant **internal gear teeth**; the open question is resolved (struck through in [[discoball]]). Saved four slewing-bearing product renders as inspiration for the general principle (two rings, captured rolling elements in a raceway, one ring with gear teeth, mounting holes on both rings, seal), not for size or load: `images/discoball-slewing-bearing-1-roller-external-teeth.png`, `-2-yellow-cage-rollers.webp`, `-3-ball-race-cutaway.png`, `-4-internal-teeth.webp`. Only image 4 shows internal teeth. Added an "Inspiration images" subsection to [[discoball]] and a note under Bearing that the slewing-bearing references suggest replacing the plain plastic pivot with a proper split raceway (undecided).

---

## [2026-09-26] new-page | v3 devices 3 and 4 — internal cable set prepared

Miro is building two more v3 devices (units 3 and 4) and cut/prepared their internal cables on 2026-09-25, one identical set per device: PCB↔external power module 45 mm (2× red, 2× white); power connector→PCB 90 mm (1× red, 1× white); DMX connectors→PCB 70 mm (2 cables × GND/A/B); LED leads 110 mm female end (strip side) and 60 mm male end (PCB side), 4 cables each × positive/data/GND, joined by an in-line connector per strip so PCB and strips can be separated during assembly. Lengths are first-pass; Miro will report corrections after test-fitting.

Created [[v3-assembly]] with the cable table, a note that the destinations (which PCB terminals/headers each cable serves) are inferred and unconfirmed, and Open Questions: wire colors for the LED/DMX cables and connector types weren't recorded, and the DMX header silkscreen letters (GND/A/B) appear swapped relative to the MAX485's A/B pins in the v3.2 netlist — which naming the new cables follow is unconfirmed. Added the page to [[index]] and linked it from [[v3]] (Physical Devices and See Also).


---

## [2026-09-26] update | Motor datasheet PDF renamed (typo fix)

Miro fixed the typo in the datasheet's filename: `raw/290906 Setpper Motor.pdf` is now `raw/290906 Stepper Motor.pdf`. Updated the `file:` pointer in the ingest record `raw/2026-09-06_stepperonline-17he08-1004s-datasheet.md` (and its `date_modified`); no wiki page linked to the PDF by name. The earlier 2026-09-06 log entry above still shows the old misspelled name, left as-is because the log is append-only — read it as the same file.

---

## [2026-09-26] update | v3 devices 3 and 4 — 12 V cable extended, tape over MAX485s, spine rod length

Miro reported three findings from assembling units 3 and 4. (1) The pair of 12 V power cables from the PCB to the external power module, cut at 45 mm, had to be extended to 90 mm; nothing was said about the other pair to the module, so its 45 mm is assumed unchanged. This also confirms part of the earlier inferred cable-destination mapping: a 12 V pair runs PCB → power module. (2) A piece of tape now covers the MAX485 modules as a precaution against them accidentally touching two metal components on the power module and short-circuiting the device — judged unlikely, done as cheap insurance. (3) The "spine" — the structural screw rod through the hollow square profile — needs to be 134 cm long.

Updated [[v3-assembly]]: the cable table now shows the extended 12 V pair (original 45 mm kept visible as "was"), and a new "Corrections and build notes" section holds all three items. The rod length is also noted in [[v3]]'s v3.1 case-iteration row. New Open Question: it wasn't stated whether the extension and the tape apply to both units 3 and 4, or whether units 1 and 2 should get the tape as well.

---

## [2026-09-27] ingest | v3.2 case iteration + full assembly procedure for devices 3 and 4

Discovered a third case iteration exists: `v3_esp32_dmx/case/3d print v3-2/` (Rhino source `280925_v3-2_esp32_dmx.3dm`), used for devices 3 and 4 — not previously documented (wiki only knew about v3.0 and v3.1). Its main structural difference from v3.1: two middle blocks on the spine rod (each centred 47 cm from an end, 40 cm apart) instead of v3.1's single midpoint block. Body/end cap/front cap are black, both inner spacers white. Added a "v3.2" row to [[v3]]'s Case iterations table; "Two iterations" language updated to "Three".

Miro then logged the full 11-step assembly procedure followed for both units on 2026-09-26 (spine rod cutting and middle-block threading with measurements, sliding on the square profile and inner spacers, sizing against the Plexiglas tube, gluing and taping the 4 LED strips with the alternating start-line pattern, internal frame and XLR/front-cap attachment, final body/end-cap assembly with M3 16mm screws, then flashing firmware — via `firmware-flasher.command`, the tool built earlier this week — and labeling the DMX address). Added as a new "Assembly procedure (v3.2 case)" section in [[v3-assembly]], referencing each printed part by its actual filename. Both units are complete except for 2 missing printed covers — not specified whether one per device or both for one device; recorded as an Open Question.

Also logged 5 lessons-learned notes for future case/cable revisions, as a new section in [[v3-assembly]]: LED cables (both leads) should be ~1cm longer; the internal frame's holes (especially the rod's middle hole) and the inner-spacer holes are slightly too tight; the inner spacers have ~1mm too much play where they meet the square profile; and the assembly needs a way to stop the nuts backing off over time (thread lock / lock nuts / glue).

---

## [2026-09-27] update | Units 3/4 status: power+LED confirmed working, XLR untested; unit 2 body reprint pending

Miro clarified the "missing 2 printed covers" from the previous entry: both units 3 and 4 are each missing their body, end cap, and front cap (the front cap carries the XLR connectors) — not just two covers total. Power delivery and LED communication have been tested and confirmed working on both units; the XLR/DMX signal path can't be tested yet since neither unit has its front cap (and therefore XLR connectors) attached. Updated the Status section in [[v3-assembly]] accordingly, replaced the old "which 2 covers" open question with an XLR-testability one, and left the "same body design as v3.2?" question open on the new Units 1 and 2 section below.

Miro is not planning further changes to units 1 and 2, except possibly reprinting unit 2's body: a modeling mistake left out the screw hole joining the body to the inner spacer start through the Plexiglas tube (bottom side). Already fixed in the model and reprinted for unit 1; unit 2's body hasn't been reprinted yet. Added a new "Units 1 and 2" section to [[v3-assembly]] — unconfirmed whether units 1/2 use the v3.2 body design or an earlier one.

---

## [2026-09-27] update | XLR/DMX testing not actually blocked on the front cap

Corrected a wrong claim from the previous entry: the XLR/DMX path on units 3/4 is not blocked on the front cap being attached — the front cap is only the mechanical mount, and the XLR connectors can be wired directly to the PCB without it. Miro may test this today; the cost is having to unplug the connectors again afterward to route their cables through the front cap during final assembly. Updated the Status section and the corresponding Open Question in [[v3-assembly]].

---

## [2026-09-27] update | Future-revision note: middle blocks closer together

Miro would move the two middle blocks on the spine rod closer together in a future case revision — 30 cm apart instead of the current 40 cm, still centred symmetrically. Added to the "Lessons learned" section in [[v3-assembly]].

---

## [2026-09-27] new-part | Nut retainer designed to fix the nut-unscrewing lesson learned

Asked what to call a 3D-printed piece that mechanically stops a nut from unscrewing; landed on "nut keeper" as the general term. Miro named the actual part **nut retainer** and placed it at `v3_esp32_dmx/case/3d print v3-2/nut retainer end.3mf` (verified it exists, 2026-09-27). It fits under the end cap and addresses the rod's end-side nut specifically — the one that stays permanently tensioned in the finished assembly, unlike the start side which is fixed via M3 screws rather than a permanent nut.

Marked the corresponding "Lessons learned" bullet in [[v3-assembly]] as resolved (struck through, not deleted) and added a "Nut retainer" note describing the part and where it fits into the assembly procedure (step 10). Not yet used in an actual build.

---

## [2026-10-05] ingest | vvvv port planning: patch reverse-engineering, VL library sources, v3 header check

Parsed `vl/root_gamma_7-3.vl` programmatically (definitions, node graphs, IOBox values) and read the public vvvv repos `VL.Audio` and `VL.StandardLibs` (VL.Stride TextureFX shaders, CoreLib `TimerFlop`). Created [[vvvv-patch-logic]] with the reconstructed algorithms. Main findings:
- The FFT node's Bin Count 64 means a 128-sample Hann FFT with 375 Hz bins. Bin 1 covers ~0–750 Hz, dB is taken on |X|² (doubling level differences), and AudioData normalises with one shared max. Together these explain why the first band dominates.
- `MixIdleMaskWithPeaksMap` uses Stride `FilterBase`'s `Control` lerp. The Glitches macro drives it, so Glitches = 0 means no audio reactivity.
- Preset crossfade is a linear 2.5 s blend (Blend default op "Average").
- Fixture brightness and phase logic reconstructed, including exclusive strobo/idle switching and gamma applied to HSV value only.

Verified the v3 DMX framing against the v3.2 firmware. vvvv sends `255, 0` (master, mode) from `CreateLightFixtures` plus `255×4` strip dimmers hardcoded in `PitchPlsToDMXv3`, then 24 × RGB, which matches the firmware. Added a note to [[v3]]. (A 7-byte header `0,0,0,0,191,255,0` seen in the patch belongs to the Beam Ball, not v3.)

Created [[port-design]] with the decisions so far: Python engine + Vite/React/TS/Tailwind client, CPU-only per-pixel masks with a 256×256 preview, distance-to-line masks instead of rectangle + blur, `fixtures/types/*.json` + `rigs/<event>.json`, `logs/YYMMDD_hhmm.log` per backend start, two-colour groups (Hue/Sat A/B) with Auto Color and Swap as group overrides, per-fixture hue/sat/brightness sources, USB-device dropdowns by serial number, and an Audio input page. Beam Ball and Audio Filter are dropped from the port.

Corrected [[vvvv-patch]]: VerticalSymmetry averages with the left↔right flip rather than mirroring around the horizontal centre (old wording marked as corrected), and the Glitches description was extended.

---

## [2026-10-05] update | Port design decisions, round 2

Miro's decisions, recorded in [[port-design]]:
- Groups A/B are kept, including the per-group strobo/idle brightness. The non-strobo "dark on peak" behaviour and exclusive strobo/idle phases are intentional.
- Gamma is split into Brightness Gamma (HSV value) and RGB Gamma (per channel).
- The Auto Color palette becomes full HSB colours; A = B is allowed.
- Glitches gets renamed.
- MIDI mappings go in `controllers/*.json`, selected on an "Inputs" page (which replaces "Audio input").
- The old scene INIs will be imported. A Fog page is added.
- Logs are named `YYMMDD_hhmmss.log`.

Proposed a techno/house FFT config (2048/512, 32 log bands 35 Hz–10 kHz, per-band normalisation). Frame rate, the profile model and the FFT config are still open. In [[vvvv-patch-logic]], Swap Colors is confirmed as a plain A↔B swap and the non-strobo darkening as intentional.

---

## [2026-10-05] build | PitchControl first version

Named the port **PitchControl** and built a first version in `pitch_control/`:
- Python engine: 32-band analysis with octave-weighted strobo trigger, ports of AudioData, UpdatePhase and LightFixture, the mask generators (including a numpy port of the simplex noise shader), fixture profiles, Enttec/Art-Net/v2 outputs, fog, scenes, macro autosave.
- FastAPI/WebSocket server.
- React frontend with the General, Dimmers, Fixtures, Output, Inputs and Fog pages.
- Default config reconstructed from the patch.

33 tests pass. Hardware I/O is not yet verified. Updated [[port-design]]:
- profiles confirmed;
- trigger weighting linear over octaves (100 Hz → 5 kHz);
- 40 FPS;
- 9-entry HSB palette;
- new sections Implementation Status and Future: Hardware Strobe (proposal);
- new open questions about the fixture details the patch doesn't pin down.

Added the extracted rig, dimmer assignment, macro table and LCXL3 reading to [[vvvv-patch-logic]]. Corrected the idle-mask-range attribution there (pinspots with Invert Discoball, not LED bars).

---

## [2026-10-05] update | PitchControl: fog channels, v3 #3/#4, launcher, audio check

- Fog channels found in the patch: fog = DMX 1, ground fog = DMX 2 (universe 0, 255 = on, 1-based like the fixtures). Both timers are enabled as in vvvv.
- v3 units #3 and #4 are re-enabled in the default rig.
- LED bar address is still open. The patch has 300, while Miro remembered 30, which is the back panel's address in the patch.
- Pinspot hardware strobe is dropped for now (it needs the 9-channel mode). Mask reset on peak is confirmed as intended.
- Added `pitch_control/run.command` (macOS launcher).
- Audio capture from the Komplete Audio 6 works after the microphone permission was granted. All inputs were silent during the test, so the reaction to music is untested.

Updated [[port-design]].

---

## [2026-10-05] update | PitchControl: LED bars removed, run.bat, audio inputs 1/2

- Miro had mixed up the LED bars and the back panel. LED bars are removed from the default rig and their fixture type is deleted.
- The pinspots' 4-channel mode is confirmed.
- The default audio input is now channels 1/2 of the Komplete Audio 6, since nothing is connected to 3/4.
- Added `pitch_control/run.bat` (Windows launcher, not yet tested on Windows).

---

## [2026-10-05] build | PitchControl standalone app

Miro chose the app's own window (pywebview), `~/Documents/PitchControl/` as the data folder, and unsigned builds.

Added:
- `pitchcontrol.desktop` (first-run config install, server thread, native window, clean shutdown on window close or Quit);
- `pitch_control/packaging/` (PyInstaller spec with the macOS microphone permission, icon generator, `build_macos.sh`, `build_windows.bat`);
- a manual GitHub Actions workflow for both platforms.

The macOS arm64 app builds and runs: 46 MB, smoke test with audio and MIDI loaded, and Quit stops the engine and saves the macros. The Windows build is not yet tested. Recorded in [[port-design]] (Standalone App).

---

## [2026-10-05] update | PitchControl app uses the repo config

Miro wants rigs and fixture types committed, so the standalone app now uses the repo's `pitch_control/config/` directly. The build records the repo path. The order of precedence is `--data`, then `~/Documents/PitchControl/data_folder.txt`, then the repo, then `~/Documents/PitchControl/` as fallback. Default files are only installed into the fallback or into an empty folder.

This supersedes the earlier "data in Documents" decision in [[port-design]]. Verified: a macOS build started without arguments uses the repo folder. 38 tests pass.

---

## [2026-10-05] update | PitchControl UI round: live rig edits, output monitor, MIDI monitor

Changes after Miro's first hands-on session:
- Scenes stay in git.
- The first pixel of multi-pixel fixtures has a thicker ring in the preview, so the direction is visible.
- New live output monitor (Output page, and the selected fixture on the Fixtures page): pixel colours and raw channel values.
- Rig edits apply to the engine on Enter or blur. "Save rig" writes the file, "Revert" reloads it, and the server tracks unsaved changes.
- Number fields keep the typed text until committed. They accept ".5" and ",5", allow an empty field while typing, and Escape reverts.
- Launch Control did nothing although the status was green. The correct port, "LCXL3 1 MIDI Out", is open, but no messages arrived during a 20 s listen. Added a MIDI monitor (Inputs page: last 20 messages, whether each is mapped, or why not) and a log warning when CCs arrive on an unmapped channel.

Open: whether the LCXL3 sends on channel 12 and the CCs from the patch. Check with the monitor. 41 tests pass.

---

## [2026-10-05] fix | LCXL3 MIDI channel is 13

The MIDI monitor showed the Launch Control XL 3 sending on MIDI channel 13. The vvvv patch's "Channel 12" is VL.IO.Midi's 0-based channel index. Fixed `pitch_control/config/controllers/lcxl3.json` and corrected [[vvvv-patch-logic]].

---

## [2026-10-05] update | PitchControl: whole-tile faders

Miro confirmed MIDI works with channel 13. Faders in the UI are now custom controls where the whole tile is draggable. Dragging is relative (no jump on click), Shift gives fine control, double-click resets to the default, and arrow keys step the value. While dragging, the tile shows the local value, and the engine gets at most one update per animation frame.

---

## [2026-10-05] update | PitchControl: fader centre line and colour tracks

Every fader has a subtle centre line. The Hue A/B and Saturation A/B faders show their range as a colour gradient, plus the resulting colour (marker and swatch). The colours are computed from the macro values, not the auto colours, so the colour you'll get after switching Auto Color off is visible beforehand.

---

## [2026-10-05] update | PitchControl: calmer colour faders

The colour gradient on the Hue/Saturation faders is now a narrow strip (10 % width) on the left edge. The rest of the fader is filled with the selected colour, like the other faders.

---

## [2026-10-05] update | PitchControl: layout fits a 14" MacBook

Target viewport: 1512×915, the usable area of a 14" MacBook Pro at default scaling. All pages now fit without scrolling:
- General: shorter faders and buttons; functions and shader presets merged into one panel; tighter spacing.
- Fixtures: inputs shrink instead of overlapping; the editor uses two columns only when its panel is wide enough (container query).
- Output: live output moved to its own column.

The app window opens maximized.

---

## [2026-10-05] update | PitchControl: full-height faders, on-release colours, hardware feedback

Miro's feedback:
- Audio works (microphone test).
- LCXL3 works.
- Front panels need only 3 channels; the address step of 4 is just continuity with the pinspots.
- Masks look identical to vvvv except Back and Forth rotating in 45° steps instead of 90° (left for now).

Changes:
- General and Dimmers faders fill the window height.
- Pages are now ordered General, Dimmers, Fixtures, Inputs, Outputs, Fog ("Output" renamed to "Outputs").
- Hue and Saturation macros are "deferred": the UI applies them on mouse release, MIDI once the knob rests for `midi_settle_s` (0.4 s). A dashed outline shows a pending value.

Recorded in [[port-design]].

---

## [2026-10-06] fix | LCXL3 drives the active page; 8-column grids

Miro reported that the LCXL3 only worked on the General page. In vvvv, the same 16 controls drive the faders of the active tab, and CC 13 switches tabs. PitchControl now does the same:
- controller files get per-page mappings and a `page_knob`;
- new "Page General"/"Page Dimmers" radio macros, which are not saved in scenes;
- the UI page and the controller page stay in sync in both directions.

CC 34 and 36 now drive Saturation A and B. Tested with unit tests and a simulated page change in the browser; not yet with the controller.

General and Dimmers now always use 8-column grids, like the controller. Updated [[vvvv-patch-logic]] and [[port-design]].

---

## [2026-10-06] design | PitchControl UI redesign

Made a mockup canvas with three boards (General page, control states, Settings) from Miro's inspiration images. Iterated on his feedback:
- no scanlines;
- no dithering in the scene preview;
- glow at full strength;
- gap-free segments that fade with the value;
- hue/saturation segments in the ink colour, with the colour only in the scale and the value dot;
- hue shown as ±180°, saturation as 0–100 %.

Then implemented it in `pitch_control/frontend`:
- theme driven by Settings → Appearance and persisted in `settings.json`;
- bundled fonts;
- segmented faders and meters;
- full keyboard navigation;
- a new Settings page;
- all pages restyled.

Backend: macro display units, `ui` settings, WebSocket messages for keyboard-deferred hue/saturation and for cancelling them. Recorded in [[port-design]] (UI Design).

---

## [2026-10-06] update | PitchControl UI tweaks; notch gap in full screen

Changes:
- Section gaps and page padding halved.
- Header indicators never wrap, and FPS has a fixed width so it doesn't shift the indicators. The desktop-only "Open in browser" and "Data folder" buttons moved to Settings → App to make room.
- Verified that General/Dimmers faders fill the height on larger screens (1920×1200).

The black strip at the top in macOS full screen is the camera-notch safe area of the 14" MacBook Pro (`safeAreaInsets.top` = 32 px). macOS places full-screen windows below it for every app. Fixing it needs a custom full-screen mode; open question in [[port-design]].

---

## [2026-10-06] build | PitchControl custom full screen, two-row header

Added the full-screen mode Miro asked for, with the two-row header he designed (top row: logo left, indicators right, empty middle for the camera notch; second row: page tabs). F toggles it, and Settings → App has "Start in full screen". Verified on the 14" MacBook: the window covers 1512×982 including the notch strip, the top row is 32 px, and the notch range (≈664–849 px) is free. Recorded in [[port-design]] (Full Screen).

---

## [2026-10-06] update | PitchControl visual polish

- Window shadow off in full screen: its 1 px outline showed at the rounded screen corners.
- Header and footer use the same 6 px side margin as the page content.
- The top header row is 38 px, so its bottom line clears the camera island.
- Hue/saturation colour strips are half as wide (5 px).
- Renamed `build_macos.sh` to `build_macos.command`, so it can be double-clicked.

---

## [2026-10-07] build | PitchControl number fields, fixture multi-edit, rotation in degrees

- Number fields: Enter applies and keeps the focus; ↑ / ↓ and right-drag step the value (Shift = fine). Steps: integers 1 / 1, floats 0.1 / 0.01.
- Fixtures page multi-edit: Shift + click selects several fixtures; shared values are shown, differing ones show "multiple"; a value entered applies to all. Arrows and drag are off for "multiple" fields. Name, Duplicate and Remove are off in multi-edit (Miro's choice).
- Fixture rotation is now stored in degrees (was turns); 15° / 1° steps. `rigs/default.json` converted (0.75 → 270).

Recorded in [[port-design]] (Frontend Pages).

---

## [2026-10-07] build | PitchControl rig management

The Fixtures page has a separate Rig panel above the fixture list, so it is clear whether the rig file or the lights in it are edited. Rig actions: load, Save, Revert, Rename, Duplicate (save as, switches to the copy), New, Delete, description. Unsaved changes prompt Save / Discard / Cancel before loading or creating a rig. Backend: `POST /api/rig/rename`, `/api/rig/duplicate`, `/api/rig/new`, `DELETE /api/rig`; a rig's name is now always its file name. Recorded in [[port-design]] (Frontend Pages).

---

## [2026-10-07] build | PitchControl UI scale

Settings → Appearance → UI scale (60–150 %, −/+, "Fit window", 100 %), saved as `ui.scale`. Implemented with CSS `zoom`; page layouts switch on a JS-set `data-wide` flag and in-panel layouts on measured widths, because media/container queries behave differently under zoom in WebKit and Chromium. Verified at 1280 × 640 (Miro's minimum 1280 × 720 screen minus title/taskbar): Fit gives 69 % and no page scrolls. Also: `index.html` is now served with `Cache-Control: no-cache`, because a cached copy kept loading the previous UI bundle after a rebuild. Recorded in [[port-design]] (UI Design).

---

## [2026-10-07] update | PitchControl single-column layout at large UI scale

After Miro tried 125 % on the MacBook: the scene preview is capped at half the window width; in the single-column layout General puts Scene and Audio in one row, and Fixtures puts the preview and the output monitor in one row. Tests no longer assume the shipped rig is called "default" (Miro renamed it to "261003 Dekomp" in the app). Recorded in [[port-design]] (UI Design).

---

## [2026-10-07] update | PitchControl page scrollbar margin

The page scroll area now has 6 px side margins instead of padding, so its scrollbar ends 6 px from the window edge like the header and footer; the scrollbar thumb keeps a 6 px gap to the panels.

---

## [2026-10-07] update | PitchControl Rig and Fixtures side by side

In the single-column layout the Fixtures page shows the Rig and Fixtures panels side by side (each only as tall as its content); in the column layout they stay stacked.

---

## [2026-10-07] update | PitchControl full-width Inputs, Outputs and Fog

Inputs (audio | MIDI), Fog (one machine per half) and Outputs (settings | live output) use two equal columns in the column layout and one full-width column in the single-column layout, like Settings already did; the old fixed maximum widths are gone.

---

## [2026-10-07] update | PitchControl toggle switches

All checkboxes are now pill-shaped on/off switches (ink track with glow and a dark knob when on, outlined track with a dim knob when off, knob centred for "multiple" in multi-edit). Miro chose the rounded pill over a square variant, as the one exception to the square-only style. Recorded in [[port-design]] (UI Design).
