"""One-time import of the vvvv scenes and macro state.

    python -m pitchcontrol.legacy [--vl ../vl] [--config ../config]

Reads ``vl/Scenes/Scene1.ini`` … ``Scene8.ini`` and ``vl/macros.ini`` (128
``;``-separated control values in vvvv macro-index order) and writes
``config/scenes/scene_N.json`` and ``config/state/macros.json``. Existing
PitchControl scenes are overwritten.
"""

from __future__ import annotations

import argparse
from pathlib import Path

from .config.loader import save_model
from .config.models import Scene
from .engine.macros import from_legacy_values

PROJECT_ROOT = Path(__file__).resolve().parents[3]


def parse_values(line: str) -> list[float]:
    return [float(x) for x in line.strip().split(";") if x.strip()]


def read_legacy_scene(path: Path) -> Scene:
    lines = [l.strip() for l in path.read_text(encoding="utf-8-sig").splitlines() if l.strip()]
    name = lines[0] if len(lines) > 1 else path.stem
    return Scene(name=name, values=from_legacy_values(parse_values(lines[-1])))


def import_all(vl_dir: Path, config_dir: Path) -> list[str]:
    done = []
    for i in range(8):
        src = vl_dir / "Scenes" / f"Scene{i + 1}.ini"
        if src.exists():
            save_model(config_dir / "scenes" / f"scene_{i + 1}.json", read_legacy_scene(src))
            done.append(str(src))
    macros = vl_dir / "macros.ini"
    if macros.exists():
        values = from_legacy_values(parse_values(macros.read_text(encoding="utf-8-sig")))
        save_model(config_dir / "state" / "macros.json", Scene(name="imported from vvvv macros.ini", values=values))
        done.append(str(macros))
    return done


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--vl", type=Path, default=PROJECT_ROOT.parent / "vl")
    parser.add_argument("--config", type=Path, default=PROJECT_ROOT / "config")
    args = parser.parse_args()
    for path in import_all(args.vl, args.config):
        print("imported", path)


if __name__ == "__main__":
    main()
