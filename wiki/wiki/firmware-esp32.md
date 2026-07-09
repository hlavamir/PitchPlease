---
date_created: 2026-07-09
date_modified: 2026-07-09
---

# ESP32 Standalone Firmware (Deprecated)

> **OUTDATED — This page describes the `standalone_esp32/` prototype, which is deprecated and may be deleted. For the current ESP32 firmware, see [[v3]].**

## Status

`standalone_esp32/` was the first take on v3: an ESP32 with onboard audio analysis (FFT via AudioKit), LED driving, and a WiFi-hosted web control UI accessible from a phone or laptop browser. The concept was abandoned in favour of the DMX-based [[v3]] architecture.

The folder is kept for archival reference only. A related future idea remains open: a WiFi bridge from phone → vvvv (not directly to the ESP32) for remote light control. See [[v3]] Open Questions.

## What It Was

- **MCU:** AI Thinker AudioKit (ESP32 + ES8388 audio codec)
- **Audio:** onboard FFT at 44100 Hz, 512 bins
- **LEDs:** 4× WS2811 strips driven directly from ESP32
- **Control:** embedded web server (AsyncWebServer), 16 CC sliders, accessible over WiFi
- **Networks:** hardcoded list (nsynk, Doppelfiggo, Miro's iPhone hotspot)

## Why It Was Abandoned

The architecture was self-contained but made it harder to evolve the visual logic, which lives in the vvvv patch. The DMX approach of [[v3]] keeps computation on the computer and makes the ESP32 a pure DMX-to-LED converter, which is simpler and more flexible.

## Source Files (Archived)

| File | Role |
|---|---|
| `standalone_esp32/src/pitch_please_esp32_standalone.ino` | Main loop, audio, signal processing |
| `standalone_esp32/src/led_output.h` | FastLED setup and helpers |
| `standalone_esp32/src/webserver.h` | WiFi + embedded web UI |
| `standalone_esp32/src/utilities.h` | Shared utilities |
| `standalone_esp32/platformio.ini` | PlatformIO build config |

## See Also

- [[v3]] — Current active ESP32 firmware
