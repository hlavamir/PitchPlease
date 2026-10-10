---
title: Playing a show
description: How PitchControl turns music into light, and how to play it live from the General and Dimmers pages.
order: 3
---

## How it works

PitchControl splits the music into 32 frequency bands and watches them for peaks. When enough bands peak at once, it triggers the strobo. Low frequencies count the most, so the kicks and the bass drive the show.

Each peak starts a cycle of two phases:

1. **Strobo.** Fixtures that react to the strobo flash in their strobo colour, and the flash fades out over the **Strobo Decay** time. Fixtures that don't react go dark on the peak and fade back in, leaving the flash to the strobo lights.
2. **Idle.** Then the idle look fades in over the **Idle Attack** time: the group colour, shaped by a moving pattern called the mask.

The two phases never overlap, so you see either the flash or the idle look, never both at once.

**Groups A and B.** Every fixture belongs to group A or B. Each group has its own colour and its own strobo and idle brightness, so you can play two colours against each other.

**The mask.** The mask is a greyscale pattern on a square scene. Each fixture has a place in that scene (you set it on the [Rig page](fixtures-and-rigs)), and every pixel takes its brightness from the pattern where it sits. The music shapes the pattern too.

## The General page

![General page](general.png)

Press <kbd>1</kbd> for the General page. It has five panels: **Macros**, **Functions · shader preset**, **Scenes**, **Scene** and **Audio**.

The macros, functions and scenes are arranged in rows of eight, matching the eight columns of the Launch Control XL.

## Macros

The 16 faders shape the look. Their order matches the Launch Control XL: knob row 3 on top, the faders below.

| Fader | What it does |
|---|---|
| **Strobo Decay** | How long the strobo flash takes to fade out after a peak (0.1–3 s) |
| **Idle Attack** | How long the idle look takes to fade back in after the flash (0.1–20 s) |
| **Shader Speed** | How fast the mask moves, from −2 to +2. Each step doubles the speed: 0 is normal, +2 four times as fast, −2 a quarter |
| **Shader Param** | Changes the shape of the current mask preset (see [Mask presets](#mask-presets)) |
| **Hue A** / **Sat. A** | The colour of group A: hue from −180° to +180°, saturation from 0 to 100 % |
| **Hue B** / **Sat. B** | The colour of group B |
| **Audio react.** | How strongly the music shapes the mask |
| **Strobo** | Strobo sensitivity. Higher values trigger on weaker peaks and allow flashes closer together. All the way down, the music no longer triggers the strobo |
| **Strobo br.** / **Idle br.** | Overall brightness of the strobo flash and of the idle look |
| **Strobo br. A** / **Idle br. A** | Strobo and idle brightness of group A, scaling the overall values |
| **Strobo br. B** / **Idle br. B** | The same for group B |

### Hue and saturation

Colour changes apply when you let go of the fader, or once the keys or the MIDI knob come to rest. That way the lights never sweep through the whole colour wheel in the middle of a show.

Until the change applies, the fader shows the target with a dashed outline and the lights keep the old colour. Press <kbd>Esc</kbd> to cancel it.

The strip beside a hue or saturation fader shows the colour scale, and the dot below shows the colour you'll get.

## Functions

| Button | Type | What it does |
|---|---|---|
| **Man. strobo** | Hold | Fires the strobo while you hold it, as soon as the previous flash has faded |
| **Fog** | Hold | Runs every fog machine set to manual trigger while you hold it (see [Fog](fog)) |
| **Invert disco** | On/off | A switch fixtures can use to change their idle look. In the Default rig, it inverts the pinspots' brightness pattern |
| **V. symmetry** | On/off | Mirrors the mask from left to right, so both halves of the scene match |
| **Auto color** | On/off | Picks the group colours automatically (see below) |
| **Swap colors** | On/off | Swaps the colours of groups A and B |

**Auto colour** draws the colours for groups A and B from a palette of nine colours. It picks a new pair every one to eight peaks at random, so the change happens on a flash. A and B are picked independently and can match. While it's on, the hue and saturation faders have no effect. You can change the palette in the settings file (see [Configuration files](configuration)).

## Mask presets

The second row of buttons selects one of four mask presets, **A** to **D**. Switching crossfades from the old pattern to the new one over 2.5 seconds. The **Scene** panel header shows the active preset.

On every peak, the animation restarts: lines jump back to their start and the noise jumps to a new spot. This locks the movement to the beat.

| Preset | Looks like | Shader Speed | Shader Param |
|---|---|---|---|
| **Gradient** | A soft gradient across the scene | No effect | Below the middle: top to bottom. Above the middle: left to right |
| **Back & Forth** | A soft band, a third of the scene wide, sliding back and forth | How fast it slides | The angle of the band, in 45° steps |
| **Rotating Line** | A soft line through the centre, turning | How fast it turns | The thickness of the line |
| **Noise** | A flowing, cloud-like pattern | How fast it changes | Its drift: one way below the middle, the other way above it, still in the middle |

**Audio react.** works on top of every preset: the higher it is, the more the frequency peaks change the brightness of the pattern.

## Scenes

A scene stores all your macros at once: the 16 faders, the function buttons, the mask preset and the 16 dimmers. There are eight scene slots.

- **To load a scene,** click it, or select it and press <kbd>⏎</kbd>. The last scene you loaded is underlined.
- **To save the current look,** select a slot and press <kbd>Shift</kbd> + <kbd>⏎</kbd>. Or click **Save mode** and then click a slot; save mode switches off after one save.

Empty slots are dimmed and labelled **empty**. A new scene is called "Scene 1", "Scene 2" and so on. To rename it, edit its file (see [Configuration files](configuration)).

> **Tip:** PitchControl saves your current macro values every few seconds and restores them when it starts. If the computer crashes, you're back where you left off.

## The scene preview

The **Scene** panel shows the square scene live:

- **The mask** in grey.
- **Every fixture pixel** as a small square in the colour it's sending. On a light with several pixels, the first pixel is outlined so you can see which way it runs.
- **The phase bar.** After a peak it's labelled **Strobo** and drains from 1 to 0 as the flash fades. Then it's labelled **Idle** and fills back up to 1 as the idle look fades in.
- **Group A · out** and **Group B · out:** the colours the two groups are sending right now, with their hue and saturation. These include auto colour and swap.

## The audio panel

The **Audio** panel shows the 32 frequency bands from 35 Hz to 10 kHz, with the bands that are peaking right now. The header shows **TRIG**, the weighted share of peaking bands that triggers the strobo, and the number of peaks since start.

The strip below is the **peaks map**, which **Audio react.** feeds into the mask.

To set up the input or understand the trigger, see [Audio and MIDI](audio-and-midi).

## Dimmers

![Dimmers page](dimmers.png)

Press <kbd>2</kbd> for the **Dimmers** page: 16 faders, one for each group of lights. Each fixture picks its dimmer on the Rig page, so you could have one dimmer for the pinspots and another for the panels behind the DJ.

- **Unused dimmers.** A dimmer that no fixture uses is hatched and labelled **no fixtures**. The keyboard skips it and MIDI ignores it.
- **To rename a dimmer,** double-click its name, type the new name and press <kbd>⏎</kbd> (<kbd>Esc</kbd> cancels). An empty name goes back to "Dimmer 01" and so on.
- **The names belong to the rig.** Save the rig on the Rig page to keep them; they travel with the rig file.

On the Launch Control XL, the page knob switches the faders between the General and Dimmers pages (see [Audio and MIDI](audio-and-midi)).
