---
title: Fog
description: Run DMX fog machines on a timer and fire them by hand from the General page or your controller.
order: 7
---

![Fog page](fog.png)

PitchControl drives fog machines over DMX, through the same outputs as your lights. Each machine can fog on a timer, by hand, or both.

## Add a fog machine

1. Press <kbd>7</kbd> for the **Fog** page and click **Add fog machine**.
2. Fill in the settings below.
3. Click **Save** at the top right. **Revert** discards your changes.

| Setting | Meaning |
|---|---|
| **Name** | A name for the machine, shown in the panel header |
| **Timer enabled** | Whether the timer fogs automatically |
| **Universe / channel** | The DMX universe and the channel the machine listens on |
| **On / off value** | The value sent while fogging and while not (0–255; usually 255 and 0) |
| **Every … for … seconds** | The timer: how often it fogs, and for how long |
| **Manual trigger** | With **Fog Machine button** on, the **Fog** button fires this machine |

A new machine starts with its timer off, so nothing fogs until you switch it on. The panel header shows **fogging** or **idle**. **Remove** deletes the machine.

PitchControl starts with two example machines: **Fog** on channel 1 (every 60 seconds for 4 seconds) and **Ground fog** on channel 2 (every 60 seconds for 2 seconds), both in universe 0.

## Timers

A timer fogs at the start of each interval for the set duration. "Every 60 for 4 seconds" fogs for the first 4 seconds of every minute. Intervals count from when PitchControl started, so two machines with the same interval fog together.

## Fire by hand

Hold the **Fog** button on the General page, with the mouse or by selecting it and holding <kbd>⏎</kbd>. Every machine with **Fog Machine button** switched on fogs for as long as you hold it, whether its timer is on or not.

The Launch Control XL's buttons aren't mapped, but you can map the **Fog Machine** macro to a button on your controller (see [Audio and MIDI](audio-and-midi)).

## Check the DMX path

A fog machine writes its channel into the DMX universe like a fixture does:

- Make sure an output sends that universe (see [Outputs and the Control Desk](outputs)).
- Don't put a fixture on the same channel.
- Use the Control Desk to see the channel move. An override on the Control Desk wins over the fog machine.
