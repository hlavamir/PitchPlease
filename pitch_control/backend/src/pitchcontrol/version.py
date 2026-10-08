"""The version shown in the UI and the log: the release number, and for builds between releases how
far past the last release tag they are ("1.1.0+3 (abc1234)"), so a test build is never mistaken for
a release."""

from __future__ import annotations

import json
import re
import subprocess
import sys
from functools import lru_cache
from pathlib import Path

from . import __version__

TAG_PREFIX = "pitchcontrol-v"


def git_describe(repo: Path) -> str | None:
    """``git describe`` against the release tags, e.g. "pitchcontrol-v1.1.0-3-gabc1234-dirty"."""
    try:
        res = subprocess.run(
            ["git", "describe", "--tags", "--match", f"{TAG_PREFIX}*", "--long", "--dirty"],
            cwd=repo,
            capture_output=True,
            text=True,
            timeout=3,
        )
    except (OSError, subprocess.SubprocessError):
        return None
    return res.stdout.strip() if res.returncode == 0 else None


def label_from_describe(describe: str | None, version: str = __version__) -> str:
    """"1.1.0" for the tagged release itself, "1.1.0+3 (abc1234)" for commits after it,
    "1.2.0-dev (abc1234)" when the number was raised but not tagged yet; ", modified" = local changes."""
    m = re.fullmatch(rf"{TAG_PREFIX}(.+)-(\d+)-g([0-9a-f]+)(-dirty)?", describe or "")
    if not m:
        return version
    tag, distance, sha, dirty = m.group(1), int(m.group(2)), m.group(3), bool(m.group(4))
    if tag == version and distance == 0 and not dirty:
        return version
    suffix = f"+{distance}" if tag == version and distance else "" if tag == version else "-dev"
    return f"{version}{suffix} ({sha}{', modified' if dirty else ''})"


@lru_cache(maxsize=1)
def version_label() -> str:
    if getattr(sys, "frozen", False):  # app bundle: recorded at build time (packaging/pitchcontrol.spec)
        try:
            info = json.loads((Path(getattr(sys, "_MEIPASS", ".")) / "build_info.json").read_text(encoding="utf-8"))
        except (OSError, ValueError):
            return __version__
        return label_from_describe(info.get("describe"))
    return label_from_describe(git_describe(Path(__file__).resolve().parents[3]))
