---
date_created: 2026-10-05
date_modified: 2026-10-05
---

# PitchControl — Cross-Platform Port of the vvvv Patch

> Design of **PitchControl**, the Python engine + web frontend replacing the Windows-only vvvv patch on macOS and Windows; code lives in `pitch_control/` in the repo.

## Name and Location

The software is called **PitchControl** (named 2026-10-05; "pitch control" is a turntable's tempo fader). Code lives in the `pitch_control/` folder of the repo; the Python package is `pitchcontrol`.

## Implementation Status

First version built 2026-10-05 in `pitch_control/` (backend, frontend, config, README). Verified by 33 automated tests:
- config loading;
- the v3 frame against the firmware layout;
- the Enttec, Art-Net and v2 packet formats;
- the band layout and trigger weights;
- the phase, strobo/idle and colour logic;
- masks, scenes and the API.

The UI runs against the engine at 40 FPS in no-hardware mode. The engine frame takes ≈0.5 ms; the 256×256 preview (up to ≈20 ms for noise with symmetry) is rendered outside the engine thread so it cannot delay DMX.

Audio capture from the Komplete Audio 6 on macOS works (stream opens, all 6 inputs readable; tested without a signal, so the band reaction to real music is not yet verified). Not yet verified on hardware: MIDI, Enttec, Art-Net and v2 serial output. `pitch_control/run.command` starts the backend (setting up the venv / building the UI when needed) and opens the UI in the browser. The vvvv scenes and `macros.ini` were imported into `config/scenes/` and `config/state/`.

## Standalone App

Decided 2026-10-05: PitchControl is also packaged as a standalone app for macOS and Windows with PyInstaller (`pitch_control/packaging/`, output in `pitch_control/dist/`).

- **Window:** the app shows the UI in its own native window (pywebview: WKWebView on macOS, WebView2 on Windows). "Open in browser" is available for a second screen or a phone. Closing the window stops the engine.
- **Data folder:** the app uses the repo's `pitch_control/config/` directly (decided 2026-10-05), so new rigs and fixtures can be committed. The repo path is recorded at build time; `~/Documents/PitchControl/data_folder.txt` can point elsewhere; `~/Documents/PitchControl/` is only a fallback. *(Supersedes the earlier same-day decision to keep user data in `~/Documents/PitchControl/`.)* This makes the app single-user for now, which is accepted.
- **Signing:** builds are unsigned, which is acceptable for private use. Gatekeeper and SmartScreen ask once on first launch.
- **Where to build:** each OS builds its own app. The macOS arm64 build works and has been verified: 46 MB, smoke test passes, audio and MIDI load in the bundle, and Quit shuts down cleanly. The Windows build script and a manual GitHub Actions workflow (`.github/workflows/pitchcontrol-app.yml`) exist but have not been run yet.

## Motivation

The [[vvvv-patch]] only runs on Windows. The goal is a port that runs on macOS and Windows, keeps the live-performance behaviour, and moves the hardcoded fixture setup out of the patch into editable config. The algorithms to reproduce are documented in [[vvvv-patch-logic]]. Guiding rule: **keep the existing logic (groups A/B, strobo/idle phases) as much as possible**; change only what the port requires or what is explicitly decided below.

## Architecture

A **Python backend** is the engine. It owns audio input, MIDI, the frame loop and all outputs, and runs headless. A **Vite/React/TypeScript/Tailwind frontend** is a client over WebSocket. If the browser tab crashes or reloads, DMX output continues. This reverses vvvv's model, where UI and engine are one process.

The scene is evaluated **on the CPU only**. Each mask generator is a numpy-vectorised function of `(u, v, state)`. It is evaluated on all fixture pixels for output, and on a fixed **256×256** grid for the frontend preview, so there is a single implementation and no GPU. This also removes the current `Pipet` readback delay (Frame Delay 5, ≈125 ms at 40 FPS). Effects that need neighbouring pixels or previous frames in texture space (feedback, reaction-diffusion) are out of scope by design.

The line masks (BackAndForth, RotatingLine) are rewritten as **gradients based on distance to a line**, replacing the current rectangle + Blur. The rectangles have a flat core, so the profile is `1 − smoothstep(halfWidth, halfWidth + falloff, |d|)`. Lines are infinite (the rectangles are 2 units long in a 1-unit scene). A frontend code editor for generators is optional and deferred.

## Configuration

- **Fixture types**: `fixtures/types/*.json`, one file per device model. All files are autoloaded on startup; missing keys are filled with defaults.
- **Rigs**: `rigs/<event>.json` lists fixture instances that reference a type and set address, universe, UV transform, group, gamma, strobo colour, etc. Switching events means switching rig files.
- **Controllers**: `controllers/*.json`, one MIDI mapping per controller (first one: Novation LCXL3). The active controller is picked from a dropdown on the Inputs page.
- **Logs**: a `logs/` folder with one file per backend start, named `YYMMDD_hhmmss.log`, written while running. Missing and unknown config keys (e.g. typos) and other problems are reported there.
- **Scenes and macros**: new format (likely JSON). The existing 8 `vl/Scenes/*.ini` files and `macros.ini` will be imported once.

Channel layouts are **profiles** (confirmed): an ordered, named list of channel slots in the fixture type file — constants, the pixel block (`R`/`RGB`/`RGBW`, expanded to pixel count × format), macro-bound values (replacing the Dimmers tab's generic static channels), and strobe shutter values. Rig instances can override any named constant (e.g. v3 `mode`). This replaces raw header/footer bytes, which are a subset of it.

## Colour and Brightness Model

**Groups A and B stay** as in the patch. A group is a colour plus the group's strobo/idle brightness macros (Strobo/Idle Bright. A/B). Group colour macros become **Group A Hue, Group A Saturation, Group B Hue, Group B Saturation**.

**Auto Color** overrides the group colours from a palette of **9 full HSB colours** (initially the current 9 hues with S = B = 1). B is the maximum brightness of the idle colour/phase while that entry is active. Every few strobo moments (random 1–8) it picks two entries, A and B independently. A = B is allowed: a fully single-colour scene is fine. The colour change is meant to happen during strobo, which hides it. **Swap Colors** swaps the final A and B colours. Fixtures reference the *final* group colour, not the macro value (this is why ChilloutZone currently samples colour A instead of reading the Hue A macro).

Per fixture: membership in group A or B as today, plus optional overrides. Hue and saturation sources can be the other group or `const`. Brightness can be `const` instead of the strobo/idle pipeline, with an optional range remap (what "Invert Discoball" does today). This covers ChilloutZone. Dimmer macros are usually set per fixture type or per rig group (e.g. "panels behind the DJ").

**Strobo/idle behaviour is kept as is (confirmed intentional):**
- Strobo fixtures show the strobo colour during the strobo phase, then fade from black to the idle colour.
- Non-strobo fixtures go dark on a peak and fade from black to the idle colour during the strobo phase. This deliberately gives strobo fixtures visual space. During the idle phase they stay at full idle-colour brightness.
- The phases never overlap, so strobo and idle colours are exclusive, not additive.

**Hue and saturation apply "on release":** dragging the Hue A/B or Saturation A/B fader in the UI applies the value when the mouse is released. A MIDI knob applies it once the knob has rested for `midi_settle_s` (default 0.4 s), because the LCXL3 knobs have no touch/release event. Until then the fader shows the target with a dashed outline and the lights keep the old colour, so a show never sweeps through the whole gradient.

**Gamma is split into two keys:** *Brightness Gamma* (on HSV value, the current behaviour) and *RGB Gamma* (per R/G/B channel, new).

**Glitches** is renamed to reflect that it controls the amount of audio reactivity (exact name TBD, e.g. "Audio Reactivity").

## UI Design

Redesigned 2026-10-06 from Miro's inspiration (old military computer UIs, Elektron Digitakt screens) via a mockup canvas, then implemented:
- **Palette:** very dark ground (#0f1011) and one bright monochrome "ink" for text, lines and lit elements. The ink is selectable on the Settings page (grey #d8d9d4, amber #e9c46a, phosphor #a8e6b5), as are glow strength, UI brightness (40–100 %, less light at the DJ booth) and key hints; all saved in `settings.json → ui`.
- **Colour:** only where it carries information: the hue/saturation scales (12 half-desaturated steps) with the target colour in the value dot, the group A/B output swatches, and the fixture pixels in the scene preview (plain greyscale mask, no dithering).
- **Layout:** square panels with 1px hairlines and numbered header strips. Bloom glow only under selected, active and held elements. No scanlines or CRT imitation (flat minimal).
- **Faders:** 20 segments with no gaps, separated by a dark 1px seam; each segment fades with the value. Hue is shown as −180…180°, saturation as 0…100 %.
- **Fonts:** Chakra Petch for labels, Share Tech Mono for numbers. Both are bundled, so no internet is needed at a gig.
- **Keyboard:** works fully without a mouse: W/S/A/D select, ↑/↓ change (Shift fine), ⏎ press (Shift+⏎ save scene), Esc cancels pending colour, 1–7 switch pages.

## Full Screen (Desktop App)

macOS native full screen keeps windows below the camera notch of the 14" MacBook Pro and paints the 32 px strip beside it black. Decided 2026-10-06: PitchControl has its own full-screen mode (`fullscreen.py`). It hides the menu bar and Dock and stretches a borderless window over the whole screen, notch strip included, with the window shadow off (its 1 px outline showed at the rounded screen corners). The green window button becomes a plain zoom.

The header has two rows to make this work. The top row is 38 px tall (notch 32 px + 6 px, so the line below it clears the camera island): logo on the left, indicators on the right, nothing in the middle, so the notch sits in empty space. The page tabs are in the second row. F toggles full screen, and Settings → App has "Start in full screen" (`ui.start_fullscreen`).

Tested: the window covers 1512×982 at (0,0) and is restored afterwards. On Windows, pywebview's own full screen is used.

## Frontend Pages

- **General** and **Dimmers**: carried over from the vvvv UI. Their grids always use 8 columns, matching the LCXL3's 8 columns of knobs, faders and buttons.
- **Fixtures**: rig editing.
- **Output**:
  - Enttec Pro: enabled, device, universe.
  - ArtNet: enabled, universe → IP mapping.
  - PitchPlease v2: enabled, device, baudrate.
- **Inputs**: audio device, input channels, gain; active MIDI controller.
- **Settings**: appearance (ink colour, glow, UI brightness, key hints) and the keyboard reference.
- **Fog**: fog machines (the current patch has two timers: every 60 s for 4 s, and ground fog every 60 s for 2 s, plus manual trigger).

Serial devices are chosen from a **dropdown of USB device names**. The app stores the USB serial number and VID:PID, and keeps the port path only as a fallback, since COM numbers and `/dev/cu.*` names are not stable.

## Audio Analysis

ASIO on Windows is available for the Komplete Audio 6. The current 128-sample FFT is too coarse at the low end (see [[vvvv-patch-logic]]: bin 1 spans ~0–750 Hz). Config, tuned for techno/house (confirmed 2026-10-05):

| Setting | Value |
|---|---|
| FFT size / hop | 2048 / 512 samples at 48 kHz (23.4 Hz bins, ~94 analyses/s) |
| Window | Hann; power spectrum, proper `10·log10` dB |
| Bands | **32**, 35 Hz – 10 kHz, log-spaced, each at least 1 FFT bin wide |
| Per frame | max over the analyses since the last frame, so transients aren't missed |
| Normalisation | per band (own decaying max, with a dB floor), not one shared max |
| Envelope | instant attack, configurable release |
| Strobo trigger | weighted fraction of peaking bands; weight 100 % at ≤ 100 Hz falling **linearly over octaves** to 0 % at ≥ 5 kHz (≈ 59 % at 300 Hz, 41 % at 1 kHz); edges configurable |

Band distribution: sub + kick fundamental (35–90 Hz) 3 bands; kick body / bass (90–250 Hz) 6; low mids / clap body (250–1000 Hz) 9; clap and snare crack, percussion, synths (1–5 kHz) 10; hats (5–10 kHz) 4. 64 bands were rejected: at this FFT size the extra bands land in the mids, not the low end, and the lowest 17 would be single-bin duplicates. The 1D peaks map can still be upsampled to 64 texels if needed.

## Dropped from the Port

Everything Beam Ball related: Wanderer, ArtNet input from MadMapper, BB macros M44–M47, "Art-Net Color" button, Beam Ball visualiser. Also the Audio Filter macro, the unused `GeneratorBackToFront`, and the unconnected cone calculation in `PitchPlsToDMXv3`.

## Open Questions

- The current patch normalises all FFT bins by **one shared** running max (see [[vvvv-patch-logic]]); the port uses per-band normalisation as agreed. Confirm this behaviour change is intended.
- ~~LCXL3 mapping~~ Confirmed working 2026-10-05 (MIDI channel 13, knob row 3 + faders). On 2026-10-06 the mapping became page-aware: the same controls drive the active page (General or Dimmers), and CC 13 switches pages (see [[vvvv-patch-logic]]). The UI and controller page stay in sync. Untested on hardware. Scene buttons and the shift layer are not mapped yet.
- Fixture details the patch does not pin down (all marked `VERIFY` in `pitch_control/config`):
  - Pinspots: 4-channel RGBW (confirmed). Hardware strobe would need the 9-channel mode; dropped for now (see Future: Hardware Strobe).
  - LED bars: the 6-channel header is unknown.
  - ~~Front panels: possibly 4 channels each~~ Resolved: 3 channels; addresses step by 4 only for continuity with the pinspots.
  - Fog machines: resolved — fog on DMX 1, ground fog on DMX 2 (universe 0, 255 = on), found in the patch's `DMXOutput` (`SetDMXChannel` is 1-based).
- ~~LED bar address~~ Resolved 2026-10-05: LED bars are not part of the setup and were removed from the default rig; v3 units #1–#4 are all enabled.
- Mask look: confirmed to match vvvv so far, except that Back and Forth rotates in 45° steps where vvvv uses 90° steps. Left as is for now (Miro, 2026-10-05).
- ~~Is the restart of the line movement on every peak intended?~~ Yes (confirmed 2026-10-05): some masks deliberately reset on a peak.

## Engine Rate

The engine runs at **40 FPS** (confirmed), just under the ~44 Hz maximum refresh of a full 512-channel DMX universe.

## Future: Hardware Strobe (Proposal)

At 30–40 FPS the software cannot render a convincing strobe, so fixtures that have a built-in strobe should use it. The problem is that every fixture implements strobe differently. Proposal:

- The engine requests strobe in **physical units**, e.g. *strobe at 12 Hz for 400 ms*, or *single flash*, independent of the fixture.
- The fixture **profile** gets a `strobe` channel slot that translates this request into DMX:
  - the value meaning "no strobe/open";
  - the DMX range meaning "strobing";
  - the measured flash frequency at both ends of that range;
  - an optional curve or lookup table, since manufacturer speed curves are rarely linear.
  
  A profile without a strobe slot falls back to the software strobe.
- Frequencies must be **measured once per fixture model** (e.g. by filming with a high-frame-rate camera), because datasheets are often wrong.
- Open: how strobe speed is derived from the music (fixed, tempo-synced, or from peak score), and whether the shutter/dimmer channels need to be driven simultaneously.

## See Also

- [[vvvv-patch]] — the patch being replaced
- [[vvvv-patch-logic]] — reverse-engineered algorithms
- [[v3]] — DMX layout of the PitchPlease v3 devices
- [[wifi-bridge]] — phone control, which the web frontend may make simpler
