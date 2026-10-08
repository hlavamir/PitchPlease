---
date_created: 2026-09-26
date_modified: 2026-09-27
---

# v3 Assembly — Devices 3 and 4

> Build notes for the next two v3 devices (units 3 and 4): the v3.2 case's step-by-step assembly procedure, the internal cable set per device, corrections found while assembling, and lessons learned for future revisions.

## Status

Units 3 and 4 are being built alongside the two existing, field-tested [[v3]] devices (DMX start addresses 100 and 200). Their own DMX start addresses haven't been decided. On 2026-09-25 Miro cut and prepared the internal cables for both devices — one identical set per device. Those were first-pass lengths, cut before test-fitting; corrections found while assembling are recorded under Corrections and build notes below and reflected in the table. Miro will report any further corrections if a cable turns out too long or too short, so treat the table as provisional.

On 2026-09-26 Miro assembled most of both units. As of 2026-09-27: both units 3 and 4 are still missing their body, end cap, and front cap (the last is what the XLR connectors normally mount to) — so the printed enclosure isn't closed up on either device yet. **Power delivery and LED communication have been tested and are working well on both units.** The XLR/DMX signal path hasn't been tested yet, but isn't blocked on the front cap — the XLR connectors can be wired straight to the PCB without it, the front cap is only the mechanical mount. Miro may test this way today; the tradeoff is having to unplug the connectors again afterward to route their cables through the front cap before final assembly. Full procedure below.

## Assembly procedure (v3.2 case)

Parts referenced are all in `v3_esp32_dmx/case/3d print v3-2/`. This is a new case iteration (see [[v3]] Case iterations) — same spine-rod concept as v3.1, but with two middle blocks instead of one.

1. Cut the "spine" screw rod to 134 cm.
2. Thread the two `middle block.3mf` pieces onto the rod like nuts. Each block is 24 mm long and needs to end up centred 47 cm in from its end of the rod: measure 47 cm from the end, mark 12 mm to each side of that point, then screw the block on until it sits between the two marks. First attempt used pliers to turn the block by hand; found it easier to chuck the rod in a drill and spin the rod while holding the block still by hand.
3. Slide the 1 m extruded white plastic square profile onto the rod. Slide `inner spacer end white.3mf` on from one end of the rod, `inner spacer start white.3mf` from the other.
4. Add a washer and nut to both ends of the rod. Temporarily fit the Plexiglas tube over the assembly and adjust the "start" nut until `inner spacer start` aligns with the tube's length, then remove the tube again.
5. Glue the 4 LED strips onto the square profile ("spine"), one per side. The inner spacers each have two printed line markings at both ends; alternate which strips start on which line (two strips start on one line, two on the other). Feed each strip's cable through the corresponding hole in the inner spacer.
6. Wrap 4 rings of transparent tape around the LED strips to secure them further, and a zip tie over the strips' cables.
7. Remove the nut and washer from the start end. Slide `internal frame.3mf` onto the rod, routing cables through its holes, and attach it with 4× M3 16 mm screws.
8. Attach the XLR connectors to `front cap black.3mf` with 4× M3 16 mm screws.
9. Connect the PCB to the power module, LED strips, and XLR connectors, then gently slide the PCB and power module into the internal frame.
10. Slide `body black.3mf` on from the front and `end cap black.3mf` from the back. With everything in place, carefully drill 3 mm holes through the Plexiglas tube where needed, then join with M3 16 mm screws: body–Plexiglas–inner spacer start, and end cap–Plexiglas–inner spacer end. Connect body to front cap through the 4 holes already present in both parts.
11. Flash firmware (via [firmware-flasher.command](../../v3_esp32_dmx/firmware/v3-2_esp32_dmx_platformio/firmware-flasher.command), built for exactly this) and label the device with its DMX address.

## Cable set (per device)

Lengths as currently recorded; changes from the original cut are marked and explained under Corrections and build notes.

| Cable | Cut length | Quantity | Conductors |
|---|---|---|---|
| PCB → external power module, 12 V pair | 90 mm (was 45 mm) | 2 wires | 1× red (positive), 1× white (GND) |
| Other pair to/from the power module (presumably the 5 V return) | 45 mm (no change reported) | 2 wires | 1× red (positive), 1× white (GND) |
| Power connector → PCB | 90 mm | 2 wires | 1× red (positive), 1× white (GND) |
| DMX connectors → PCB | 70 mm | 2 cables | 3 wires each: GND, A, B |
| LED lead, female end (strip side) | 110 mm | 4 cables | 3 wires each: positive, data, GND |
| LED lead, male end (PCB side) | 60 mm | 4 cables | 3 wires each: positive, data, GND |

That is 36 individual wire pieces per device (2 + 2 + 2 + 6 + 12 + 12), 72 for the pair.

