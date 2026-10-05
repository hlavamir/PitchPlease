@echo off
rem PitchControl launcher for Windows: double-click in Explorer (or run from a terminal).
rem Sets up the Python environment and the web UI on first run, starts the backend
rem and opens the UI in the default browser. Close this window or press Ctrl+C to stop.
rem
rem Extra arguments are passed to the backend, e.g.:  run.bat --no-hardware

setlocal EnableExtensions EnableDelayedExpansion
set "ROOT=%~dp0"
set "ROOT=%ROOT:~0,-1%"
set "BACKEND=%ROOT%\backend"
set "FRONTEND=%ROOT%\frontend"
set "PYTHON=%BACKEND%\.venv\Scripts\python.exe"
set "PORT=8420"
set "URL=http://127.0.0.1:%PORT%"

echo == PitchControl ==

rem Already running? Just open the UI.
curl -s -o NUL --max-time 1 "%URL%/api/state" >NUL 2>&1
if not errorlevel 1 (
    echo PitchControl is already running, opening %URL%
    start "" "%URL%"
    exit /b 0
)

rem 1) Python environment (first run, or when pyproject.toml changed)
set "SETUP_PY=0"
if not exist "%PYTHON%" set "SETUP_PY=1"
if exist "%BACKEND%\.venv\setup.stamp" (
    for /f %%R in ('powershell -NoProfile -Command "if ((Get-Item '%BACKEND%\pyproject.toml').LastWriteTime -gt (Get-Item '%BACKEND%\.venv\setup.stamp').LastWriteTime) { 1 } else { 0 }"') do if "%%R"=="1" set "SETUP_PY=1"
) else (
    set "SETUP_PY=1"
)
if "%SETUP_PY%"=="1" (
    echo Setting up the Python environment...
    pushd "%BACKEND%"
    where uv >NUL 2>&1
    if not errorlevel 1 (
        if not exist "%PYTHON%" uv venv -q .venv
        uv pip install -q --python "%PYTHON%" -e .
    ) else (
        if not exist "%PYTHON%" py -3 -m venv .venv || python -m venv .venv
        "%PYTHON%" -m pip install -q --upgrade pip
        "%PYTHON%" -m pip install -q -e .
    )
    if errorlevel 1 (
        echo ERROR: Python setup failed. Install Python 3.11+ from python.org or uv, then try again.
        popd
        pause
        exit /b 1
    )
    type NUL > "%BACKEND%\.venv\setup.stamp"
    popd
)

rem 2) Web UI (first run, or when frontend sources changed)
set "BUILD_UI=0"
if not exist "%FRONTEND%\dist\index.html" (
    set "BUILD_UI=1"
) else (
    for /f %%R in ('powershell -NoProfile -Command "$t=(Get-Item '%FRONTEND%\dist\index.html').LastWriteTime; $n=@(Get-ChildItem -Recurse -File '%FRONTEND%\src','%FRONTEND%\index.html','%FRONTEND%\package.json' | Where-Object { $_.LastWriteTime -gt $t }).Count; if ($n -gt 0) { 1 } else { 0 }"') do set "BUILD_UI=%%R"
)
if "%BUILD_UI%"=="1" (
    where npm >NUL 2>&1
    if not errorlevel 1 (
        echo Building the web UI...
        pushd "%FRONTEND%"
        if not exist node_modules call npm install --silent
        call npm run build --silent
        popd
    ) else (
        if not exist "%FRONTEND%\dist\index.html" (
            echo ERROR: the web UI is not built and npm ^(Node.js^) is not installed.
            pause
            exit /b 1
        )
        echo Warning: UI sources changed but npm is not installed; using the existing build.
    )
)

rem 3) Open the browser as soon as the backend answers (in the background)
start "" /b powershell -NoProfile -WindowStyle Hidden -Command "for ($i=0; $i -lt 60; $i++) { try { Invoke-WebRequest -UseBasicParsing -TimeoutSec 1 '%URL%/api/state' | Out-Null; Start-Process '%URL%'; break } catch { Start-Sleep -Milliseconds 500 } }"

rem 4) Run the backend in the foreground (Ctrl+C or closing the window stops it)
cd /d "%BACKEND%"
"%PYTHON%" -m pitchcontrol --port %PORT% %*
endlocal
