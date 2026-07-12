---
date_created: 2026-07-10
date_modified: 2026-07-10
---

# Third-Party Fixtures

> DMX fixtures used alongside PitchPlease. Setup varies per event and equipment is often mixed with other people's gear. Only the pinspots are owned by Miro.

## Cameo Q Spot 15 RGBW (pinspots) — owned

**DMX addresses:** 6 and 10  
**vvvv fixture IDs:** [6] and [10] (orange dots in UV placement panel)  
**vvvv dimmer:** M34 "D Pinspots"

18W RGBW LED spot. Two units used as accent pinspots.

| Ch (4CH mode) | Parameter |
|---|---|
| 1 | Red |
| 2 | Green |
| 3 | Blue |
| 4 | White |

A 9CH mode is also available (adds dimmer, dimmer fine, strobe, colour macro, colour temperature), but 4CH is the most likely mode used for direct RGBW control from vvvv.

## Other fixtures — event-dependent

The setup varies per show and typically includes borrowed or friend-owned gear. Examples from past events:

- **Stairville Beam Ball 100 Quad LED** (DMX address 30, vvvv ID [30]) — RGBW moving head, 540° pan, infinite tilt. Controlled via MadMapper on a second laptop over ArtNet; vvvv receives the ArtNet stream and remaps colour (Art-Net Color button toggles between received hue and vvvv's own logic). BB macros M44–M47 are an older direct-DMX approach.
- **Stairville LED Panel** (model unknown, vvvv dimmer M35 "D Panel Center") — rectangular RGB grid, single colour per panel, treated as one RGB pixel.

No detailed documentation needed — fixture list changes per event.

## See Also

- [[vvvv-patch]] — Dimmers tab and fixture UV placement
