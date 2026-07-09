---
date_created: 2026-07-09
date_modified: 2026-07-09
---

# WiFi Bridge — Phone to vvvv

> Future dev: a phone-accessible web UI hosted directly in vvvv, allowing remote control of lights over local WiFi without any changes to the ESP32 firmware.

## Concept

Run a small HTTP server inside the vvvv patch that serves a control interface (sliders, buttons, scene triggers) accessible from a phone browser on the same local network. The phone talks to vvvv; vvvv handles DMX output to the v3 devices as normal. The ESP32 firmware requires no changes.

```
Phone browser → WiFi → vvvv HTTP/WebSocket server → DMX → v3 devices
```

This is strictly a vvvv-side feature. The `testing/standalone_esp32/` prototype explored a different approach (web server on the ESP32 itself), which was abandoned because it decoupled the visual logic from vvvv. This approach avoids that problem entirely.

## Implementation in vvvv Gamma

vvvv gamma supports HTTP and WebSocket servers via NuGet packages installable directly from the vvvv package browser:

- **`VL.IO.HTTP`** — HTTP server nodes. Use to serve the HTML control page.
- **`VL.IO.WebSocket`** — WebSocket nodes. Use for real-time bidirectional communication so slider/button events reach vvvv instantly without page reloads.

Basic setup:
1. Install `VL.IO.HTTP` and `VL.IO.WebSocket` via the vvvv NuGet package manager.
2. Add an HTTP server node listening on a port (e.g. 8080) and serve a single HTML page with the control UI.
3. Add a WebSocket server node (same or different port) and wire incoming messages to the relevant patch parameters (scene selection, brightness, mode, etc.).
4. The control HTML page connects to the WebSocket and sends messages on user interaction.

## Connecting from a Phone

Both devices must be on the same local WiFi network. Find the laptop's local IP (System Settings → Network on macOS, or `ipconfig` / `ifconfig` in terminal), then navigate to:

```
http://<laptop-ip>:8080
```

No app installation required — any phone browser works.

## Control UI Scope (TBD)

What the phone UI should expose is TBD. Candidates:

- Scene selection (maps to existing 8-scene system)
- Master brightness
- Per-strip brightness (if axis flip mode is implemented — see [[v3]])
- Mode switching

## See Also

- [[v3]] — Hardware context, DMX setup
- [[vvvv-patch]] — The patch this feature extends

## Open Questions

- Which parameters should the phone UI expose?
- Should the UI be a bespoke HTML/JS page embedded in the vvvv patch, or a separate file served from disk?
- Is WebSocket sufficient or would OSC over UDP be simpler to wire up in vvvv?
