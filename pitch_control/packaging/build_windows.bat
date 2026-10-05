@echo off
rem Build PitchControl into pitch_control\dist\PitchControl\ (run on Windows).
setlocal
cd /d "%~dp0.."
set "ROOT=%CD%"

echo == web UI
pushd frontend
if not exist node_modules call npm install --silent || goto :fail
call npm run build --silent || goto :fail
popd

echo == Python environment
pushd backend
where uv >NUL 2>&1
if not errorlevel 1 (
    if not exist .venv\Scripts\python.exe uv venv -q .venv || goto :fail
    uv pip install -q --python .venv\Scripts\python.exe -e ".[build]" || goto :fail
) else (
    if not exist .venv\Scripts\python.exe (python -m venv .venv || py -3 -m venv .venv || goto :fail)
    .venv\Scripts\python.exe -m pip install -q -e ".[build]" || goto :fail
)
popd
set "PY=%ROOT%\backend\.venv\Scripts\python.exe"
if not exist packaging\icon.ico "%PY%" packaging\make_icon.py

echo == PyInstaller
"%PY%" -m PyInstaller --noconfirm --clean --log-level WARN --distpath dist --workpath build packaging\pitchcontrol.spec || goto :fail

echo == smoke test
dist\PitchControl\PitchControl.exe --smoke-test --no-hardware --data "%TEMP%\pitchcontrol-smoke" --port 8499 || goto :fail

powershell -NoProfile -Command "Compress-Archive -Force -Path dist\PitchControl -DestinationPath dist\PitchControl-windows-x64.zip" || goto :fail
echo Done: dist\PitchControl\PitchControl.exe and dist\PitchControl-windows-x64.zip
exit /b 0

:fail
echo BUILD FAILED
exit /b 1
