#!/bin/bash
# PitchPls! v3 firmware flasher - double-click to run.
# Asks for the device's first DMX channel, the firmware variant and a USB port, then builds and
# uploads the firmware. Choices are passed to the build as -D flags, so no source file is modified.

cd "$(dirname "$0")" || exit 1

ALLOWED_ADDRESSES="100 200 300 400"

PIO="${PIO_BIN:-$HOME/.platformio/penv/bin/pio}"
[ -x "$PIO" ] || PIO="$(command -v pio)"
PYTHON="$(dirname "$PIO")/python"
[ -x "$PYTHON" ] || PYTHON="$(command -v python3)"

close_window() {
  local this_tty
  this_tty="$(tty)"
  osascript >/dev/null 2>&1 <<EOF &
tell application "Terminal"
  repeat with w in windows
    repeat with tb in tabs of w
      if tty of tb is "$this_tty" then close w
    end repeat
  end repeat
end tell
EOF
}

pause_and_exit() {
  echo
  read -r -p "Press Enter to close this window..."
  close_window
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

echo "=== PitchPls! v3 firmware flasher ==="
echo

# 1) DMX start address
while true; do
  read -r -p "DMX start address of this device (${ALLOWED_ADDRESSES// /, }): " ADDRESS || exit 1
  for a in $ALLOWED_ADDRESSES; do
    [ "$ADDRESS" = "$a" ] && break 2
  done
  echo "  Not a valid address - enter one of: $ALLOWED_ADDRESSES"
done

# 2) Firmware variant
echo
echo "Firmware:"
echo "  [1] normal"
echo "  [2] refresh measurement (measures the LED refresh rate at every boot, logs it to flash,"
echo "      shows it as a green bar for 5 s; read the result later with read-flash-log.command)"
while true; do
  read -r -p "Firmware (1-2, Enter = 1): " VARIANT || exit 1
  VARIANT="${VARIANT:-1}"
  case "$VARIANT" in
    1) EXTRA_FLAGS=""; VARIANT_NAME="normal"; break ;;
    2) EXTRA_FLAGS=" -DMEASURE_REFRESH=1"; VARIANT_NAME="refresh measurement"; break ;;
    *) echo "  Not a valid choice." ;;
  esac
done

# 3) Port
while true; do
  PORTS=()
  DESCS=()
  while IFS=$'\t' read -r p d; do
    PORTS+=("$p")
    DESCS+=("$d")
  done < <(list_ports)
  [ ${#PORTS[@]} -gt 0 ] && break
  echo
  echo "No USB serial devices found. Connect the device, then press Enter to scan again (or q to quit)."
  read -r -p "> " ANSWER || exit 1
  [ "$ANSWER" = "q" ] && pause_and_exit 0
done

echo
echo "Available ports:"
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

# 4) Build + flash
echo
echo "Flashing the $VARIANT_NAME firmware with DMX start address $ADDRESS to $PORT ..."
echo
PLATFORMIO_BUILD_FLAGS="-DDMX_START_CHANNEL_VALUE=$ADDRESS$EXTRA_FLAGS" "$PIO" run --target upload --upload-port "$PORT"
STATUS=$?

echo
if [ $STATUS -eq 0 ]; then
  echo "Done: $VARIANT_NAME firmware, DMX start address $ADDRESS, flashed to $PORT."
else
  echo "Flashing FAILED (exit code $STATUS) - see the output above."
  echo "Common causes: a serial monitor still has the port open, or the ESP32 needs its BOOT button held when the upload starts."
fi
pause_and_exit $STATUS
