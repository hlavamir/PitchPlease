---
title: Configuration files
description: Where PitchControl keeps your setup, how the JSON files are organised, and how to edit, back up or move them.
order: 8
---

## The data folder

PitchControl keeps everything in a **PitchControl** folder inside your **Documents** folder:

- **macOS:** `~/Documents/PitchControl/`
- **Windows:** `Documents\PitchControl\` in your user folder

To open it, go to **Settings → App → Open data folder**.

On first start, PitchControl fills the folder with the default settings, rig, fixture types, MIDI mapping and scenes. On every start it puts back any default file that's missing, but it never overwrites a file that's there.

> **Tip:** To get a fresh copy of a default file, for example the Default rig, move your version out of the folder and restart PitchControl.

| Path | Contents |
|---|---|
| `config/settings.json` | Outputs, audio input, MIDI controller choice, fog machines, the Auto colour palette, appearance and engine options |
| `config/fixtures/types/*.json` | One file per fixture type. The file name is the type name |
| `config/rigs/*.json` | One file per rig. The file name is the rig name |
| `config/controllers/*.json` | MIDI controller mappings |
| `config/scenes/scene_1.json` … `scene_8.json` | The eight scenes |
| `config/state/macros.json` | Your current macro values, saved every few seconds and restored at start |
| `config/state/overrides.json` | The Control Desk overrides |
| `logs/` | One log file per start, named by date and time (`YYMMDD_hhmmss.log`) |

### Keep your data somewhere else

To use another folder, for example one that's synced or backed up, create a text file called `data_folder.txt` in `Documents/PitchControl/` that contains the path to that folder. The folder must contain a `config` folder; PitchControl then uses its `config` and `logs` folders.

You can also start PitchControl with `--data <folder>` (see [The interface](interface)).

## Editing JSON by hand

Most things can be set in the app. A few can only be changed in the files: the Auto colour palette, scene names, the audio analysis options and MIDI mappings.

**To edit a file:**

1. Quit PitchControl. It reads the files when it starts and writes them when you save in the app, so it could overwrite your changes.
2. Edit the file in a text editor.
3. Start PitchControl and check the newest log file for problems.

A file only needs the keys you want to change: anything missing gets its default value.

### Useful settings

| Key in `settings.json` | Default | Meaning |
|---|---|---|
| `auto_colors` | nine colours | The Auto colour palette (see below) |
| `audio.trigger_full_hz` | 100 | Bands up to this frequency count fully towards the strobo trigger |
| `audio.trigger_zero_hz` | 5000 | Bands from this frequency on don't count |
| `masks.transition_s` | 2.5 | Crossfade time between mask presets, in seconds |
| `midi_settle_s` | 0.4 | How long a hue or saturation knob must rest before its value applies, in seconds |

The **Auto colour palette** is a list of colours, each with `h` (hue), `s` (saturation) and `b` (brightness) from 0 to 1. The brightness sets the maximum idle brightness while that colour is active:

```json
"auto_colors": [
  { "h": 0.0, "s": 1.0, "b": 1.0 },
  { "h": 0.375, "s": 1.0, "b": 1.0 },
  { "h": 0.6388889, "s": 1.0, "b": 0.8 }
]
```

### Scene files

A scene file has a `name` and the `values` of its macros, each from 0 to 1. To rename a scene, change its `name`. Here's a shortened example; a saved scene lists every macro:

```json
{
  "name": "Peak time",
  "values": {
    "Strobo Decay": 0.77,
    "Strobo": 0.59,
    "Preset B": 1.0
  }
}
```

### Fixture profiles

The channel layout of a fixture type, its **profile**, is the ordered `channels` list:

```json
"channels": [
  { "name": "master", "value": 255 },
  { "name": "dimmer", "macro": "Dimmer 03" },
  { "name": "strobe", "shutter": { "open": 0, "strobo": 200 } },
  { "pixels": "RGB" }
]
```

| Entry | What it sends |
|---|---|
| `value` | A constant from 0 to 255. A rig can override it by its `name` |
| `macro` | The value of a macro, as 0–255 |
| `shutter` | `strobo` on a peak for fixtures with Real strobo on, `open` otherwise |
| `pixels` | The pixel colours: pixel count × `R`, `RGB` or `RGBW` |

Each entry has exactly one of `value`, `macro`, `shutter` or `pixels`.

In a rig file, a fixture overrides type values like this. `"enabled": false` keeps the value but uses the type's again, just like unticking the checkbox in the app:

```json
"gamma": { "enabled": true, "value": 2.0 },
"channel_values": {
  "master": { "enabled": true, "value": 200 }
}
```

## Typos and broken files

PitchControl never refuses to start because of a configuration problem. It reports problems in the log file for that session, in the `logs` folder:

- **An unknown key**, usually a typo, is ignored and reported, for example `unknown key 'gamme' ignored (typo?)`.
- **A file with invalid JSON** or invalid content, such as a value out of range, is skipped and reported with the reason.
- **A missing file** is replaced by default values.
- **A fixture with an unknown type**, for example because its type file was skipped, is left out of the rig.

Rig problems, such as overlapping fixtures, also appear in the Rig panel when you save.

## Notes in your files

Keys that start with an underscore are notes for you; PitchControl ignores them and doesn't report them:

```json
{
  "description": "RGB par, 5-channel mode",
  "_note": "Set the fixture to 5-channel mode on its menu."
}
```

## Back up and move setups

**To back up everything,** copy the whole `Documents/PitchControl` folder. To restore it, quit PitchControl and copy it back.

**To move a rig to another computer:**

1. Copy the rig file from `config/rigs/` and the type file of every fixture type it uses from `config/fixtures/types/`. Copy the scenes and controller mappings too if you want them.
2. On the other computer, quit PitchControl and put the files in the same folders.
3. Start PitchControl and load the rig on the Rig page.

`settings.json` holds choices that belong to one computer, such as the audio device and the Enttec's serial number. On a new computer, check the **Inputs** and **Outputs** pages before the show.

> **Tip:** If a rig uses a fixture type that's missing on the new computer, the Rig panel lists it as an unknown type when you save, and those fixtures are left out until you copy the type file.
