---
title: Support
description: Answers to common questions about PitchControl, and how to report a problem.
---

## PitchControl doesn't list my audio input, or shows no level

Open the **Inputs** page (<kbd>5</kbd>) and work through these checks:

- Click **Rescan devices**, then choose your interface under **Device** and click **Save**.
- Hover over the status in the **Audio input** header to read the error, if there is one.
- Check **Input channels**. They count from 1 and must exist on the device: a channel number higher than the device's number of inputs stops the input.
- Raise the **Gain** if the level bar barely moves.
- **On macOS,** PitchControl needs microphone access, even for an audio interface. Turn it on under **System Settings → Privacy & Security → Microphone**.
- **On Windows,** a device can appear once for each audio system (ASIO included). If one entry doesn't work, try another.

If the saved device isn't connected, PitchControl falls back to the system default and lists the saved device as **not found**.

## macOS says PitchControl can't be opened

PitchControl isn't signed by Apple, so macOS blocks it the first time. Open it once, then go to **System Settings → Privacy & Security**, scroll down and click **Open Anyway**. Since macOS 15, right-click → Open no longer gets around this.

## Windows shows a SmartScreen warning

PitchControl isn't signed by Microsoft, so SmartScreen warns you the first time you run it. Click **More info**, then **Run anyway**.

## My Enttec DMX USB Pro isn't detected

- Check the USB cable, then click **Rescan USB devices** on the **Outputs** page (<kbd>6</kbd>).
- Choose the Enttec under **Device**, switch **Enabled** on and click **Save**.
- Hover over the status in the panel header to read the error.
- If the Enttec doesn't appear in the list at all, your computer doesn't see it as a USB serial device. Check that the system recognises it and that its driver is installed.
- If it says **connected** but the lights stay dark, check that its **Universe** matches the universe of your fixtures on the Rig page.

## Art-Net doesn't reach my lights

- Make sure Art-Net is **Enabled** and you clicked **Save**.
- Check the target's **IP**. It must be your node's address or your network's broadcast address. The address a new target starts with, `127.255.255.255`, never leaves your computer.
- Put your computer on the same network as the node, with an IP address in the same range.
- Check the universes: **Universe** must match your fixtures' universe in the rig, and **Art-Net universe** must match the universe the node outputs.
- If your firewall asks about PitchControl, allow it.

The **sending** status only means PitchControl is sending; it can't tell whether the node receives anything.

## My fixtures flicker or show the wrong colours

- **Check the address.** The fixture's **Universe / address** on the Rig page must match the address set on the fixture.
- **Check the channel layout.** Compare the **Channel map** on the Fixtures page with the DMX mode the fixture is set to. A missing or extra channel shifts every colour.
- **Look for overlaps.** Save the rig: the Rig panel lists fixtures whose channels overlap.
- **Look for overrides.** If the header shows **N overrides**, the Control Desk is holding some channels at fixed values.
- **Check the values.** Switch on **show channel values** on the Outputs page to see exactly what each fixture sends.
- **Adjust the gamma.** If dim colours look too bright or washed out, try a gamma around 2.2 for LED fixtures without their own curve. PitchPlease units need 1.
- **Use one DMX source.** Make sure no other controller is sending to the same lights.

## The strobo fires too often, or never

The **Strobo** fader on the General page sets the sensitivity. Lower it for fewer flashes; all the way down, the music no longer triggers the strobo. **Strobo Decay** sets how long each flash lasts.

If the strobo never fires, check the **Audio** panel. The bands should move with the music, and **TRIG** should rise on the kicks. Fixtures only flash if **Reacts to strobo** is switched on for them on the Rig page.

## Where are my files and logs?

In the **PitchControl** folder in your **Documents** folder. To open it, go to **Settings → App → Open data folder**.

Your settings, rigs, fixture types, scenes and MIDI mappings are in `config`. The `logs` folder has one log file per start, named by date and time. See [Configuration files](docs/configuration).

## How do I back up my setup or move it to another computer?

To back up everything, copy the whole `Documents/PitchControl` folder.

To move a rig, copy its file from `config/rigs/` together with the fixture types it uses from `config/fixtures/types/`, with PitchControl closed on the other computer. Then check the **Inputs** and **Outputs** pages there, since devices differ between computers. [Configuration files](docs/configuration) has the details.

## Can I use a MIDI controller other than the Launch Control XL?

Yes. Any controller that sends MIDI control change (CC) messages works. Write a small mapping file that links its CC numbers to PitchControl's macros, then choose it on the **Inputs** page. [Audio and MIDI](docs/audio-and-midi) shows how.

The **MIDI monitor** on the Inputs page shows every message PitchControl receives, which helps you find the CC numbers.

If you plug a controller in while PitchControl is running and it doesn't connect, restart PitchControl.

## Does PitchControl need an internet connection?

No. PitchControl runs entirely on your computer, fonts included, so it works offline at any venue. You only need the internet to download it.

## Is PitchControl free?

Yes. PitchControl is free and open source under the [MIT licence](https://github.com/hlavamir/PitchPlease/blob/master/LICENSE). If you'd like to support its development, you can [buy the developer a coffee on Ko-fi](https://ko-fi.com/zeys_hlvmr).

## Does PitchControl run on an Intel Mac?

The download for macOS runs on Apple Silicon Macs (M1 and later) only. On an Intel Mac, you can run PitchControl from source: see the [GitHub repository](https://github.com/hlavamir/PitchPlease) for instructions.

## How do I report a bug?

Open an issue on [GitHub Issues](https://github.com/hlavamir/PitchPlease/issues) and include:

- **The log file** from the session where it happened, from the `logs` folder in your data folder (the newest file, unless you've restarted since).
- **The version,** from **Settings → About**.
- **Your system:** macOS or Windows, and its version.
- **The steps** that lead to the problem, what you expected, and what happened instead.

A screenshot often helps too.
