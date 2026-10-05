"""Loading and saving of the JSON configuration folder.

Layout (relative to the config directory)::

    settings.json             outputs, inputs, fog, palette, engine options
    fixtures/types/*.json     one file per fixture model, all autoloaded
    rigs/<name>.json          fixture instances for one event / venue
    controllers/<name>.json   MIDI controller mappings
    scenes/scene_<n>.json     saved macro snapshots
    state/macros.json         auto-saved macro values (crash recovery)

Missing keys are filled with defaults. Unknown keys (usually typos) and invalid
files are reported to the log and never stop the engine.
"""

from __future__ import annotations

import json
import logging
from dataclasses import dataclass, field
from pathlib import Path
from typing import TypeVar

from pydantic import BaseModel, ValidationError

from .models import Controller, FixtureType, Rig, Scene, Settings

log = logging.getLogger(__name__)

M = TypeVar("M", bound=BaseModel)


def report_unknown_keys(model: BaseModel, source: str, path: str = "") -> list[str]:
    """Log (and return) every key that the model did not recognise, recursively."""
    found: list[str] = []
    for key in (model.model_extra or {}):
        if key.startswith("_"):  # "_comment", "_note" etc. are allowed annotations
            continue
        found.append(f"{path}{key}")
    for name in type(model).model_fields:
        value = getattr(model, name)
        children = value if isinstance(value, list) else [value]
        for i, child in enumerate(children):
            if isinstance(child, BaseModel):
                sub = f"{path}{name}[{i}]." if isinstance(value, list) else f"{path}{name}."
                found += report_unknown_keys(child, source, sub)
    if not path:
        for key in found:
            log.warning("%s: unknown key '%s' ignored (typo?)", source, key)
    return found


def load_model(path: Path, model: type[M], **defaults) -> M | None:
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except FileNotFoundError:
        log.warning("%s: not found, using defaults", path)
        return model(**defaults)
    except json.JSONDecodeError as exc:
        log.error("%s: invalid JSON (%s), skipped", path, exc)
        return None
    if isinstance(data, dict):
        for key, value in defaults.items():
            data.setdefault(key, value)
    try:
        obj = model.model_validate(data)
    except ValidationError as exc:
        log.error("%s: invalid content, skipped:\n%s", path, exc)
        return None
    report_unknown_keys(obj, str(path))
    return obj


def save_model(path: Path, obj: BaseModel) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    tmp = path.with_suffix(path.suffix + ".tmp")
    tmp.write_text(json.dumps(obj.model_dump(mode="json", exclude_none=True), indent=2) + "\n", encoding="utf-8")
    tmp.replace(path)


@dataclass
class ConfigStore:
    root: Path
    settings: Settings = field(default_factory=Settings)
    fixture_types: dict[str, FixtureType] = field(default_factory=dict)
    rig: Rig = field(default_factory=Rig)
    controller: Controller | None = None

    # -- paths
    @property
    def settings_path(self) -> Path:
        return self.root / "settings.json"

    @property
    def types_dir(self) -> Path:
        return self.root / "fixtures" / "types"

    @property
    def rigs_dir(self) -> Path:
        return self.root / "rigs"

    @property
    def controllers_dir(self) -> Path:
        return self.root / "controllers"

    @property
    def scenes_dir(self) -> Path:
        return self.root / "scenes"

    @property
    def state_dir(self) -> Path:
        return self.root / "state"

    # -- loading
    def load_all(self) -> None:
        self.settings = load_model(self.settings_path, Settings) or Settings()
        self.load_fixture_types()
        self.load_rig(self.settings.active_rig)
        self.load_controller(self.settings.active_controller)

    def load_fixture_types(self) -> None:
        self.fixture_types = {}
        for path in sorted(self.types_dir.glob("*.json")):
            ftype = load_model(path, FixtureType, name=path.stem)
            if ftype is None:
                continue
            if ftype.name in self.fixture_types:
                log.error("%s: duplicate fixture type name '%s', skipped", path, ftype.name)
                continue
            self.fixture_types[ftype.name] = ftype
        log.info("loaded %d fixture types: %s", len(self.fixture_types), ", ".join(self.fixture_types))

    def load_rig(self, name: str) -> None:
        rig = load_model(self.rigs_dir / f"{name}.json", Rig, name=name)
        self.rig = rig or Rig(name=name)
        self.validate_rig()
        log.info("loaded rig '%s' with %d fixtures", self.rig.name, len(self.rig.fixtures))

    def validate_rig(self) -> list[str]:
        """Log problems in the rig: unknown types and overlapping DMX ranges."""
        problems: list[str] = []
        used: dict[tuple[int, int], str] = {}
        for fx in self.rig.fixtures:
            ftype = self.fixture_types.get(fx.type)
            if ftype is None:
                problems.append(f"fixture '{fx.name}': unknown type '{fx.type}' (it will be skipped)")
                continue
            if not fx.enabled or ftype.transport != "dmx":
                continue
            count = ftype.channel_count(fx.pixels)
            end = fx.address + count - 1
            if end > 512:
                problems.append(f"fixture '{fx.name}': channels {fx.address}-{end} exceed 512")
            for ch in range(fx.address, min(end, 512) + 1):
                other = used.get((fx.universe, ch))
                if other and other != fx.name:
                    problems.append(
                        f"fixture '{fx.name}' overlaps '{other}' in universe {fx.universe} at channel {ch}"
                    )
                    break
                used[(fx.universe, ch)] = fx.name
        for p in problems:
            log.warning("rig '%s': %s", self.rig.name, p)
        return problems

    def load_controller(self, name: str | None) -> None:
        self.controller = None
        if name:
            self.controller = load_model(self.controllers_dir / f"{name}.json", Controller, name=name)

    def list_names(self, folder: Path) -> list[str]:
        return sorted(p.stem for p in folder.glob("*.json"))

    # -- scenes
    def scene_path(self, index: int) -> Path:
        return self.scenes_dir / f"scene_{index + 1}.json"

    def load_scene(self, index: int) -> Scene | None:
        path = self.scene_path(index)
        if not path.exists():
            return None
        return load_model(path, Scene)

    def save_scene(self, index: int, scene: Scene) -> None:
        save_model(self.scene_path(index), scene)

    # -- saving
    def save_settings(self) -> None:
        save_model(self.settings_path, self.settings)

    def save_rig(self) -> None:
        save_model(self.rigs_dir / f"{self.rig.name}.json", self.rig)

    def save_fixture_type(self, ftype: FixtureType) -> None:
        save_model(self.types_dir / f"{ftype.name}.json", ftype)
