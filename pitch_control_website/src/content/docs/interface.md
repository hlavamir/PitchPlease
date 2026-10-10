---
title: The interface
description: Find your way around the nine pages, control everything from the keyboard and adjust the look for a dark booth.
order: 2
---

PitchControl is built for a dark DJ booth. The interface uses a single ink colour on a near-black background. Colour only appears where it tells you something: on the hue and saturation scales, the group colour swatches and the fixtures in the scene preview.

## The header

The **top row** shows:

- the frame rate (**FPS**), or **ENGINE OFFLINE** if the interface has lost contact with the engine;
- an **N overrides** badge when channels on the Control Desk are overridden. Click it to open the Control Desk;
- the status of **audio**, **midi**, **enttec**, **art-net** and **v2**. A filled square means working, a hollow one means off, and a cross means an error. Hover over it to read the error.

The **second row** holds the page tabs, numbered 1–9, and the **Full screen** button in the desktop app.

The **footer** shows the key hints and the selected control with its current value.

## The nine pages

| Key | Page | What you do there |
|---|---|---|
| <kbd>1</kbd> | General | Play the show: macros, functions, mask presets, scenes, scene preview and audio |
| <kbd>2</kbd> | Dimmers | 16 dimmer faders, one per group of lights |
| <kbd>3</kbd> | Fixtures | Fixture types: the channel layout of each light model |
| <kbd>4</kbd> | Rig | The lights of your event: addresses, groups, placement |
| <kbd>5</kbd> | Inputs | Audio input and MIDI controller |
| <kbd>6</kbd> | Outputs | Enttec DMX USB Pro, Art-Net, PitchPlease v2 serial and the live output |
| <kbd>7</kbd> | Fog | Fog machines and their timers |
| <kbd>8</kbd> | Settings | Appearance, keyboard reference, app options and version |
| <kbd>9</kbd> | Control Desk | Every DMX channel as a slider, for manual overrides |

## Keyboard control

You never need a mouse. On the **General**, **Dimmers**, **Settings** and **Control Desk** pages, one control is always selected, like on a hardware device. Each page remembers its selection when you switch away.

| Key | Action |
|---|---|
| <kbd>W</kbd> / <kbd>S</kbd> | Move the selection up / down a row |
| <kbd>A</kbd> / <kbd>D</kbd> | Move the selection left / right |
| <kbd>↑</kbd> / <kbd>↓</kbd> | Change the selected value |
| <kbd>Shift</kbd> | Fine steps while changing a value |
| <kbd>⏎</kbd> | Press the selected button, or load the selected scene |
| <kbd>Shift</kbd> + <kbd>⏎</kbd> | Save the selected scene |
| <kbd>Esc</kbd> | Cancel a pending hue / saturation change |
| <kbd>1</kbd> – <kbd>9</kbd> | Switch page |
| <kbd>Q</kbd> / <kbd>E</kbd> | Previous / next subpage (Control Desk) |
| <kbd>F</kbd> | Full screen on / off (desktop app) |

Hold buttons such as **Man. strobo** and **Fog** stay on while you hold <kbd>⏎</kbd>.

> **Note:** While you're typing in a text or number field, the keys go to the field. Typing a number won't switch pages.

### Faders

- Drag up or down anywhere on a fader. It moves from its current value, so it never jumps when you click.
- Hold <kbd>Shift</kbd> while dragging for fine control.
- Double-click a fader to reset it to its default.

### Number fields

- Type a value and press <kbd>⏎</kbd>. The field keeps the focus, so you can type the next value straight away. Leaving the field also applies the value; <kbd>Esc</kbd> reverts it.
- Press <kbd>↑</kbd> / <kbd>↓</kbd>, or drag up and down with the right mouse button, to step the value. Hold <kbd>Shift</kbd> for fine steps.
- Whole numbers step by 1, decimals by 0.1 (0.01 with Shift), and fixture rotation by 15° (1° with Shift).

## Appearance

![Settings page](settings.png)

Change the look under **Settings → Appearance**. Your choices are saved and restored next time.

- **Ink colour:** Grey, Amber or Phosphor.
- **Glow:** how much selected and active elements bloom.
- **UI brightness:** dims the ink from 100 % down to 40 %, so the screen throws less light on you in a dark booth.
- **UI scale:** zooms the whole interface from 60 % to 150 % with **−** and **+**. **100 %** goes back to normal size.
- **Fit window:** picks the largest scale at which every page fits without scrolling.
- **Key hints:** shows or hides the keyboard legend at the bottom.

The layout is made for a 1512 × 915 window, the size of a 14" MacBook at its default display setting. On smaller screens, down to 1280 × 720, click **Fit window** (about 70 % on a 1280 × 720 screen). Above 100 %, some pages scroll.

## Full screen

In the desktop app, press <kbd>F</kbd> or click **Full screen** at the right of the page tabs. Full screen hides the menu bar and the Dock, and on a MacBook it also uses the strip beside the camera notch.

To always start in full screen, switch on **Settings → App → Start in full screen**.

## App window or browser

The desktop app shows PitchControl in its own window. Closing the window quits PitchControl, and the lights stop.

The lights don't depend on the interface, though. The engine runs on its own, so reloading or closing a browser tab never interrupts the show.

**Settings → App** (desktop app only) has:

- **Open in browser:** opens the same interface in your web browser, for example on a second screen.
- **Open data folder:** opens the folder with your settings, rigs and logs.
- **Start in full screen:** see above.

**Settings → About** shows the version you're running, with links to the project and its releases.

## Control from a phone or tablet

By default, only the computer running PitchControl can open the interface. To reach it from a phone or tablet on the same network, start PitchControl with the `--host 0.0.0.0` option:

- **macOS** (in Terminal): `open /Applications/PitchControl.app --args --host 0.0.0.0`
- **Windows** (in a terminal, inside the PitchControl folder): `.\PitchControl.exe --host 0.0.0.0`

Then open `http://<your computer's IP address>:8420` in the phone's browser. If port 8420 is busy, PitchControl takes the next free one. Click **Open in browser** to see the port it's using in the address bar.

If your system asks whether PitchControl may accept incoming network connections, allow it.

> **Note:** There's no login. Anyone on the network who knows the address can control your lights, so only do this on a network you trust.

### Start options

| Option | What it does |
|---|---|
| `--host 0.0.0.0` | Lets other devices on your network open the interface |
| `--port <number>` | Uses another port than 8420 |
| `--no-window` | Opens the interface in your browser instead of a window |
| `--no-hardware` | Runs without audio, MIDI and outputs, for example to prepare a rig away from the venue |
| `--data <folder>` | Uses another data folder (see [Configuration files](configuration)) |
