---
title: Outputs and the Control Desk
description: Send your lights over an Enttec DMX USB Pro, Art-Net or PitchPlease serial, watch what goes out, and take manual control of any DMX channel.
order: 6
---

Every fixture in your rig writes its channels into a DMX universe, numbered from 0. The outputs send those universes to your hardware.

![Outputs page](outputs.png)

You set up the outputs on the **Outputs** page (<kbd>6</kbd>). Changes take effect when you click **Save**; **Revert** discards them. After plugging in a USB device, click **Rescan USB devices** to update the device lists.

## Enttec DMX USB Pro

**To send DMX through an Enttec DMX USB Pro:**

1. Plug it in and click **Rescan USB devices**.
2. Choose it under **Device**. USB devices are listed by name, serial number and port.
3. Switch **Enabled** on.
4. Set **Universe** to the universe your fixtures are in. An Enttec sends one universe.
5. Click **Save**. The panel header shows **connected**.

PitchControl remembers the Enttec by its serial number, so it finds it again even if you plug it into another USB port. If the cable comes loose, PitchControl keeps trying and carries on as soon as the Enttec is back.

## Art-Net

**To send DMX over Art-Net:**

1. Switch **Enabled** on.
2. Click **Add target** and fill in:
   - **Universe:** the PitchControl universe to send.
   - **IP:** the IP address of your Art-Net node, or the broadcast address of your network.
   - **Art-Net universe:** the universe number on the network. It starts out the same as the PitchControl universe.
3. Add a target for each universe or node you need. **✕** removes a target.
4. Click **Save**.

> **Note:** A new target starts with the address `127.255.255.255`, which never leaves your computer. Replace it with your node's address.

PitchControl sends Art-Net on the standard port 6454. The status shows **sending** as soon as Art-Net is enabled. It can't tell whether a node actually receives the data, so if your lights stay dark, see [Support](../support).

## PitchPlease v2 serial

This output is for PitchPlease v2 LED strips connected over USB. Fixtures whose type uses the **PitchPlease v2 serial** output are sent here instead of over DMX.

1. Choose the **Device**.
2. Set the **Baudrate**. The default is 921600.
3. Leave the **Mirror mode byte** at 0 unless your units need another mirror mode.
4. Switch **Enabled** on and click **Save**.

## Live output

The **Live output** panel shows what every enabled fixture is sending right now:

- its group, name and channel range, for example **U0 · 100–181** (or **v2 serial**);
- its pixel colours, with the first pixel outlined.

Switch on **show channel values** to see a table of every DMX channel each fixture writes, with the value it sends. These are the real values on the wire, after gamma, which makes the table the quickest way to check addresses and channel layouts.

The Rig page shows the same view for the selected fixtures.

## Control Desk

![Control Desk page](control-desk.png)

The **Control Desk** (<kbd>9</kbd>) shows every DMX channel as a slider. Use it to test a fixture, find its address, set a channel by hand or silence a channel that misbehaves.

**To find a channel:**

1. Pick the **Universe** (0–3).
2. Pick a subpage of 64 channels (**1–64**, **65–128** and so on), or step through them with <kbd>Q</kbd> and <kbd>E</kbd>.

Each strip shows the channel number, an on/off switch, the value and, at the bottom, the fixture using the channel with the fixture's own channel number (for example **Pinspot 1 · 3**). The faint bar is what the channel sends right now.

### Overrides

**To override a channel,** drag its strip up or down, or switch it on. It then sends the slider value instead of what PitchControl calculates. Dragging starts from the current value, so nothing jumps; hold <kbd>Shift</kbd> for fine control.

**To release it,** switch it off.

With the keyboard, <kbd>↑</kbd> / <kbd>↓</kbd> change the selected channel by 5 (by 1 with <kbd>Shift</kbd>) and switch its override on. <kbd>⏎</kbd> switches the override on or off.

Overrides win over everything else, fog included.

> **Note:** Overrides are saved and come back when you restart PitchControl. While any are active, the header shows **N overrides**, and a dot marks each subpage that has some. Check before the show.

**To release all overrides** in every universe, click **Reset all**, then **Release all** to confirm.
