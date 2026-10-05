---
date_created: 2026-07-09
date_modified: 2026-09-27
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
