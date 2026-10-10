@echo off
rem Build PitchControl into pitch_control\dist\PitchControl\ (run on Windows).
rem
rem Everything the steps print goes to pitch_control\build-windows.log; the window shows the step
rem names and, if a step fails, the end of the log. The window stays open at the end (not on CI,
rem where the GitHub workflow sets CI and wants the output on the console).
setlocal EnableExtensions
cd /d "%~dp0.."
set "ROOT=%CD%"
set "LOG=%ROOT%\build-windows.log"
set "OUT=>> "%LOG%" 2>&1"
if defined CI set "OUT="
set "RC=0"
> "%LOG%" echo PitchControl Windows build, %DATE% %TIME%
>> "%LOG%" echo Folder: %ROOT%

set "STEP=checking the tools"
echo == %STEP%
>> "%LOG%" echo == %STEP%
where node >NUL 2>&1 || (echo Node.js was not found. Install the LTS version from https://nodejs.org and run this again.& goto :fail)
rem the UI build (Vite 8) needs Node 20.19 or newer, or 22.12 or newer
for /f "tokens=1,2 delims=v." %%a in ('node --version') do (set "NODE_MAJOR=%%a" & set "NODE_MINOR=%%b")
set "NODE_OK="
if %NODE_MAJOR% GTR 22 set "NODE_OK=1"
if %NODE_MAJOR% EQU 22 if %NODE_MINOR% GEQ 12 set "NODE_OK=1"
if %NODE_MAJOR% EQU 20 if %NODE_MINOR% GEQ 19 set "NODE_OK=1"
if not defined NODE_OK (echo Node.js %NODE_MAJOR%.%NODE_MINOR% is too old: the UI build needs 20.19 or newer, or 22.12 or newer. Install the LTS version from https://nodejs.org and run this again.& goto :fail)
for /f %%v in ('node --version') do set "NODE_VER=%%v"
rem python-rtmidi publishes Windows wheels only up to Python 3.12 (newer versions would need a C++ compiler),
rem so the environment is made with 3.12 or 3.11, even when a newer Python is installed next to it
set "PYLAUNCH="
where py >NUL 2>&1
if not errorlevel 1 (
    py -3.12 --version >NUL 2>&1 && set "PYLAUNCH=py -3.12"
    if not defined PYLAUNCH py -3.11 --version >NUL 2>&1 && set "PYLAUNCH=py -3.11"
)
if not defined PYLAUNCH python -c "import sys; sys.exit(0 if sys.version_info[:2] in ((3, 11), (3, 12)) else 1)" >NUL 2>&1 && set "PYLAUNCH=python"
where uv >NUL 2>&1 && set "HAVE_UV=1"
if not defined PYLAUNCH if not defined HAVE_UV (echo Python 3.12 or 3.11 was not found. Install Python 3.12 from https://www.python.org - it can stay next to a newer Python - and run this again.& goto :fail)
(
    echo node:& node --version
    echo npm:& call npm --version
    echo python:& python --version
    echo py -0p:& py -0p
    echo Python used: %PYLAUNCH%
    echo uv:& uv --version
    echo git:& git --version
) >> "%LOG%" 2>&1

set "STEP=web UI"
echo == %STEP%
>> "%LOG%" echo == %STEP%
pushd frontend
rem node_modules is only valid for the Node version that installed it: with an older Node, npm skips
rem the platform binary of the build tool (Rolldown), and it is not added when Node is upgraded later
set "INSTALLED_WITH="
if exist node_modules\.installed-with-node set /p INSTALLED_WITH=<node_modules\.installed-with-node
if not "%INSTALLED_WITH%"=="%NODE_VER%" (
    echo installing the UI packages for Node %NODE_VER%
    if exist node_modules rmdir /s /q node_modules
    call npm ci --silent %OUT% || goto :fail
    > node_modules\.installed-with-node echo %NODE_VER%
)
call npm run build --silent %OUT% || goto :fail
popd

set "STEP=Python environment"
echo == %STEP%
>> "%LOG%" echo == %STEP%
pushd backend
rem an environment from an unsuitable Python (an earlier try) is thrown away
if exist .venv\Scripts\python.exe .venv\Scripts\python.exe -c "import sys; sys.exit(0 if sys.version_info[:2] in ((3, 11), (3, 12)) else 1)" >NUL 2>&1 || rmdir /s /q .venv >NUL 2>&1
if defined HAVE_UV (
    if not exist .venv\Scripts\python.exe uv venv -q --python 3.12 .venv %OUT% || goto :fail
    uv pip install -q --python .venv\Scripts\python.exe -e ".[build]" %OUT% || goto :fail
) else (
    if not exist .venv\Scripts\python.exe %PYLAUNCH% -m venv .venv %OUT% || goto :fail
    .venv\Scripts\python.exe -m pip install -q -e ".[build]" %OUT% || goto :fail
)
popd
set "PY=%ROOT%\backend\.venv\Scripts\python.exe"
if not exist packaging\icon.ico "%PY%" packaging\make_icon.py %OUT%

set "STEP=PyInstaller"
echo == %STEP%
>> "%LOG%" echo == %STEP%
"%PY%" -m PyInstaller --noconfirm --clean --log-level WARN --distpath dist --workpath build packaging\pitchcontrol.spec %OUT% || goto :fail

set "STEP=smoke test"
echo == %STEP%
>> "%LOG%" echo == %STEP%
dist\PitchControl\PitchControl.exe --smoke-test --no-hardware --data "%TEMP%\pitchcontrol-smoke" --port 8499 %OUT% || goto :fail

set "STEP=zip"
echo == %STEP%
>> "%LOG%" echo == %STEP%
powershell -NoProfile -Command "Compress-Archive -Force -Path dist\PitchControl -DestinationPath dist\PitchControl-windows-x64.zip" %OUT% || goto :fail
echo Done: dist\PitchControl\PitchControl.exe and dist\PitchControl-windows-x64.zip
>> "%LOG%" echo Done.
goto :end

:fail
set "RC=1"
echo.
echo BUILD FAILED in step: %STEP%
>> "%LOG%" echo BUILD FAILED in step: %STEP%
if defined OUT (
    echo Last lines of the log:
    powershell -NoProfile -Command "Get-Content -Tail 30 -LiteralPath $env:LOG"
)
echo Full log: %LOG%

:end
if not defined CI (
    echo.
    echo Press any key to close this window.
    pause >NUL
)
exit /b %RC%
