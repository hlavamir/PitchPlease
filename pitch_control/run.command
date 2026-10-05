#!/bin/bash
# PitchControl launcher for macOS: double-click in Finder (or run from a terminal).
# Sets up the Python environment and the web UI on first run, starts the backend
# and opens the UI in the default browser. Close this window or press Ctrl+C to stop.
#
# Extra arguments are passed to the backend, e.g.:  ./run.command --no-hardware

set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
BACKEND="$ROOT/backend"
FRONTEND="$ROOT/frontend"
PYTHON="$BACKEND/.venv/bin/python"
PORT=8420
URL="http://127.0.0.1:$PORT"

# Finder starts .command files with a minimal PATH; add the usual tool locations.
export PATH="/opt/homebrew/bin:/usr/local/bin:$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

echo "== PitchControl =="

# Already running? Just open the UI.
if curl -s -o /dev/null --max-time 1 "$URL/api/state"; then
    echo "PitchControl is already running, opening $URL"
    open "$URL"
    exit 0
fi

# 1) Python environment (first run, or when pyproject.toml changed)
if [ ! -x "$PYTHON" ] || [ "$BACKEND/pyproject.toml" -nt "$BACKEND/.venv" ]; then
    echo "Setting up the Python environment..."
    cd "$BACKEND"
    if command -v uv >/dev/null 2>&1; then
        [ -x "$PYTHON" ] || uv venv -q .venv
        uv pip install -q --python "$PYTHON" -e .
    else
        [ -x "$PYTHON" ] || python3 -m venv .venv
        "$PYTHON" -m pip install -q --upgrade pip
        "$PYTHON" -m pip install -q -e .
    fi
    touch "$BACKEND/.venv"
fi

# 2) Web UI (first run, or when frontend sources changed)
needs_build=0
if [ ! -f "$FRONTEND/dist/index.html" ]; then
    needs_build=1
elif [ -n "$(find "$FRONTEND/src" "$FRONTEND/index.html" "$FRONTEND/package.json" -newer "$FRONTEND/dist/index.html" -print -quit)" ]; then
    needs_build=1
fi
if [ "$needs_build" = 1 ]; then
    if command -v npm >/dev/null 2>&1; then
        echo "Building the web UI..."
        cd "$FRONTEND"
        [ -d node_modules ] || npm install --silent
        npm run build --silent
    elif [ ! -f "$FRONTEND/dist/index.html" ]; then
        echo "ERROR: the web UI is not built and npm (Node.js) is not installed." >&2
        read -r -p "Press Enter to close."
        exit 1
    else
        echo "Warning: UI sources changed but npm is not installed; using the existing build."
    fi
fi

# 3) Open the browser as soon as the backend answers
(
    for _ in $(seq 1 60); do
        if curl -s -o /dev/null --max-time 1 "$URL/api/state"; then
            open "$URL"
            exit 0
        fi
        sleep 0.5
    done
    echo "The backend did not start within 30 s, check the log above." >&2
) &

# 4) Run the backend in the foreground (Ctrl+C or closing the window stops it)
cd "$BACKEND"
exec "$PYTHON" -m pitchcontrol --port "$PORT" "$@"
