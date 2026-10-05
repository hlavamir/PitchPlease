---
date_created: 2026-10-05
date_modified: 2026-10-05
---

# vvvv Patch Logic (Reverse-Engineered)

> Algorithm-level reconstruction of the vvvv gamma 7.3 patch and the VL libraries it uses, extracted from the `.vl` XML and the vvvv GitHub sources, as the reference for the [[port-design]].

Sources: `vl/root_gamma_7-3.vl` (parsed programmatically: definitions, node graphs, IOBox values), and the public repos `vvvv/VL.Audio` and `vvvv/VL.StandardLibs` (main branch, read 2026-10-05; the patch targets 2025.7.3, so small version differences are possible). Values marked "approx." were read from the node graph but not fully traced through every branch.

## Audio Input and FFT

`AudioIn` (ASIO, Komplete Audio 6, 48 kHz, input channels 3–4) → the two channels are summed (`+ (Spectral)`) → VL.Audio `FFT` node (`FFTOutSignal.cs`).

The FFT node's **Bin Count is half the FFT size**: the VL wrapper multiplies it by 2, so Bin Count 64 means a **128-sample FFT**. Window function is the default **Hann**, dB range the default **72**, smoothing **0.75** (set in the patch). The FFT runs on non-overlapping 128-sample blocks, i.e. 375 times per second at 48 kHz, with **375 Hz bin spacing**. Per bin `k ≥ 1`:

`out[k] = 20·log10(max(|X_k|², 10^(−72/20))) / 72 + 1`, then `out[k] = lerp(out[k], previous, 0.75)`.

Bin 0 (DC) is forced to 0. Smoothing is applied per FFT block, not per frame, so its time constant is only ~4 blocks ≈ 11 ms. The 40 FPS main loop reads whatever the latest block produced.

### Why the first band is much louder

Three effects stack up:

1. Bin 1 is centred at 375 Hz, and the Hann main lobe spans ±2 bins, so it collects everything from DC to ~750 Hz: kick, bass, low mids, and any DC offset of the interface. That is ~5 octaves in one band, while a high bin covers a fraction of an octave. Music energy is concentrated at the low end.
2. The dB conversion is applied to the **squared** magnitude with a 20·log10 formula, which is effectively 40·log10|X|. Level differences between bins are doubled, and the nominal 72 dB range is really 36 dB of amplitude.
3. `AudioData` normalises all bins by a **single shared** running maximum, so a dominant bin 1 sets the normaliser and compresses every other bin.

The patch partially compensates with the "Preshape FFT Values" weighting (below), which attenuates the lowest bins.

## AudioData (per frame)

Approx. reading of `AudioData.Update`:

- Drop bin 0, append a 0 (still 64 values).
- Preshape: `w_i = lerp(1, 1 − (1 − i/63)², s)`; the IOBox shows `s = 0.6`, so the lowest bin is weighted `1 − s`.
- Multiply by Gain (2), divide by the shared Normalisation Max (decays each frame, floor 0.05).
- Per-bin peak detection: a per-bin Peak Detection Max decays ×0.998 per frame; `Peak = value > max`; `Peak Score = value − PeakDetectionMin`.
- Walking averages (short lerp 0.02, long 0.00125) of a low-weighted sum (weight `(1 − (i+0.5)/N)^8`) and an "averages crossed" trigger.

The "Audio Filter" macro feeds `Filter` on this node; it is unused in practice and dropped from the port.

## Mask Generators (`MaskGenerator`)

Preset index: 0 = Gradient, 1 = BackAndForth, 2 = RotatingLine, 3 = Noise. `GeneratorBackToFront` exists but is not wired in.

- **Gradient**: Stride `Gradient` with Gamma 1 → linear ramp along `v`; horizontal (along `u`) when Shader Param > 0.5.
- **BackAndForth**: rectangle 2 × 0.666 → `Blur 0.5` → translated in Y by a SineWave → rotated; orientation `lerp(−0.5, 0.5, Shader Param)`.
- **RotatingLine**: rectangle 2 × thickness → `Blur 0.5` → rotated by an LFO; thickness `lerp(0.5, 1.5, Shader Param)`.
- **Noise**: 3D simplex (`GeneratorNoise_TextureFX.sdsl`), scale 0.666, brightness −0.15, contrast 0.333, offset speed `lerp(−1, 1, Shader Param)`.

Animation speed is `2^(Shader Speed)`. On every audio peak, a random time offset (0–64) is applied. All masks render at 512×512 (per Miro).

**Preset transitions**: a `TimerFlop` with 2.5 s outputs a 0→1 progress (`Running = clamp(t / 2.5)`), which drives the Stride `Blend` mixer's fader. Blend's default operation is *Average*, which makes its three-way `Lerp3` a plain **linear crossfade** from the previous preset to the new one over 2.5 s.

## Audio → Mask (`AddAudioDataToIdleMask`)

