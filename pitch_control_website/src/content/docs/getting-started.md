---
title: Getting started
description: Install PitchControl, connect your audio and DMX interface, and run your first audio-reactive light show in a few minutes.
order: 1
---

PitchControl listens to the music and plays your lights. Kicks trigger the strobo, and between them moving patterns drift across your fixtures in two colour groups, sent over DMX or Art-Net.

## What you need

- **A computer:** a Mac with Apple Silicon (M1 or later), or a PC with 64-bit Windows.
- **An audio input** that hears the music: an audio interface fed from the mixer, or a microphone.
- **A DMX interface:** an Enttec DMX USB Pro, or an Art-Net node on your network.
- **Optional, a MIDI controller.** The Novation Launch Control XL mk3 works out of the box. Other controllers can be mapped (see [Audio and MIDI](audio-and-midi)).

PitchControl runs entirely offline, so you don't need an internet connection at the gig.

> **Note:** PitchControl is open source. To run it from source, for example on an Intel Mac, see the [GitHub repository](https://github.com/hlavamir/PitchPlease).

## Download and install

Download the latest version from the [Releases page](https://github.com/hlavamir/PitchPlease/releases/latest). There's nothing else to install.

The app isn't signed by Apple or Microsoft, so your system asks you to confirm it the first time you open it.

### macOS

1. Unpack the macOS zip. You get **PitchControl.app**; move it to your Applications folder if you like.
2. Open it. The first time, macOS refuses to open it.
3. Go to **System Settings → Privacy & Security**, scroll down and click **Open Anyway**, then confirm. (Right-click → Open no longer works for this since macOS 15.)
4. macOS asks once for access to the microphone. Click **Allow**, because PitchControl analyses the audio input to drive the lights.

> **Tip:** If you clicked "Don't Allow", turn PitchControl on under **System Settings → Privacy & Security → Microphone**.

### Windows

1. Unpack the Windows zip and open the **PitchControl** folder inside it.
2. Run **PitchControl.exe**.
3. If Microsoft Defender SmartScreen shows a warning, click **More info**, then **Run anyway**. You only need to do this once.

## Your data folder

On first start, PitchControl creates a **PitchControl** folder in your **Documents** folder. It holds the settings, fixture types, rigs, scenes and MIDI mappings, all as plain JSON files, plus a log file for each session.

Everything you change in the app is saved there. To open it, go to **Settings → App → Open data folder**. The [Configuration files](configuration) page explains what's inside.

## Your first show in five minutes

PitchControl opens in its own window on the **General** page. The indicators at the top right show what's connected: **audio**, **midi**, **enttec**, **art-net** and **v2**. A filled square means it's working, a hollow one means it's off, and a cross means there's an error. Hover over it to read the error.

### 1. Pick the audio input

1. Press <kbd>5</kbd> to open the **Inputs** page.
2. Under **Audio input**, choose your **Device**.
3. Enter the **Input channels** that carry the music, for example `1, 2`. Several channels are mixed together.
4. Click **Save**.

Play some music. The level bar next to **Gain** and the 32-band meter should move. If they don't, see [Audio and MIDI](audio-and-midi).

### 2. Set up the output

1. Press <kbd>6</kbd> to open the **Outputs** page.
2. **For an Enttec DMX USB Pro:** plug it in, click **Rescan USB devices**, choose it under **Device**, switch **Enabled** on and set **Universe** to `0`.
3. **For Art-Net:** switch **Enabled** on, click **Add target** and enter your node's IP address.
4. Click **Save**. The Enttec panel should now say **connected**.

[Outputs and the Control Desk](outputs) covers both in detail.

### 3. Load or adjust the rig

A rig is the list of lights at your event. PitchControl starts with an example rig called **Default**. Replace it with your own lights:

1. Press <kbd>4</kbd> to open the **Rig** page.
2. Click **New**, give the rig a name and click **Create**.
3. Click **Add** to add a fixture. Choose its **Type**: for a simple 3-channel RGB light, use **Generic 1xRGB Fixture**.
4. Set **Universe / address** to the DMX address set on the fixture (universe `0` unless you use several).
5. Choose **Group** A or B and a **Position** in the scene.
6. Repeat for your other lights (**Duplicate** saves typing), then click **Save**.

If your light model isn't in the **Type** list, create a fixture type for it first. [Fixtures and rigs](fixtures-and-rigs) shows you how.

### 4. Play

Press <kbd>1</kbd> to go back to **General** and play some music:

- The kicks trigger the strobo, and the **Scene** panel shows every light in the colour it's sending.
- Click a scene (**01**–**08**) to load a saved look.
- Try the four mask presets: **Gradient**, **Back & Forth**, **Rotating Line** and **Noise**.
- Raise **Strobo** for more flashes. Turn it all the way down to stop the music from triggering the strobo.
- Set the group colours with **Hue A** and **Hue B**.

[Playing a show](playing-a-show) explains every control on this page.

> **Tip:** You can do everything from the keyboard: <kbd>1</kbd>–<kbd>9</kbd> switch pages, <kbd>W</kbd> <kbd>A</kbd> <kbd>S</kbd> <kbd>D</kbd> move the selection, and <kbd>↑</kbd> <kbd>↓</kbd> change values. See [The interface](interface).