Each LED strip is reached through two cables that meet at an in-line connector in the middle — male lead on the PCB side, female lead on the strip side — so the PCB and the strips can be unplugged from each other during assembly. The combined cut length per strip is 170 mm (60 + 110) before stripping, crimping and connector allowance, so the installed run will be somewhat shorter.

## Where each cable goes (inferred, unconfirmed)

Only the lengths, counts and wire roles were stated when the cables were cut. The destinations here are inferred from the v3.2 board layout, except where noted. The two red/white pairs to the external power module most likely link the PCB's two small bottom-edge screw terminals: "+12V-" out to the module that replaced the onboard step-down, and "+5V-" back from it. Miro has since confirmed that a 12 V pair runs from the PCB to the power module; the 5 V pairing is still inferred. The red/white pair from the power connector most likely runs to the large "+ 12V -" main input terminal. The two DMX cables most likely serve the DMXIN and DMXOUT headers.

## Corrections and build notes

Reported 2026-09-26, while assembling:

- **12 V pair to the power module: 45 mm → 90 mm.** The pair of 12 V power cables from the PCB to the external power module, originally cut at 45 mm, had to be extended to 90 mm. Nothing was reported for the other pair, so its 45 mm cut length is assumed to stand. 90 mm is the better starting length for the 12 V pair in future builds.
- **Tape over the MAX485 modules.** Miro put a piece of tape over the MAX485 modules as a precaution: they might accidentally touch two metal components on the external power module and short-circuit the device. Considered unlikely, but cheap insurance.
- **"Spine" screw rod: 134 cm.** The structural screw rod running through the hollow square profile (the "spine"; see the v3.2 case iteration in [[v3]]) needs to be 134 cm long.

## Lessons learned (for future case/cable revisions)

Recorded 2026-09-27, after assembling most of both units:

- All the LED cables (both male and female leads) could be 1 cm longer.
- All the internal frame's holes are slightly too tight, especially the middle hole for the screw rod.
- The holes running through the inner spacers could also be slightly wider.
- The inner spacers have too much tolerance (~1 mm each side) where they connect to the middle plastic profile.
- ~~Need a way to keep the nuts from unscrewing over time (e.g. thread lock, nylon-insert lock nuts, or a dab of glue).~~ Addressed: see "nut retainer" part below.
- Move the two middle blocks closer together: 30 cm apart instead of the current 40 cm (still centred symmetrically on the rod).

**Nut retainer (new part, 2026-09-27):** `nut retainer end.3mf`, in the same `3d print v3-2/` folder as the other case parts. Fits under the end cap and mechanically stops the rod's nut on that side from working loose — a nut keeper: it captures the nut's shape so it can't rotate, rather than gripping the threads. This is the nut at the "end" side of the rod, the one that stays permanently tensioned in the finished assembly (the "start" side is fixed via M3 screws in the final assembly, not a permanent nut — see step 10). Not yet used in an actual build; goes in during step 10, between the end cap and the nut, whenever that step is next performed.

## Open Questions

- Wire colors for the three-conductor LED and DMX cables, and the connector types (mid-cable LED connector, power connector), weren't recorded — only the power cables' red/white coding was.
- DMX header labeling: the DMXIN/DMXOUT silkscreen reads GND / A / B from left to right (square pad = GND), but in the v3.2 sketch's netlist (`v3_esp32_dmx/pcb/260823_v3-2-1_esp32_dmx.fzz`) the middle pad goes to the MAX485's B pin and the right pad to its A pin, so the silkscreen letters are swapped relative to the chip's own A/B names. Do the new DMX cables follow XLR pin numbers or the silkscreen letters? Units 1 and 2 work, so whatever they use is the known-good reference.
- Which units do the corrections apply to? The 90 mm extension and the MAX485 tape were reported without saying whether they apply to both units 3 and 4, or whether units 1 and 2 (built earlier) should get the tape too.
- Further cable length corrections — the 12 V pair is in; anything else that turns out too long or too short after test-fitting is still to come.
- Whether the XLR/DMX signal path works end-to-end on units 3/4 — not yet tested. Can be tested by wiring the XLR connectors straight to the PCB without the front cap; not blocked on final assembly.

## Units 1 and 2

No further changes are planned for units 1 and 2, with one possible exception: unit 2's body piece may need reprinting. The body has a modeling mistake — it's missing the screw hole that joins the body to the inner spacer start through the Plexiglas tube, on the bottom side (the same body–Plexiglas–inner-spacer-start screw point described in the v3.2 assembly procedure above; whether units 1/2 use the same body design as v3.2 or an earlier one is unconfirmed). The fix has already been made in the model, and unit 1 has already been reprinted with the corrected body. Unit 2's body has not been reprinted yet.

## See Also

- [[v3]] — v3 devices overview
- [[hardware]] — cross-version hardware summary
