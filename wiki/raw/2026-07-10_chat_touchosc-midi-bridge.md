---
date_created: 2026-07-10
date_modified: 2026-07-10
source: cowork chat
---

# Chat: TouchOSC / MIDI Bridge Research
*2026-07-10 — conversation with Miro*

---

## Context

Exploring alternatives to a custom HTTP/WebSocket server for the phone→vvvv remote control idea. Question was whether there's a better way than WiFi HTTP.

---

## OSC vs HTTP

OSC over WiFi (via TouchOSC) is a better fit than custom HTTP/WebSocket:
- vvvv has native OSC input nodes, no extra NuGet packages needed
- TouchOSC (Mk2) is a phone app (~€20 one-time) for building custom control surfaces
- OSC uses UDP — lower latency than HTTP, fire-and-forget (fine for live control)
- No custom HTML/JS UI to write

---

## TouchOSC MIDI capability

TouchOSC can also send MIDI directly using RTP-MIDI (also called Network MIDI / AppleMIDI).

### Receiving on the laptop

**macOS:** Built-in, no extra software. Open Audio MIDI Setup → Window → Show MIDI Studio → click Network icon → create a session. TouchOSC connects and shows up as a MIDI device in any software including vvvv.

**Windows:** Needs rtpMIDI (free, by Tobias Erichsen). Creates the same virtual MIDI endpoint. After install, any software sees it as a MIDI device.

Once set up, vvvv reads TouchOSC via the same MIDI input nodes used for the Launch Control XL — no new plumbing in the patch.

MIDI is cruder than OSC (7-bit values, 0–127) but fine for brightness sliders and scene buttons.

---

## Building the interface

TouchOSC has a built-in editor on both desktop and iPhone — same app, same editor.

Typical workflow:
- Build layout on desktop (Mac/Windows) using drag-and-drop editor — faders, buttons, XY pads, labels, etc.
- Save as .tosc file
- Transfer to iPhone via: AirDrop (easiest on Mac), TouchOSC's built-in WiFi sync, or Finder file sharing over USB
- Can also build/edit directly on iPhone

---

## Network setup

Both approaches (OSC and RTP-MIDI) require phone and laptop on the same network.

Options:
- Same WiFi router (venue WiFi — unreliable for live use)
- **Phone hotspot → laptop connects to it** — most practical for live performance. No venue WiFi dependency, phone and laptop stay paired. Confirmed this works for both OSC and RTP-MIDI.
