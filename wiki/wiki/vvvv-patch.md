---
date_created: 2026-07-09
date_modified: 2026-07-09
---

# vvvv Gamma Patch

> The central control software: a vvvv gamma 7.0 patch running on a computer that drives all PitchPlease hardware versions via serial (v1/v2) or DMX (v3).

## Overview

The vvvv gamma patch is the brain of the system. It handles audio analysis, visual scene generation, MIDI controller input, and output to the LED hardware. A single patch supports all hardware versions — the connection method differs by version.

**File:** `vl/root_gamma_6-6.vl`
**vvvv version:** gamma 7.0
**Note:** The filename `root_gamma_6-6.vl` is a leftover from when the patch was created in gamma 6.6. It needs to be renamed.

## Hardware Connections

| Hardware | Protocol | Interface |
|---|---|---|
| [[v1]] (Arduino mono) | Serial, 57600 baud | USB |
| [[v2]]a (2 strips) | Serial, 57600 baud | USB |
| [[v2]]b (4 strips R4) | Serial, 921600 baud | USB |
| [[v3]] (ESP32 DMX) | DMX512 via Enttec Pro | USB-DMX |
| [[v3]] (ESP32 DMX) | ArtNet → QLC+ → Enttec Open | USB-DMX |

For v3, both devices (DMX address 100 and 200) can be driven simultaneously since they occupy different DMX channels.

## MIDI Controller

A Novation Launch Control XL Mk3 is used for live performance control — scene switching, parameter automation.

## Custom HLSL Shaders

Three `TextureFX` shaders in `vl/shaders/` (vvvv uses SDSL, a superset of HLSL):

- **`GeneratorNoise_TextureFX.sdsl`** — animated 3D simplex noise (Time, Scale, Offset, Brightness, Contrast, Color)
- **`VerticalSymmetry_TextureFX.sdsl`** — mirrors texture around horizontal center
- **`MixIdleMaskWithPeaksMap_TextureFX.sdsl`** — composites idle animation with audio peaks map

## Scene System

Eight scenes defined in `vl/Scenes/Scene1.ini` through `Scene8.ini`. These are parameter presets/snapshots, recalled during performance via the Launch Control XL.

## Shader Development

A separate Visual Studio / sdpkg project in `vl/EditShaders/` is used for developing and testing the HLSL shaders outside the main patch. Requires the SDSL NuGet package.

## File Layout

| File/Folder | Purpose |
|---|---|
| `vl/root_gamma_6-6.vl` | Main patch (rename pending) |
| `vl/vl/VL.Devices.ENTTEC.vl` | Enttec device library (DMX output) |
| `vl/shaders/` | Custom HLSL/SDSL TextureFX shaders |
| `vl/Scenes/` | Scene preset INI files |
| `vl/macros.ini` | vvvv macro definitions |
| `vl/EditShaders/` | Shader development project |
| `util/vvvv_gamma_6.6_setup.exe` | Archived installer (old version) |

## See Also

- [[v1]], [[v2]], [[v3]] — Hardware targets
- [[hardware]] — USB-DMX interfaces

## Open Questions

- What aspects of audio analysis happen in vvvv (FFT, peak detection)? Is there a dedicated audio analysis sub-patch?
- How are the 8 scenes organized — by intensity, color palette, or visual style?
- Is QLC+ used regularly or only as a fallback when the Enttec Pro isn't available?
- Future: phone → vvvv WiFi bridge for remote control (see [[v3]])
