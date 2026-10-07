# PitchControl

Audio-reactive light control for PitchPlease, a cross-platform (macOS / Windows) port of the vvvv gamma patch in `../vl/`.
The design and the reverse-engineered vvvv logic are documented in the wiki: `Claude/wiki/port-design.md` and `Claude/wiki/vvvv-patch-logic.md`.

- **Backend** (`backend/`, Python): the engine, which runs at 40 FPS in its own thread and owns audio, MIDI and all outputs. It keeps running if the browser is closed.
- **Frontend** (`frontend/`, Vite + React + TypeScript + Tailwind): the pages General, Dimmers, Fixtures, Output, Inputs and Fog. It talks to the backend over HTTP and a WebSocket.
- **Config** (`config/`): plain JSON, edited from the UI or by hand.

## Run

**macOS:** double-click `run.command`. On first run it sets up the Python environment and builds the UI (it rebuilds when sources change), then starts the backend and opens the UI in the browser. Close the Terminal window to stop. Extra arguments are passed through, e.g. `./run.command --no-hardware`.

**Windows:** double-click `run.bat` — same behaviour (uses `uv` if installed, otherwise `py -3` / `python`).

Manual setup — requirements: Python ≥ 3.11 with [uv](https://docs.astral.sh/uv/), and Node ≥ 20 (only to build the UI).

```bash
cd pitch_control/backend
uv venv && uv pip install -e ".[dev]"
cd ../frontend && npm install && npm run build
cd ../backend && .venv/bin/python -m pitchcontrol
```

Open http://127.0.0.1:8420.

Options:
- `--no-hardware` runs without audio, MIDI and outputs.
- `--host 0.0.0.0` lets other devices (a phone) on the LAN reach the UI.
- `--port`, `--config`, `--logs` change the defaults.

On Windows, use `.venv\Scripts\python -m pitchcontrol`. ASIO devices appear in the Inputs page device list.

For frontend development, run `npm run dev` in `frontend/` (port 5173, proxied to the backend on 8420).

Tests: `cd backend && .venv/bin/python -m pytest`.

## Standalone app

`packaging/` builds a self-contained app (no Python or Node needed on the target machine). It must be built on the target OS:

- **macOS:** double-click `packaging/build_macos.command` (or run it from Terminal); it produces `dist/PitchControl.app` and `dist/PitchControl-macos-<arch>.zip` (about 46 MB, 22 MB zipped). An Apple Silicon build runs only on Apple Silicon Macs.
- **Windows:** `packaging\build_windows.bat` produces `dist\PitchControl\PitchControl.exe` and a zip.
- **Both, on GitHub:** Actions → "PitchControl app" → Run workflow (`.github/workflows/pitchcontrol-app.yml`), then download the zips from the run.

The app shows the UI in its own window. "Open in browser" and "Data folder" are in the header. Closing the window stops the engine.

**Data folder:** the app works directly on the repo's `pitch_control/config/`, so rigs, fixture types, settings and scenes edited in the app can be committed. Logs go to `pitch_control/logs/` and the macro autosave to `config/state/`; both are gitignored. The build records where the repo is on the build machine. The folder is chosen in this order:

1. the `--data <folder>` option;
2. a folder path written in `~/Documents/PitchControl/data_folder.txt` (useful for an app built on GitHub, which doesn't know where your repo is);
3. the repo's `pitch_control/` folder;
4. `~/Documents/PitchControl/` as a fallback. Missing default files are copied in there, and existing files are never overwritten.

The builds are unsigned. On first launch:
- macOS: right-click the app → Open → Open.
- Windows: SmartScreen → More info → Run anyway.

macOS asks once for microphone access.

App options (for example from a terminal) are the same as for the backend, plus `--data <folder>` and `--no-window` (use the browser instead of a window). `--host 0.0.0.0` makes the UI reachable from a phone on the LAN.

## Using the UI

The UI is monochrome (Settings → Appearance: grey, amber or phosphor ink, glow strength, UI brightness, key hints; saved in `settings.json`). Colour only appears where it carries information: the hue/saturation scales and the output colours.

Everything works without a mouse — one control is always selected:

| Key | Action |
|---|---|
| W / S | move the selection up / down a row |
| A / D | move the selection left / right |
| ↑ / ↓ | change the selected value (Shift = fine) |
| ⏎ | press the selected button, load the selected scene (Shift + ⏎ = save) |
| Esc | cancel a pending hue / saturation change |
| 1 – 7 | switch page |
| F | full screen on / off (desktop app; on a MacBook it also covers the camera-notch strip) |

Number fields apply on Enter and keep the focus, so you can type the next value right away (Escape reverts). ↑ / ↓ or dragging up / down with the right mouse button changes the value in steps (Shift = fine steps): integers 1, floats 0.1 / 0.01, fixture rotation 15° / 1°.

On the Fixtures page, Shift + click adds fixtures to the selection (or removes them) to edit several at once. A field shows a value only if all selected fixtures share it, otherwise "multiple"; a value you enter applies to all of them.

Hue and saturation apply on mouse release, or once keys / the MIDI knob rest; until then the fader shows the target with a dashed outline.

## Config folder

| Path | Content |
|---|---|
| `settings.json` | outputs (Enttec, Art-Net, v2 serial), audio input, fog machines, Auto Color palette, engine options |
| `fixtures/types/*.json` | one file per fixture model; all files are loaded on startup, missing keys get defaults |
| `rigs/<name>.json` | fixture instances for one event: type, group A/B, universe/address, UV placement (rotation in degrees), dimmer macro, colour sources |
| `controllers/*.json` | MIDI controller mappings (CC → macro) |
| `scenes/scene_N.json` | the 8 scenes (macro name → control value) |
| `state/macros.json` | auto-saved macro values for crash recovery (not in git) |

Unknown keys (typos) and broken files are reported in `logs/YYMMDD_hhmmss.log` (one file per start) and never stop the engine. Keys starting with `_` (e.g. `_note`) are annotations and are ignored.

A fixture **profile** is the ordered `channels` list of a fixture type:

```json
"channels": [
  { "name": "master", "value": 255 },
  { "name": "dimmer", "macro": "Dimmer 03" },
  { "name": "strobe", "shutter": { "open": 0, "strobo": 200 } },
  { "pixels": "RGB" }
]
```

`value` is a constant (a rig can override it by name with `channel_values`). `macro` sends a macro's value as 0–255. `shutter` sends `strobo` on a peak frame when the instance has `real_strobo` enabled. `pixels` expands to pixel count × `R` / `RGB` / `RGBW`.

To re-import the vvvv scenes and `macros.ini`: `.venv/bin/python -m pitchcontrol.legacy`.

## Status (2026-10-05)

Working and covered by tests:
- config loading and typo reporting;
- the v3 DMX frame (checked against the v3.2 firmware layout);
- Enttec Pro, Art-Net and v2.2 serial packet formats;
- the 32-band analysis with octave-weighted strobo trigger;
- the phase, strobo/idle and colour logic;
- the mask generators and noise port, crossfade and symmetry;
- scenes, the REST API and the WebSocket.

The UI runs against the engine at 40 FPS in no-hardware mode.

Verified by Miro on macOS: audio input and analysis (microphone test) and the LCXL3 MIDI controller. **Not yet verified on hardware:** Enttec, Art-Net and v2 output. Fixture details and the LCXL3 mapping were confirmed by Miro on 2026-10-05.

The masks match the vvvv look so far, except that Back and Forth rotates in 45° steps (vvvv: 90°); left as is for now.
