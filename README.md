# PitchPlease

A hobby project: audio-reactive LED lighting, controlled from a custom [vvvv gamma](https://visualprogramming.net/) patch. Three hardware generations have been built, evolving from simple PWM-dimmed strips to fully addressable WS2811 strips over DMX512.

## How it works

vvvv analyses audio in real time, generates a visual signal (brightness/color curves), and sends it to one or more LED controller devices. The current version (V3) uses ESP32 microcontrollers receiving DMX512 over RS-485, each driving four 140 cm WS2811 LED strips. Live scene switching is done with a Novation Launch Control XL Mk3 MIDI controller.

```
Audio → vvvv patch → USB-DMX (Enttec) → DMX512 → ESP32 devices → WS2811 strips
```

→ [vvvv patch details](wiki/wiki/vvvv-patch.md) · [V3 hardware details](wiki/wiki/v3.md)

## Hardware versions

| Version | MCU | Strips | Protocol | Status |
|---|---|---|---|---|
| [V1](wiki/wiki/v1.md) | Arduino | 2× mono RGB (PWM) | Serial 57600 | Archived |
| [V2a](wiki/wiki/v2.md) | Arduino | 2× WS2811 | Serial 57600 | Archived |
| [V2b](wiki/wiki/v2.md) | Arduino R4 | 4× WS2811 | Serial 921600 | Archived |
| [V3](wiki/wiki/v3.md) | ESP32 | 4× WS2811 per device | DMX512 | **Active** |

→ [Cross-version hardware comparison](wiki/wiki/hardware.md)

## Folder structure

```
v1/                         Version 1 — Arduino PWM mono-color strips
  firmware/pitch_please_mono/   Arduino sketch
  hardware/pcb/                 Fritzing PCB design + Gerbers (2019)

v2_ws2811/                  Version 2 — WS2811 addressable strips
  firmware/
    pitch_please_w2811/         V2a: 2 strips, 57600 baud
    pitch_please_w2811_4-channel/  V2b-intermediate: 4 strips, R3, bandwidth-limited
    pitch_please_w2811_4_channel_r4/  V2b: 4 strips, R4, 921600 baud

v3_esp32_dmx/               Version 3 — ESP32 + DMX512 (current)
  firmware/
    v3_esp32_dmx_platformio/    Active PlatformIO project (src/ has .ino, .cpp, .h)
    v3_esp32_dmx/               Outdated Arduino IDE project (to be deleted)
  hardware/                     Fritzing PCB, Gerbers, Rhino 3D case files

vl/                         vvvv gamma 7.0 patch
  root_gamma_6-6.vl             Main patch (filename stale, pending rename)
  shaders/                      Custom HLSL/SDSL shaders
  Scenes/                       8 saved scene presets (Scene1.ini–Scene8.ini)
  EditShaders/                  Shader dev sdpkg project

testing/                    Archived prototypes and experiments
  standalone_esp32/             Deprecated ESP32 prototype (onboard FFT + web UI)
  cases/                        Obsolete 3D print tests for a never-built 19" rack version

wiki/                       Project wiki (Obsidian + LLM-maintained)
  CLAUDE.md                     Wiki schema and conventions
  raw/                          Ingested source documents
  wiki/                         Generated wiki pages
```

## Wiki

The `wiki/` folder contains a project wiki maintained with the help of an LLM (following the [Karpathy llm-wiki pattern](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f)). Open the folder in [Obsidian](https://obsidian.md/) for graph navigation, or browse the pages directly:

- [Overview](wiki/wiki/overview.md) — project summary and full version history
- [Hardware](wiki/wiki/hardware.md) — cross-version comparison, PCBs, case, USB-DMX interfaces
- [vvvv patch](wiki/wiki/vvvv-patch.md) — shaders, scenes, MIDI, serial/DMX output
- [V1](wiki/wiki/v1.md) · [V2](wiki/wiki/v2.md) · [V3](wiki/wiki/v3.md) — per-version details
- [WiFi bridge](wiki/wiki/wifi-bridge.md) — future dev: phone remote control via vvvv
