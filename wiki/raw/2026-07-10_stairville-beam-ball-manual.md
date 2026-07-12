---
date_created: 2026-07-10
date_modified: 2026-07-10
source: Stairville Beam Ball 100 Quad LED product manual (PDF), uploaded by Miro
file: wiki/raw/Stairville_Beam_Ball_100_Quad_LED_10x10w.pdf
---

# Stairville Beam Ball 100 Quad LED — Manual Ingest

*2026-07-10*

Ingested to resolve the open question "what does BB stand for" in the vvvv Dimmers tab.

## Key facts extracted

- **Product:** Stairville Beam Ball 100 Quad LED
- **Type:** RGBW moving head, 10× 10W LEDs
- **Pan:** 540°; **Tilt:** infinite (endless rotation modes at extremes of Ch2)
- **Beam angle:** 4°–11°; **Lux:** 5,500 at 2m
- **DMX modes:** 7, 11, 15, 49 channels
- **7-channel map:** Ch1=Pan, Ch2=Tilt, Ch3=Speed, Ch4=Master Dimmer, Ch5=Strobe, Ch6=Scenes, Ch7=Mic sensitivity
- **DMX connector:** XLR 3-pin in + out
- **Power:** 130W, 100–240V; **Weight:** 5kg; **IP20** (indoor)

## Resolution

BB = Stairville Beam Ball 100 Quad LED.

In vvvv, the four BB macros (M44–M47) output static DMX values to the fixture at address 30:
- BB Vert Pos (M44) → Tilt (Ch2)
- BB Horz Pos (M45) → Pan (Ch1)
- BB Vert Speed (M46) / BB Horz Speed (M47) → Movement speed (Ch3)

The "Dimmers" tab label is a misnomer: the 16 faders are generic static DMX outputs, not only brightness controls.

## Pages updated

- [[vvvv-patch]] — Dimmers tab description, fixture table [30], BB macro mapping, Open Questions closed
- [[fixtures]] — New page created with full Beam Ball specs and DMX map
- [[index]] — fixtures page added
