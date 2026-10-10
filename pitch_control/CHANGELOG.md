# Changelog

All notable changes to PitchControl. Versions follow [semantic versioning](https://semver.org/):
**major** = old config files (rigs, fixture types, settings) no longer load, **minor** = new
features, **patch** = fixes only. Releases are tagged `pitchcontrol-vX.Y.Z`.

## Unreleased

## 1.2.1 — 2026-10-09

### Fixed
- **First start:** with no saved macro values (a new checkout or install; the saved state is not in
  the repo) all faders started at 0, so the lights stayed dark. The macros now start with the values
  of scene 1.

### Changed
- **Windows build script:** the window stays open at the end, the output of every step goes to
  `build-windows.log` (the window shows the step names and, on a failure, the end of the log), and
  missing or too old Node.js (the UI build needs 20.19+ or 22.12+) and missing Python 3.11 / 3.12 are
  reported up front. The UI packages are reinstalled when the Node version changed (npm skips the
  build tool's platform binary under an old Node), and the Python environment is made with 3.12 or
  3.11 even when a newer Python is installed. On CI nothing changes (no pause, output on the console).
- **Fog page:** the long label "Every … for … seconds" was cut off. The timer is one row now
  (switch, every _ s for _ s); universe and channel, and on / off value, have their captions next to
  the fields; the name field fills the row.
- **Universe dropdowns:** every DMX universe field (Rig, Outputs, Fog) is a dropdown of the universes
  0–3, like the Control Desk's. A value outside that range in an older file is kept and shown as
  "not offered". The Art-Net universe on the wire is a dropdown of 0–15.

## 1.2.0 — 2026-10-09

### Changed
- **Full macro names on the General page:** the abbreviated labels ("Strobo br.", "Sat. A", …) are gone;
  a name too long for its column gets tighter letter spacing and then a smaller font, never a second
  line.
- **Settings format:** `outputs.enttec` in `settings.json` is a list now. Settings from 1.1.0 load
  as before, but a `settings.json` saved by 1.2.0 does not load in 1.1.0.

### Added
- **Up to 4 Enttec DMX USB Pro interfaces:** Outputs → Add interface / Remove; each interface has its
  own device and universe, and its own status dot in the header. Settings with a single interface
  load as before.
- **UI scale shortcuts:** ⌘ (macOS) / Ctrl (Windows) with + or =, −, and 0 for 100 %, saved like the
  Settings slider.
- **Context footer everywhere:** every control on every page now has a tip in the footer (rows,
  buttons, selects, text fields, status indicators, lists, meters, panels, the tabs), and Tab focus
  drives it like the mouse.
- **Context footer:** the key-hint footer lists the keys and mouse actions of the control under the
  mouse or selected with the keyboard, with a short explanation (what each macro does, which
  fixture a Control Desk channel belongs to, …).

## 1.1.0 — 2026-10-08

First public release. A cross-platform (macOS, Windows) port of the vvvv patch with a new UI.

### Added
- **Engine:** 40 FPS, 32-band audio analysis with an octave-weighted strobo trigger. It ports the vvvv
  patch's phase, strobo / idle and colour logic, the four mask presets (Gradient, Back & Forth,
  Rotating Line, Noise) with symmetry and crossfades, scenes and fog timers.
- **Outputs:** Enttec DMX USB Pro, Art-Net, PitchPlease v2 serial. Gamma is applied per channel, the
  same for every output; the PitchPlease v2 / v3 firmware decodes perceptual values itself.
- **Monochrome UI** in its own window (macOS / Windows) or the browser:
  - grey, amber or phosphor ink, glow, UI brightness, UI scale with "Fit window";
  - fully keyboard-driven;
  - custom full screen that covers the MacBook camera notch.
- **Pages:**
  - General, Dimmers (names, unused dimmers disabled);
  - **Fixtures** (fixture type editor with channel layout and channel map);
  - **Rig** (rig files and per-fixture values, multi-edit, overrides of type values);
  - Inputs (audio, MIDI monitor), Outputs, Fog, Settings;
  - **Control Desk** (manual override of any DMX channel, saved across restarts).
- **Novation Launch Control XL Mk3** mapping with General / Dimmers page switching.
- **Config** as plain JSON files (fixture types, rigs, controllers, scenes, settings), edited in the
  app or by hand; unknown keys are logged, never fatal.
- **Version** shown in Settings → About and in the log.

## 1.0.0 — 2026-10-05

First working port of the vvvv patch (not released): the engine, outputs and a first web UI.
