# PitchPlease

A hobby project: audio-reactive lighting for live music. The repo holds two things:

1. **The control software** that listens to the music and plays the lights: **PitchControl**, and the original vvvv patch it was ported from.
2. **The hardware design** of the PitchPlease light poles: three generations of LED fixtures, from PWM-dimmed strips to addressable WS2811 strips over DMX512, with firmware, PCBs and 3D-printed cases.

At events, the PitchPlease poles are played together with off-the-shelf DMX fixtures (pinspots, LED panels).

![PitchControl, General page](pitch_control/screenshots/general.png)

---

# Part 1: Control software

## How it works

The control software analyses the music in real time and turns it into light. Kicks trigger strobes; between them, shader-like masks drift across the rig in two colour groups. The output goes over DMX to the PitchPlease V3 poles and third-party fixtures, and over USB serial to the older V2 strips. A Novation Launch Control XL Mk3 is used to play it live.

```
Audio in → PitchControl → Enttec DMX USB Pro → DMX512 → V3 light poles, pinspots, LED panels
                       ↘ USB serial → V2 strips      ↘ Art-Net (optional)
```

## PitchControl

[PitchControl](pitch_control/README.md) (`pitch_control/`) is the current control software. It is a cross-platform app (macOS, Windows) with a Python engine running at 40 FPS and a web UI in its own window. It ports the vvvv patch and adds:

- JSON fixture types and rigs, edited in the app and committed with the repo;
- a monochrome UI that works entirely from the keyboard, built for a dark DJ booth;
- MIDI control with page switching on the Launch Control XL;
- a Control Desk for manual overrides of any DMX channel.

Status: audio, the Launch Control XL and Enttec DMX output have been verified on hardware. Art-Net, V2 serial output and the Windows build have not been tested yet.

**Download:** ready-to-run builds for macOS (Apple Silicon) and Windows are on the [Releases page](https://github.com/hlavamir/PitchPlease/releases/latest); no Python or Node needed. The current version is in [CHANGELOG.md](pitch_control/CHANGELOG.md).

**From source:**
- **macOS:** double-click `pitch_control/run.command`.
- **Windows:** double-click `pitch_control/run.bat`.

On first start they set up Python and build the UI, then open the app in the browser. To build the standalone app yourself, run `pitch_control/packaging/build_macos.command` or `build_windows.bat`. Screenshots of every page and all details are in the [PitchControl README](pitch_control/README.md).

## The original vvvv patch

`vl/` holds the vvvv gamma patch that ran the lights before PitchControl. It has HLSL/SDSL shaders for the masks and 8 saved scenes, which were imported into PitchControl. Its logic is reverse-engineered in the wiki ([vvvv patch](docs/wiki/vvvv-patch.md), [patch logic](docs/wiki/vvvv-patch-logic.md)).

---

# Part 2: Hardware design

## Light pole versions

| Version | MCU | Strips | Protocol | Status |
|---|---|---|---|---|
| [V1](docs/wiki/v1.md) | Arduino | 2× mono RGB (PWM) | Serial 57600 | Archived |
| [V2a](docs/wiki/v2.md) | Arduino | 2× WS2811 | Serial 57600 | Archived |
| [V2b](docs/wiki/v2.md) | Arduino R4 | 4× WS2811 | Serial 921600 | Archived, still usable |
| [V3](docs/wiki/v3.md) | ESP32 | 4× 140 cm WS2811 per device | DMX512 | **Active** |

**V3** is the current design. It is an ESP32 that receives DMX512 over RS-485 (MAX485) and drives four WS2811 strips through a level-shifting buffer. The board is a custom Fritzing PCB, and the case is a 3D-printed enclosure around a Plexiglas tube with a threaded "spine" rod for stiffness. Two units are in use (DMX start addresses 100 and 200) and two more are being built ([assembly notes](docs/wiki/v3-assembly.md)); the PitchControl rig already places them at 300 and 400.

See also the [cross-version hardware comparison](docs/wiki/hardware.md) and the [third-party fixtures](docs/wiki/fixtures.md) used alongside the poles.

---

## Folder structure

```
Control software
  pitch_control/              PitchControl (see its README)
    backend/                    Python engine: audio, masks, fixtures, DMX / serial / MIDI, API
    frontend/                   Vite + React + TypeScript UI
    config/                     Fixture types, rigs, controllers, scenes, settings (JSON, committed)
    packaging/                  Standalone app builds (macOS .app, Windows .exe)
    screenshots/                One screenshot per page
    run.command, run.bat        Start from source on macOS / Windows
  vl/                         The original vvvv gamma 7 patch
    root_gamma_7-3.vl             Main patch
    shaders/                      Custom HLSL/SDSL shaders
    Scenes/                       8 saved scenes (imported into PitchControl)
    EditShaders/                  Shader development project

Hardware design
  v3_esp32_dmx/               Version 3: ESP32 + DMX512 (current)
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
  testing/                    Archived prototypes and experiments
    standalone_esp32/             Deprecated ESP32 prototype (onboard FFT + web UI)
    cases/                        3D print tests for a never-built 19" rack version

Documentation
  docs/                       Project wiki (Obsidian vault, LLM-maintained)
    CLAUDE.md                     Wiki schema and conventions
    wiki/                         Wiki pages
    raw/, images/                 Ingested sources and images
```

## Wiki

The wiki in `docs/` covers both parts and is maintained with the help of an LLM, following the [Karpathy llm-wiki pattern](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f). Open the folder in [Obsidian](https://obsidian.md/) for graph navigation, or browse the pages directly:

- [Index](docs/wiki/index.md): all pages · [Log](docs/wiki/log.md): chronological activity log
- [Overview](docs/wiki/overview.md): project summary and version history
- Control software: [PitchControl design](docs/wiki/port-design.md) · [vvvv patch](docs/wiki/vvvv-patch.md) · [vvvv patch logic](docs/wiki/vvvv-patch-logic.md) · [WiFi bridge](docs/wiki/wifi-bridge.md) (future idea: phone remote control)
- Hardware: [Hardware comparison](docs/wiki/hardware.md) · [V1](docs/wiki/v1.md) · [V2](docs/wiki/v2.md) · [V3](docs/wiki/v3.md) · [V3 assembly](docs/wiki/v3-assembly.md) · [Third-party fixtures](docs/wiki/fixtures.md)

---

## Support this project 🍺

Did PitchPlease give you ideas for your own lights, or save you some time and effort? Would you like to support future development? Consider buying me a beer (or a coffee).

→ https://ko-fi.com/zeys_hlvmr

Thanks! ❤️

---

## License

MIT — see [LICENSE](LICENSE).
