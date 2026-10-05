---
date_created: 2026-09-06
date_modified: 2026-09-26
source: StepperOnline 17HE08-1004S label + dimensional/electrical datasheet (PDF), uploaded by Miro
file: raw/290906 Stepper Motor.pdf
---

# StepperOnline 17HE08-1004S — Datasheet Ingest

*2026-09-06*

Ingested to confirm the exact specs and pinout of the NEMA17 pancake stepper motor purchased for the [[discoball]] rotation drive (Amazon listing B0B93PNYCP, discussed and provisionally specced in that same chat before ordering).

## Key facts extracted

- **Model:** 17HE08-1004S, manufacturer OMC Corporation Limited (StepperOnline brand)
- **Frame:** NEMA17, 42.3mm max face, 4×M3 mounting holes on 31±0.2mm bolt pattern, 3.0mm min thread depth
- **Body length:** 23mm max (pancake) — matches the "buy the shortest body" recommendation given earlier, since holding torque this size is already ~15–20× the actual load
- **Shaft:** 5mm diameter (Ø5⁰₋₀.₀₁₂), 17±0.25mm exposed length, with a flat (4.5±0.1mm) for set-screw grip — confirms 5mm-bore pinion is correct
- **Connection:** Bipolar, 4 leads, 1m PH-6/UL1007 AWG26 pigtail terminated in a 4-pin M20-1060400 connector
- **Current:** 1.00 A/phase
- **Coil resistance:** 3.60Ω ±10% @ 25°C
- **Coil inductance:** 4.00mH ±20% @ 1kHz
- **Holding torque:** 0.17 Nm (17 Ncm / 1.42 lb·in)
- **Step angle:** 1.8° (200 full steps/rev), step accuracy ±5%
- **Rotor inertia:** 22 g·cm²
- **Weight:** 0.14 kg
- **Ambient temp range:** −10°C to 50°C; insulation class B (130°C); max temp rise 80°C

## Pinout (confirmed from datasheet table, not just the connector silkscreen)

| Pin | Winding | Lead colour |
|---|---|---|
| 1 | A+ | Black |
| 3 | A− | Blue |
| 2 | B+ | Green |
| 4 | B− | Red |

Full-step sequence table (CW/CCW) is also on the datasheet (page 3) if needed for a non-microstepping fallback driver — not needed for the TMC2209 plan, which handles commutation internally from STEP/DIR.

## Pages updated

- [[discoball]] — new page created covering the full project; this datasheet is cited as the motor spec source
- [[index]] — new "Side Projects" section added
