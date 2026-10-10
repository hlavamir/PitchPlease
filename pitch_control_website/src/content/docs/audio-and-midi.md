---
title: Audio and MIDI
description: Feed PitchControl the music, understand the strobo trigger, and play the show from a MIDI controller.
order: 5
---

![Inputs page](inputs.png)

## Audio input

PitchControl needs to hear the music. Any input works: a line feed from the mixer into an audio interface, or a microphone.

**To set up the audio input:**

1. Press <kbd>5</kbd> for the **Inputs** page.
2. Choose the **Device**. Each device is listed with its number of inputs. **System default** uses your computer's default input. On Windows, a device can appear once for each audio system, ASIO included.
3. Enter the **Input channels**, separated by commas and counted from 1: `1, 2` for the first two inputs, `3` for the third alone. The channels you list are mixed together.
4. Set the **Gain** if needed. The bar next to it shows the input level.
5. Click **Save**. The panel header shows **running** once the input works.

Plugged in a device after starting PitchControl? Click **Rescan devices** to update the list.

If the saved device isn't connected, PitchControl uses the system default instead, and the list shows the saved device as **not found**.

## Band meter and trigger

The meter shows the 32 frequency bands, from 35 Hz to 10 kHz. Each band adapts to its own level, so quiet hi-hats and loud bass both register. Bands that are peaking right now are highlighted.

The **dotted line** shows how strongly each band counts towards the strobo trigger:

| Frequency | Weight |
|---|---|
| Up to 100 Hz | 100 % |
| 300 Hz | about 59 % |
| 1 kHz | about 41 % |
| 5 kHz and above | 0 % |

The trigger value (**TRIG** on the General page) is the weighted share of the bands that are peaking. When it gets high enough, the strobo fires; the **Strobo** fader sets how high is high enough. This is why the kicks and the bass drive the strobo, while hi-hats barely touch it.

> **Tip:** You can shift the weighting in the settings file with `trigger_full_hz` (100 % up to this frequency) and `trigger_zero_hz` (0 % from this frequency). See [Configuration files](configuration).

## MIDI controller

**To connect a controller:**

1. Plug it in. On the **Inputs** page, under **MIDI controller**, choose the **Controller mapping**.
2. Leave **MIDI port** on **from controller file**: PitchControl then finds the controller by the port name stored in the mapping. If it doesn't, pick the port yourself.
3. Click **Save**. The panel header shows the port name once it's connected.

## Launch Control XL mk3

The Novation Launch Control XL mk3 is mapped out of the box. The mapping expects it on MIDI channel 13.

The same knobs and faders control whichever page is active, **General** or **Dimmers**. Their order matches the screen.

| Control | On the General page | On the Dimmers page |
|---|---|---|
| Knob row 3 | Strobo Decay, Idle Attack, Shader Speed, Shader Param, Hue A, Sat. A, Hue B, Sat. B | Dimmers 1–8 |
| Faders | Audio react., Strobo, Strobo br., Idle br., Strobo br. A, Idle br. A, Strobo br. B, Idle br. B | Dimmers 9–16 |
| First knob of row 1 | Page knob: turn it up for Dimmers, down for General | |

The controller and the screen stay in step. Opening the General or Dimmers page switches the controller to that page, and turning the page knob switches the screen between the two pages.

Good to know:

- **Knobs and faders are absolute.** A value jumps to the control's position as soon as you move it.
- **Hue and saturation knobs** apply once the knob has rested for 0.4 seconds, so the lights don't sweep through the colour wheel.
- **Dimmers that no fixture uses** ignore the controller.
- **The buttons aren't mapped.** Use the screen or the keyboard for the functions, mask presets and scenes, or map them yourself (see [Custom mappings](#custom-mappings)).

## MIDI monitor

The **MIDI monitor** on the Inputs page lists the last messages received, newest first, with a count and the channel the mapping listens on. Each line tells you which macro the message moved, or why it was ignored:

- **not a CC message:** PitchControl only uses control change (CC) messages.
- **channel …, mapping expects …:** the controller sends on another MIDI channel than the mapping expects.
- **CC … not mapped on page …:** nothing is mapped to that control on the active page.
- **… is unassigned (no fixture uses it), ignored:** a dimmer that no fixture uses.
- **page knob:** the message switched pages.

If the monitor stays empty when you move a control, PitchControl isn't receiving anything: check the cable and the **MIDI port**.

## Custom mappings

A mapping is a JSON file in the `controllers` folder of your data folder (see [Configuration files](configuration)). Each mapping links a CC number to a macro. To use another controller, create a file for it, for example `my-controller.json`:

```json
{
  "name": "My controller",
  "port_match": "My Controller",
  "channel": 1,
  "mappings": [
    { "cc": 40, "macro": "Manual Strobo", "mode": "momentary" },
    { "cc": 41, "macro": "Auto Color Change", "mode": "toggle" },
    { "cc": 42, "macro": "Scene 1 Load" }
  ],
  "pages": {
    "general": [
      { "cc": 1, "macro": "Strobo Decay" },
      { "cc": 2, "macro": "Idle Attack" }
    ],
    "dimmers": [
      { "cc": 1, "macro": "Dimmer 01" },
      { "cc": 2, "macro": "Dimmer 02" }
    ]
  },
  "page_knob": 20
}
```

| Key | Meaning |
|---|---|
| `name` | A name for the controller |
| `port_match` | Part of the controller's MIDI port name, used to find it |
| `channel` | The MIDI channel it sends on (1–16) |
| `mappings` | Mappings that work on every page |
| `pages` | Mappings for the `general` and `dimmers` pages. On its page, a page mapping wins over a mapping for every page |
| `page_knob` | Optional: the CC of a knob that switches pages (up = next page, down = previous) |

Each mapping has a `cc` (0–127), a `macro` and a `mode`:

- `absolute` (the default): the control's position sets the value. Use it for knobs and faders.
- `toggle`: each press switches the macro on or off.
- `momentary`: the macro is on while you hold the button.

**Macro names** you can map:

- **Faders:** Strobo Decay, Idle Attack, Shader Speed, Shader Param, Hue A, Saturation A, Hue B, Saturation B, Audio Reactivity, Strobo, Strobo Brightness, Idle Brightness, Strobo Bright. A, Idle Bright. A, Strobo Bright. B, Idle Bright. B
- **Hold buttons:** Manual Strobo, Fog Machine
- **On/off functions:** Invert Discoball, Vertical Symmetry, Auto Color Change, Swap Colors
- **Mask presets:** Preset A, Preset B, Preset C, Preset D
- **Dimmers:** Dimmer 01 to Dimmer 16
- **Scenes:** Scene 1 Load to Scene 8 Load, Scene 1 Save to Scene 8 Save

Save the file, then choose it under **Controller mapping** on the Inputs page (click **Rescan devices** if it isn't listed yet) and click **Save**. If you edit a mapping that's already in use, restart PitchControl to load your changes.

A mapping to a macro name that doesn't exist is reported in the log (see [Configuration files](configuration)).
