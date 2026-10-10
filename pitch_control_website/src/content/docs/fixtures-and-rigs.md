---
title: Fixtures and rigs
description: Describe each light model once as a fixture type, then build a rig with the lights of each event.
order: 4
---

## Types and rigs

PitchControl keeps two things apart:

- **A fixture type** describes one light model: its channel layout, number of pixels, output, gamma and strobo colour. You set it up once on the **Fixtures** page (<kbd>3</kbd>).
- **A rig** lists the lights at one event: which type each one is, its DMX address, group and place in the scene, and anything you want to change for that one light. You build it on the **Rig** page (<kbd>4</kbd>). To switch venues, switch rigs.

PitchControl comes with these fixture types:

| Type | What it is |
|---|---|
| **Generic 1xRGB Fixture** | Any light with three channels: red, green, blue |
| **Cameo Q-Spot 15** | An RGBW pinspot in its 4-channel mode |
| **PitchPls v3** | PitchPlease v3 LED poles over DMX: 24 RGB pixels plus control channels |
| **PitchPls v2** | PitchPlease v2 LED strips over USB serial |

## Fixture types

![Fixtures page](fixtures.png)

### Manage types

The **Fixture types** panel lists every type with its channel count (or **serial**). A dot marks a type with unsaved changes. Hover over a type to see which rigs use it.

- **New** creates a type with one RGB pixel on DMX.
- **Duplicate** copies the selected type under a new name.
- **Rename** renames the type and updates every rig that uses it.
- **Delete** removes the type. It's only possible when no rig uses it.

Type names can use letters, digits, spaces, `-`, `_` and `.`.

### The type editor

| Field | Meaning |
|---|---|
| **Description** | Your notes, for example the fixture's DMX mode |
| **Output** | **DMX** (sent by the Enttec or Art-Net) or **PitchPlease v2 serial** |
| **Pixels** | How many separately coloured pixels the light has: 1 for a par or pinspot, more for a bar or strip |
| **Gamma** | The device's brightness curve (see below) |
| **Strobo colour (HSB)** | The colour of the strobo flash: hue, saturation and brightness, each from 0 to 1 |
| **Used in** | The rigs that use this type |

Your edits apply to the lights straight away and mark the type unsaved. **Save** writes the type file; **Revert** goes back to the saved version.

**Gamma.** PitchControl works with perceptual brightness, where equal steps look equally bright. Gamma converts that for the device: the value sent is the value raised to the power of gamma.

- **1** sends the values unchanged. Use it for PitchPlease v2 and v3, which apply their own curve.
- **About 2.2** suits LED fixtures without their own curve. Fine-tune it by eye.

### Channel layout

The channel layout lists the fixture's DMX channels in order, starting at its address. Each row has a kind, an optional name and its settings:

| Kind | What it sends | Example |
|---|---|---|
| **constant** | A fixed value from 0 to 255 | A master channel at 255, or a mode channel |
| **macro** | A macro's value, scaled to 0–255 | A fixture's own dimmer channel following "Dimmer 01" |
| **shutter** | An **open** value normally, and a **strobe** value on each peak (for fixtures with **Real strobo** on) | A strobe/shutter channel |
| **pixels** | The colour of every pixel: **R**, **RGB** or **RGBW** per pixel, repeated for the pixel count | The colour channels |

- **RGBW** sends the white part of the colour on the W channel.
- **R** sends one brightness channel per pixel.
- **Named constants** can be changed per fixture in the rig, for example to set a different mode on one light.

Use **↑** and **↓** to move a channel, **✕** to remove it and **Add channel** to add a constant at the end.

A type with the **PitchPlease v2 serial** output has no channel layout: it sends three bytes (RGB) per pixel.

### Channel map

The **Channel map** shows the resulting channels, numbered from the fixture's first channel, with the total. It also tells you how many fixtures of this type fit in one universe of 512 channels.

## Rigs

![Rig page](rig.png)

### Rig files

The **Rig** panel manages the rig as a whole:

- **The dropdown** loads another rig.
- **The description** field holds your notes about the event.
- **Save** writes your changes to the rig file; **Revert** goes back to the saved version.
- **Rename** renames the rig.
- **Duplicate** works like "Save as": it saves the current state, unsaved changes included, as a new rig and switches to it. The original rig keeps what was last saved.
- **New** creates an empty rig.
- **Delete** removes the active rig and loads the next one. You can't delete the last rig.

Every change applies to the lights right away; only **Save** writes the file. The panel shows **unsaved** while there are changes, and loading or creating another rig asks whether to **Save**, **Discard** or **Cancel**.

After you save, the panel lists any problems, such as two fixtures using the same channels, channels beyond 512, or a fixture type that doesn't exist.

### The fixture list

The **Fixtures** panel lists the lights in the rig, each with its group and **universe:address** (or **serial**). Disabled fixtures are dimmed.

- **Add** adds a new fixture.
- **Duplicate** copies the selected fixture.
- **Remove** deletes the selected fixture.

### Edit several fixtures at once