A 64×1 "peaks map" texture is built on the CPU: R = peak, G = peak score, B = `pow(max(peak·score, dampened_i·damper), bpm)`, where `dampened` is the per-bin decayed value optionally sorted by magnitude.

The **Glitches** macro (M5) controls all of it:

| Derived value | Formula |
|---|---|
| damper | `min(1 − g⁴, 0.9999)` |
| sort amount | `(1 − g)⁴` |
| brightness power `bpm` | `2^(map g 0..1 → 1..−1)`, i.e. 2 → 0.5 |
| mix control ("Idle without audio") | `1 − (1 − clamp(3g))⁴` |

`MixIdleMaskWithPeaksMap` inherits Stride's `FilterBase`, whose `Control` input does `lerp(input, Filter(input), Control)`. The result is therefore `lerp(mask, peaksMap.b at u = 1 − mask.r, control)`. **At Glitches = 0 the lights show the raw mask with no audio reactivity; from Glitches ≈ 0.33 the audio mapping is fully applied.** Glitches is effectively the audio-reactivity amount.

`VerticalSymmetry` (when M10 > 0.5) returns `0.5·(f(u, v) + f(1 − u, v))`: a left↔right average, not a mirror.

The node also outputs a "Brightness Autogain", which only feeds the Wanderer (Beam Ball), so it becomes unused in the port.

## Phase (`UpdatePhase`)

A peak fires when the fraction of bins with `Peak` exceeds `pow(1 − 0.95·Strobo, 1.5)`, **and** the time since the last peak (TSLP) exceeds `map(Strobo 0..1 → 10..0.5 s)`. Alternatively, Manual Strobo > 0.5 fires a peak once phase ≥ 0.5. A peak resets TSLP.

With D = Strobo Decay and A = Idle Attack: `s = clamp(TSLP / D)`, `i = clamp((TSLP − D) / A)`, `phase = 0.5·(s + i)`. Phase is 0 at the peak, 0.5 when strobo has decayed, and 1 when idle is fully back.

## Fixture Colour (`LightFixture.Update` / `GetColors`)

Per pixel, with `p = phase`:

- **Strobo brightness** = MaxStrobo × (ReactToStrobo ? `map(p, 0..0.5 → 1..0)` : 0). The strobo colour is `StroboColor` at brightness `strobo³`.
- **Idle brightness** = MaxIdle × (ReactToStrobo ? `map(p, 0.5..1 → 0..1)` : `1 − map(p, 0..0.5 → 1..0)`). Non-strobo fixtures therefore go dark on a peak and recover over the strobo decay. This is intentional: it gives the strobo fixtures visual space (confirmed by Miro, 2026-10-05).
- **Idle mask remap**: `lerp(IdleMaskRangeMin, IdleMaskRangeMax, mask.r ^ (2^IdleMaskCurve))`. Min > Max inverts the response. The pinspots get `0.666 → 0, curve −3` only while the "Invert Discoball" macro is on (an `If` region in `CreateLightFixtures`); otherwise they use the default range. *(Corrected 2026-10-05: an earlier version of this page attributed this range to the LED bars.)*
- The idle colour is the group colour at `idleBrightness × remappedMask`.
- The output is the **idle colour if idle brightness > 0, otherwise the strobo colour** (exclusive, not additive).
- Master Dimmer multiplies the HSV value. **Gamma is applied to the HSV value only** (`V^gamma`), not per RGB channel.

Group A/B Max Strobo / Max Idle come from `Strobo Brightness × Strobo Bright. A/B` and `Idle Brightness × Idle Bright. A/B` (M1/M3 × M16–M19).

## Group Colours

The group colour is `FromHSV(Hue A/B macro, saturation 1)`, or comes from `GetAutoColors` when Auto Color Change is on. `GetAutoColors` has 9 hue presets (0, 0.042, 0.097, 0.306, 0.375, 0.639, 0.681, 0.722, 0.778). Each peak decrements a counter; at 0 it draws a new count 1–8 and **independent** random hues for A and B (seeds 666/667), so A and B can coincide. Swap Colors swaps the final A and B colours (confirmed by Miro, 2026-10-05).

The per-group `ColorsDecay` (Decay A/B = 0) and `ColorsGain` (Gain = 1) branches are switched off by their current constants.

## DMX Framing

Generic fixtures: header bytes + colours (RGB, or RGBW when `Output RGBW`) + footer bytes, written at `DMX First Channel` into the fixture's universe. PitchPlease v3 is assembled in `PitchPlsToDMXv3` as described in [[v3]] (Connection to vvvv). Universe 0 goes to the Enttec Pro, and universe 2 to the ArtNet sender. The main loop is capped at 40 FPS.

## Current Rig (as Patched in `CreateLightFixtures`)

Extracted 2026-10-05, best effort. Region-level wiring was not traced fully, so these values seed the PitchControl default rig and must be checked against the real setup.

