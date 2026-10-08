#!/bin/bash
# PitchPls! v3 flash log reader - double-click to run.
# Opens the serial monitor at 115200 baud. Connecting restarts the ESP32, which prints the last
# 30 lines of its flash log. Then type:  l = whole log   t = last 40 lines   c = clear   h = help
# Quit with Ctrl+C. Power the device over USB only (LED power disconnected) while reading.

cd "$(dirname "$0")" || exit 1

PIO="${PIO_BIN:-$HOME/.platformio/penv/bin/pio}"
[ -x "$PIO" ] || PIO="$(command -v pio)"
PYTHON="$(dirname "$PIO")/python"
[ -x "$PYTHON" ] || PYTHON="$(command -v python3)"

pause_and_exit() {
  echo
  read -r -p "Press Enter to close this window..."
  exit "${1:-0}"
}

if [ ! -x "$PIO" ]; then
  echo "PlatformIO not found (looked in ~/.platformio/penv/bin/pio and on PATH)."
  pause_and_exit 1
fi

list_ports() {
  "$PIO" device list --serial --json-output | "$PYTHON" -c '
import json, sys
for d in json.load(sys.stdin):
    if d.get("hwid", "n/a") != "n/a":
        print(d["port"] + "\t" + d.get("description", ""))
'
}

echo "=== PitchPls! v3 flash log ==="
echo

while true; do
  PORTS=()
  DESCS=()
  while IFS=$'\t' read -r p d; do
    PORTS+=("$p")
    DESCS+=("$d")
  done < <(list_ports)
  [ ${#PORTS[@]} -gt 0 ] && break
  echo "No USB serial devices found. Connect the device, then press Enter to scan again (or q to quit)."
  read -r -p "> " ANSWER || exit 1
  [ "$ANSWER" = "q" ] && pause_and_exit 0
done

echo "Available ports (the ESP32 shows as CP2102 / CP210x):"
for i in "${!PORTS[@]}"; do
  printf "  [%d] %s  (%s)\n" $((i + 1)) "${PORTS[$i]}" "${DESCS[$i]}"
done
echo
while true; do
  read -r -p "Port number (1-${#PORTS[@]}): " CHOICE || exit 1
  if [[ "$CHOICE" =~ ^[0-9]+$ ]] && [ "$CHOICE" -ge 1 ] && [ "$CHOICE" -le "${#PORTS[@]}" ]; then
    break
  fi
  echo "  Not a valid choice."
done
PORT="${PORTS[$((CHOICE - 1))]}"

echo
echo "Commands once connected: l = whole log, t = last 40 lines, c = clear, h = help. Quit: Ctrl+C."
echo
"$PIO" device monitor --port "$PORT" --baud 115200 --echo --filter direct
pause_and_exit $?