<kbd>Shift</kbd> + click adds a fixture to the selection or removes it. A field shows a value only if all the selected fixtures share it; otherwise it says **multiple**. A value you enter applies to all of them.

While several fixtures are selected, **Name**, **Duplicate** and **Remove** are disabled, because fixture names must stay unique.

### Fixture settings

| Field | Meaning |
|---|---|
| **Name** | The fixture's name, unique within the rig |
| **Type** | Its fixture type, with a short summary. **edit type ›** opens the type on the Fixtures page |
| **Enabled** | Switched off, the fixture is left out and its channels send 0 |
| **Group** | A or B: which group colour and brightness it follows |
| **Universe / address** | The DMX universe (counted from 0) and the start address (1–512) set on the fixture |
| **Position (u, v)** | Where it sits in the scene (see below) |
| **Rotation (°)** | The direction its pixels run, clockwise: 90 points down, 270 runs vertically with the first pixel at the bottom |
| **Length** | How far its pixels spread along that direction |
| **Dimmer** | The dimmer fader it follows on the Dimmers page, or **none** |
| **Reacts to strobo** | Whether it flashes on strobo peaks |
| **Real strobo** | Uses the fixture's own shutter channel on peaks. Only shown for types with a shutter channel |

### Placement in the scene

The scene is a square. Positions run from 0 to 1: **u** from left to right, **v** from top to bottom. Each pixel takes its brightness from the mask at its position.

- **A single-pixel light** such as a par sits at its position.
- **A light with several pixels** such as a bar or strip is centred on its position. Its pixels spread over its **Length** in the direction set by **Rotation**.

> **Tip:** Place your lights in the scene the way they stand in the room. Then the patterns move across the room the way you see them in the preview.

The **Placement** panel highlights the selected fixtures in the scene preview, with their first pixel outlined. Below it, you see their live output colours. Switch on **show channel values** to see the DMX values they're sending.

### Colour sources

By default a fixture takes its hue and saturation from its own group, and its brightness from the strobo and idle phases. You can change that:

- **Hue source** and **Saturation source:** **own group**, **group A**, **group B** or **constant** (a fixed value from 0 to 1).
- **Brightness source:** **strobo / idle pipeline** (the normal behaviour) or **constant**. A constant brightness ignores the strobo and the mask; the fixture's dimmer still applies. The Default rig uses this for a chill-out area that glows steadily in the group A colour.

### Idle remap

The idle remap changes how a fixture reads the mask:

- **Idle remap min / max** map the mask's dark parts to **min** and its bright parts to **max**. If min is greater than max, the pattern is inverted.
- **Idle remap curve** bends the response: 0 is linear, negative values lift the darker parts, positive values push them down.
- **Remap only when** applies the remap **always**, or only while an on/off function such as **Invert Discoball** is switched on.

In the Default rig, the pinspots use an inverted, curved remap that only applies while **Invert disco** is on.

### Overriding type values

Some values come from the fixture type, but you can change them for one fixture: **Gamma**, **Strobo colour (HSB)** and every named constant channel.

- Tick the checkbox to override the value for this fixture.
- Untick it to use the type's value again. The field is greyed out but keeps your value, so ticking it again brings it back.
- **default** shows the type's value, and **↺** removes your override.

## Example: an RGB par

Say you have an RGB par in a 5-channel mode. Its manual lists: 1 dimmer, 2 red, 3 green, 4 blue, 5 strobe (0 = open). Check your own fixture's manual, since layouts vary between models and modes.

**Create the type:**

1. Press <kbd>3</kbd> for the Fixtures page, click **New**, enter `RGB Par 5ch` and click **Create**. The new type has one RGB pixel block.
2. Leave **Output** on **DMX** and **Pixels** on 1. Set **Gamma** to `2.2`.
3. Click **Add channel**, move the new channel to the top with **↑**, name it `dimmer` and set its value to `255`. PitchControl dims the colour itself, so the fixture's own dimmer stays fully open.
4. Click **Add channel** again for the strobe channel. Set its kind to **shutter**, name it `strobe`, and enter the **open** and **strobe** values from the manual.
5. Check the **Channel map**: 1 dimmer, 2–4 RGB pixels, 5 strobe, 5 channels in total. Click **Save**.

The saved type file looks like this:

```json
{
  "description": "RGB par, 5-channel mode",
  "transport": "dmx",
  "pixels": 1,
  "channels": [
    { "name": "dimmer", "value": 255 },
    { "pixels": "RGB" },
    { "name": "strobe", "shutter": { "open": 0, "strobo": 200 } }
  ],
  "gamma": 2.2,
  "strobo_color": { "h": 0, "s": 0, "b": 1 }
}
```

**Add the pars to the rig:**

1. Press <kbd>4</kbd> for the Rig page and click **Add**.
2. Choose **RGB Par 5ch** as the **Type** and enter its **Universe / address**, for example `0` and `1`.
3. Choose its **Group**, **Position** and **Dimmer**, and switch on **Reacts to strobo** if it should flash.
4. Click **Duplicate** for the next par and change its address to `6`.
5. Click **Save** in the Rig panel.
