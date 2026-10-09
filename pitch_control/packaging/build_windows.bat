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
where python >NUL 2>&1 || where py >NUL 2>&1 || (echo Python 3 was not found. Install it from https://www.python.org and run this again.& goto :fail)
(
    echo node:& node --version
    echo npm:& call npm --version
    echo python:& python --version
    echo py:& py -3 --version
    echo uv:& uv --version
    echo git:& git --version
) >> "%LOG%" 2>&1

set "STEP=web UI"
echo == %STEP%
>> "%LOG%" echo == %STEP%
pushd frontend
if not exist node_modules call npm install --silent %OUT% || goto :fail
call npm run build --silent %OUT% || goto :fail
popd

set "STEP=Python environment"
echo == %STEP%
>> "%LOG%" echo == %STEP%
pushd backend
where uv >NUL 2>&1
if not errorlevel 1 (
    if not exist .venv\Scripts\python.exe uv venv -q .venv %OUT% || goto :fail
    uv pip install -q --python .venv\Scripts\python.exe -e ".[build]" %OUT% || goto :fail
) else (
    if not exist .venv\Scripts\python.exe (python -m venv .venv %OUT% || py -3 -m venv .venv %OUT% || goto :fail)
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
