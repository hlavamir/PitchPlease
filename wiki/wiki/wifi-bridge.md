---
date_created: 2026-07-09
date_modified: 2026-07-10
---

# Phone Remote Control — TouchOSC + vvvv

> Future dev: control lights from a phone during live performance, without touching the laptop.

## Recommended approach: TouchOSC via RTP-MIDI

[TouchOSC Mk2](https://hexler.net/touchosc) (~€20, one-time) is a phone app for building custom control surfaces. It sends MIDI over the local network using **RTP-MIDI** (also called Network MIDI / AppleMIDI), appearing as a standard MIDI device on the laptop. vvvv reads it via the same MIDI input nodes already used for the Launch Control XL — no new patch plumbing needed.

**Why MIDI over custom HTTP/WebSocket:**
- No NuGet packages or custom server code required in vvvv
- Slots into existing MIDI infrastructure in the patch
- TouchOSC handles the phone UI — no HTML/JS to maintain
- Standard protocol, low latency (UDP)

## Setup

### 1. Laptop side

**macOS** — no extra software needed. Open *Audio MIDI Setup → Window → Show MIDI Studio*, click the Network icon, create a session. TouchOSC connects to it and appears as a MIDI device in vvvv automatically.

**Windows** — install [rtpMIDI](https://www.tobias-erichsen.de/software/rtpmidi.html) (free, Tobias Erichsen). Creates the same virtual MIDI endpoint. Any software including vvvv sees it as a MIDI device.

### 2. Build the control surface

TouchOSC has a built-in drag-and-drop editor, available on both desktop (Mac/Windows) and iPhone. Typical workflow:

1. Design the layout on desktop — add faders, buttons, XY pads, labels
2. Save as a `.tosc` file
3. Transfer to iPhone via AirDrop, TouchOSC's built-in WiFi sync, or Finder file sharing over USB

You can also build and edit the layout directly on the iPhone.

### 3. Network

Both devices need to be on the same network. Options:

| Setup | Reliability | Notes |
|---|---|---|
| Venue WiFi | Low | Can't control it; congestion, firewalls, etc. |
| Phone hotspot → laptop | High | Phone hosts, laptop connects. No router needed. Best for live use. |

**Recommended: phone hotspot.** Phone hosts a personal hotspot, laptop connects to it. The phone then also runs TouchOSC — both the hotspot and the control surface run on the same device. No venue WiFi dependency.

## Control UI scope

Everything currently in the vvvv UI:

- Brightnesses (master + per-strip)
- Audio signal sensitivity
- Shader presets and parameters
- Various switches
- Scene loading and saving

## Protocol: MIDI confirmed

MIDI (0–127) is sufficient — none of the parameters need sub-127 resolution. OSC (float) is not needed.

## See Also

- [[v3]] — Hardware context, DMX setup
- [[vvvv-patch]] — The patch this feature extends
