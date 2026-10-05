#!/bin/bash
# Build PitchControl.app into pitch_control/dist/ (run on a Mac; the app runs on the same CPU type).
set -euo pipefail
export PATH="/opt/homebrew/bin:/usr/local/bin:$HOME/.local/bin:$PATH"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

echo "== web UI"
(cd frontend && { [ -d node_modules ] || npm install --silent; } && npm run build --silent)

echo "== Python environment"
cd backend
if command -v uv >/dev/null 2>&1; then
    [ -x .venv/bin/python ] || uv venv -q .venv
    uv pip install -q --python .venv/bin/python -e ".[build]"
else
    [ -x .venv/bin/python ] || python3 -m venv .venv
    .venv/bin/python -m pip install -q -e ".[build]"
fi
PY="$ROOT/backend/.venv/bin/python"
cd "$ROOT"
[ -f packaging/icon.icns ] || "$PY" packaging/make_icon.py

echo "== PyInstaller"
"$PY" -m PyInstaller --noconfirm --clean --log-level WARN \
    --distpath dist --workpath build packaging/pitchcontrol.spec

echo "== smoke test"
"dist/PitchControl.app/Contents/MacOS/PitchControl" --smoke-test --no-hardware --data "$(mktemp -d)" --port 8499

ARCH="$(uname -m)"
rm -f "dist/PitchControl-macos-$ARCH.zip"
ditto -c -k --keepParent dist/PitchControl.app "dist/PitchControl-macos-$ARCH.zip"
echo "Done: dist/PitchControl.app and dist/PitchControl-macos-$ARCH.zip"
