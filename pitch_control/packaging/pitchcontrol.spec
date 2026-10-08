# PyInstaller spec for the standalone PitchControl app (macOS .app / Windows folder with .exe).
# Build with packaging/build_macos.command or packaging/build_windows.bat — must run on the target OS.
import sys
from pathlib import Path

from PyInstaller.utils.hooks import collect_submodules

HERE = Path(SPECPATH)
ROOT = HERE.parent  # pitch_control/
# the release number lives in pitchcontrol/__init__.py
import re
import subprocess

VERSION = re.search(r'__version__ = "([^"]+)"', (ROOT / "backend" / "src" / "pitchcontrol" / "__init__.py").read_text()).group(1)


def git_describe() -> str | None:
    try:
        res = subprocess.run(["git", "describe", "--tags", "--match", "pitchcontrol-v*", "--long", "--dirty"], cwd=ROOT, capture_output=True, text=True, timeout=10)
    except (OSError, subprocess.SubprocessError):
        return None
    return res.stdout.strip() if res.returncode == 0 else None


# where this repo lives on the build machine: the app uses its config/ folder when it exists
import json
from datetime import datetime

BUILD_INFO = Path(workpath) / "build_info.json"
BUILD_INFO.parent.mkdir(parents=True, exist_ok=True)
BUILD_INFO.write_text(
    json.dumps({"pitch_control_dir": str(ROOT), "built": datetime.now().isoformat(timespec="seconds"), "version": VERSION, "describe": git_describe()})
)

# bundled default config (without runtime state), build info and the built web UI
datas = [(str(ROOT / "frontend" / "dist"), "frontend_dist"), (str(BUILD_INFO), ".")]
for f in (ROOT / "config").rglob("*"):
    rel = f.relative_to(ROOT / "config")
    if f.is_file() and "state" not in rel.parts:
        datas.append((str(f), str(Path("default_config") / rel.parent)))

hiddenimports = (
    collect_submodules("pitchcontrol")
    + collect_submodules("uvicorn")
    + ["mido.backends.rtmidi", "rtmidi"]
)

a = Analysis(
    [str(HERE / "app_entry.py")],
    pathex=[str(ROOT / "backend" / "src")],
    datas=datas,
    hiddenimports=hiddenimports,
    excludes=["tkinter", "matplotlib", "pytest", "IPython", "PIL"],
    noarchive=False,
)
pyz = PYZ(a.pure)

exe = EXE(
    pyz,
    a.scripts,
    [],
    exclude_binaries=True,
    name="PitchControl",
    console=False,
    icon=str(HERE / ("icon.icns" if sys.platform == "darwin" else "icon.ico")),
)
coll = COLLECT(exe, a.binaries, a.datas, name="PitchControl")

if sys.platform == "darwin":
    app = BUNDLE(
        coll,
        name="PitchControl.app",
        icon=str(HERE / "icon.icns"),
        bundle_identifier="com.pitchplease.pitchcontrol",
        version=VERSION,
        info_plist={
            "CFBundleDisplayName": "PitchControl",
            "CFBundleShortVersionString": VERSION,
            "CFBundleVersion": VERSION,
            "LSMinimumSystemVersion": "11.0",
            "NSHighResolutionCapable": True,
            # without this, macOS silently denies audio input to the app
            "NSMicrophoneUsageDescription": "PitchControl analyses the audio input to drive the lights.",
        },
    )
