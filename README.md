# PitchPlease

A hobby project: audio-reactive LED lighting for live music. Custom LED light poles, built over three hardware generations, from PWM-dimmed strips to addressable WS2811 strips over DMX512. They are played together with off-the-shelf DMX fixtures (pinspots, LED panels) by control software on a laptop.

## How it works

The control software analyses the music in real time and turns it into light. Kicks trigger strobes; between them, shader-like masks drift across the rig in two colour groups. The output goes over DMX to the PitchPlease V3 devices and third-party fixtures, and over USB serial to the older V2 strips. A Novation Launch Control XL Mk3 is used to play it live.

```
Audio in → PitchControl → Enttec DMX USB Pro → DMX512 → V3 light poles, pinspots, LED panels
                       ↘ USB serial → V2 strips      ↘ Art-Net (optional)
```

There are two versions of the control software:

- **[PitchControl](pitch_control/README.md)** (`pitch_control/`, current): a cross-platform app (macOS, Windows) with a Python engine and a web UI in its own window. It ports the vvvv patch and adds JSON fixture types and rigs, a full-keyboard UI, MIDI page switching and a Control Desk for manual DMX overrides. Audio, the LCXL3 and Enttec output have been verified on hardware. Art-Net, V2 serial and the Windows build have not.
- **vvvv gamma patch** (`vl/`, original): the patch PitchControl was ported from. Its logic is reverse-engineered in the wiki ([vvvv patch](docs/wiki/vvvv-patch.md), [patch logic](docs/wiki/vvvv-patch-logic.md)).

## Hardware versions

| Version | MCU | Strips | Protocol | Status |
|---|---|---|---|---|
| [V1](docs/wiki/v1.md) | Arduino | 2× mono RGB (PWM) | Serial 57600 | Archived |
| [V2a](docs/wiki/v2.md) | Arduino | 2× WS2811 | Serial 57600 | Archived |
| [V2b](docs/wiki/v2.md) | Arduino R4 | 4× WS2811 | Serial 921600 | Archived, still usable |
| [V3](docs/wiki/v3.md) | ESP32 | 4× 140 cm WS2811 per device | DMX512 | **Active** |

Two V3 units are in use (DMX start addresses 100 and 200) and two more are being built ([assembly notes](docs/wiki/v3-assembly.md)). The PitchControl rig already places them at 300 and 400. See also the [cross-version hardware comparison](docs/wiki/hardware.md) and the [third-party fixtures](docs/wiki/fixtures.md).

## Folder structure

```
pitch_control/              PitchControl, the current control software (see its README)
  backend/                    Python engine: audio, masks, fixtures, DMX / serial / MIDI, API
  frontend/                   Vite + React + TypeScript UI
  config/                     Fixture types, rigs, controllers, scenes, settings (JSON, committed)
  packaging/                  Standalone app builds (macOS .app, Windows .exe)
  run.command, run.bat        Start from source on macOS / Windows

v3_esp32_dmx/               Version 3: ESP32 + DMX512 (current hardware)
  firmware/
    v3-2_esp32_dmx_platformio/    Active PlatformIO project (+ firmware-flasher.command)
    v3-0_esp32_dmx_arduino_ide/   Outdated Arduino IDE project
  pcb/                          Fritzing PCB designs and Gerbers (v3.0, v3.2.0, v3.2.1)
  case/                         Rhino 3D case files and print exports (v3.0, v3.1, v3.2)

v2_ws2811/                  Version 2: WS2811 addressable strips (serial)
  firmware/
    pitch_please_w2811/               V2a: 2 strips, 57600 baud
    pitch_please_w2811_4-channel/     V2b intermediate: 4 strips, R3, bandwidth-limited
    pitch_please_w2811_4_channel_r4/  V2b: 4 strips, R4, 921600 baud

v1/                         Version 1: Arduino PWM mono-colour strips
  firmware/pitch_please_mono/   Arduino sketch
  hardware/pcb/                 Fritzing PCB design and Gerbers (2019)

vl/                         The original vvvv gamma 7 patch
  root_gamma_7-3.vl             Main patch
  shaders/                      Custom HLSL/SDSL shaders
  Scenes/                       8 saved scenes (imported into PitchControl)
  EditShaders/                  Shader development project

testing/                    Archived prototypes and experiments
  standalone_esp32/             Deprecated ESP32 prototype (onboard FFT + web UI)
  cases/                        3D print tests for a never-built 19" rack version

docs/                       Project wiki (Obsidian vault, LLM-maintained)
  CLAUDE.md                     Wiki schema and conventions
  wiki/                         Wiki pages
  raw/, images/                 Ingested sources and images

```

## Quick start (PitchControl)

macOS: double-click `pitch_control/run.command`. Windows: double-click `pitch_control/run.bat`. On first start they set up Python and build the UI, then open the app in the browser. To build the standalone app instead, run `pitch_control/packaging/build_macos.command` or `build_windows.bat`. Details are in the [PitchControl README](pitch_control/README.md).

## Wiki

The wiki in `docs/` is maintained with the help of an LLM, following the [Karpathy llm-wiki pattern](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f). Open the folder in [Obsidian](https://obsidian.md/) for graph navigation, or browse the pages directly:

- [Index](docs/wiki/index.md): all pages · [Log](docs/wiki/log.md): chronological activity log
- [Overview](docs/wiki/overview.md): project summary and version history
- [Hardware](docs/wiki/hardware.md): cross-version comparison, PCBs, case, USB-DMX interfaces
- [V1](docs/wiki/v1.md) · [V2](docs/wiki/v2.md) · [V3](docs/wiki/v3.md) · [V3 assembly](docs/wiki/v3-assembly.md): per-version details
- [PitchControl design](docs/wiki/port-design.md): architecture, decisions and status of the port
- [vvvv patch](docs/wiki/vvvv-patch.md) · [vvvv patch logic](docs/wiki/vvvv-patch-logic.md): the original control software
- [Fixtures](docs/wiki/fixtures.md): third-party DMX fixtures used at events
- [WiFi bridge](docs/wiki/wifi-bridge.md): future idea, phone remote control