| Fixtures | Type string | Group | Dimmer macro | Pixels | DMX | Notes |
|---|---|---|---|---|---|---|
| 4 × PitchPlease v3 | `PitchPls_v3` | A | Dimmer 01 | 24 RGB | 100, 200, 300, 400 | gamma 1, no strobo, vertical (rotation 0.75) at y = 0.5, width 0.6 |
| 4 × PitchPlease v2.2 strips | `P2` (one typo `P@`) | A | Dimmer 02 | 19 RGB | serial, not DMX | gamma 2.2 |
| 3 × LED bars | `LED_Bar` | A | Dimmer 05 | 8 | first 300, step 30 | react to strobo; x = 0.2/0.5/0.8, y = 0.85 |
| 2 × Cameo pinspots | `CameoPinspot` | B | Dimmer 03 | 1 RGBW | 6, 10 | real strobo: shutter ch 3, close message 6; Invert Discoball range |
| 1 × back panel | `BackPanel` | B | Dimmer 05 | 1 RGB | 30 | |
| 3 × front panels | `FrontPanel` | B | Dimmer 04 | 1 RGB | 14, 18, 22 | gamma 2; at (0.2/0.5/0.8, 0.9) |
| ChilloutZone | `ChilloutZone` | — | Dimmer 06 | 1 | 40 | created in `Application` |

The LED bars' first address (300) collides with a third v3 unit (300–380) if both are output to the same universe.

The [[fixtures]] page lists the Beam Ball at DMX 30, but in the current patch the `DMX Addresses = 30` IOBox feeds the back panel. Beam Ball is dropped from the port, so this was not investigated further.

## Macro Table

128 macro slots (`MacrosManager`). Control values are 0–1; "value in range" maps them to Min–Max, quantised to Steps. Input types: 0 fader, 1 toggle, 2 button, 3 momentary, 4 radio group, −1 unassigned.

| Index | Name | Range | Steps | Type |
|---|---|---|---|---|
| 0 | Strobo Decay | 0.1–3 s | 128 | fader |
| 1 | Strobo Brightness | 0–1 | 128 | fader |
| 2 | Idle Attack | 0.1–20 s | 128 | fader |
| 3 | Idle Brightness | 0–1 | 128 | fader |
| 4 / 6 | Hue A / Hue B | −0.5–0.5 | 128 | fader |
| 5 | Glitches | 0–1 | 128 | fader |
| 7 | Strobo | 0–0.95 | 128 | fader |
| 8–11 | Swap Colors, Auto Color Change, Vertical Symmetry, LED Mode ("Art-Net Color") | 0/1 | 2 | toggle |
| 12–15 | Preset A–D | 0/1 | 2 | radio |
| 16–19 | Strobo Bright. A, Idle Bright. A, Strobo Bright. B, Idle Bright. B | 0–1 | 128 | fader |
| 20 | Shader Speed | −2–2 (speed = 2^x) | 128 | fader |
| 21 | Shader Param | 0–1 | 128 | fader |
| 23 | Audio Filter | 0–1 | 128 | fader |
| 29 | Invert Discoball | 0/1 | 128 | toggle |
| 30, 31 | Fog Machine, Manual Strobo | 0/1 | 2 | momentary |
| 32–47 | Dimmer 01–16 (display names: D PitchPls! v3, PitchPls! v2, D Pinspots, D Panels DJ, D Panel Back, D Chillout Z, …, BB …) | 0–1 | 128 | fader |
| 64–79 | Scene 1–8 Save / Load | 0/1 | 2 | button |
| 80 | Current Scene Index | 0–7 | 8 | — |
| 92, 93 | General, Dimmers (tab selection) | 0/1 | 2 | radio |

The scene and `macros.ini` files store the 128 control values in this index order.

**LCXL3 MIDI** (`MidiMappingLCXL3`, best-effort reading): the patch's `Channel In = 12` is VL.IO.Midi's **0-based channel index**, i.e. MIDI channel **13** (confirmed with the PitchControl MIDI monitor, 2026-10-05; the earlier reading "channel 12" was wrong). The 16 general inputs are knob row 3 (CC 29–36) and the faders (CC 5–12). Button rows CC 37–44 and 45–52 handle scene selection, and the shift state is read from controller 13. The 16 general inputs most likely map to the first 16 widgets of the General tab, in display order:
- knobs: Strobo Decay, Idle Attack, Shader Speed, Shader Param, Hue A, (unassigned), Hue B, Audio Filter;
- faders: Glitches, Strobo, Strobo Brightness, Idle Brightness, Strobo/Idle Bright. A, Strobo/Idle Bright. B.

## Open Questions

- MIDI mapping (`MidiMappingLCXL3`) and the macro definitions (names, ranges, steps) in `GUI_Manager` are readable but not yet extracted.
- Peak detection details (Peak Detection Min update, Peak Score semantics) are approx.

## See Also

- [[vvvv-patch]] — UI, macros and file layout of the patch
- [[port-design]] — design of the cross-platform port built on this analysis
- [[v3]] — firmware DMX channel layout
