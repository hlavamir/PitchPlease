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
import re
from dataclasses import dataclass, field
from pathlib import Path
from typing import TypeVar

from pydantic import BaseModel, ValidationError

from .models import Controller, FixtureType, Rig, Scene, Settings

log = logging.getLogger(__name__)

M = TypeVar("M", bound=BaseModel)

# rig names are file names: keep them portable (macOS / Windows) and free of path separators
RIG_NAME = re.compile(r"[A-Za-z0-9][A-Za-z0-9 _.\-]{0,63}")


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
            ftype.name = path.stem  # the file name is the type name
            if ftype.name in self.fixture_types:
                log.error("%s: duplicate fixture type name '%s', skipped", path, ftype.name)
                continue
            self.fixture_types[ftype.name] = ftype
        log.info("loaded %d fixture types: %s", len(self.fixture_types), ", ".join(self.fixture_types))

    def load_rig(self, name: str) -> None:
        rig = load_model(self.rigs_dir / f"{name}.json", Rig, name=name)
        self.rig = rig or Rig(name=name)
        self.rig.name = name  # the file name is the rig name
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
            count = ftype.channel_count()
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

    def dimmer_unassigned(self, macro: str) -> bool:
        """A dimmer macro no fixture of the active rig uses (enabled or not): disabled in the UI,
        ignored by MIDI."""
        return macro.startswith("Dimmer ") and not any(f.dimmer_macro == macro for f in self.rig.fixtures)

    # -- rig files
    def rig_path(self, name: str) -> Path:
        return self.rigs_dir / f"{name}.json"

    def rig_name_problem(self, name: str) -> str | None:
        """Why ``name`` can't be used for a new rig file, or None."""
        if not RIG_NAME.fullmatch(name):
            return "use letters, digits, space, - _ . (max 64, starting with a letter or digit)"
        taken = next((n for n in self.list_names(self.rigs_dir) if n.lower() == name.lower()), None)
        if taken is not None:  # case-insensitive: macOS and Windows file names are
            return f"the rig '{taken}' already exists"
        return None

    def rename_rig(self, new: str) -> None:
        """Rename the active rig's file. Unsaved live changes stay unsaved."""
        old = self.rig.name
        path = self.rig_path(old)
        # the file keeps its saved content; a missing or broken file takes the live rig
        saved = (load_model(path, Rig, name=old) if path.exists() else None) or self.rig.model_copy(deep=True)
        saved.name = new
        save_model(self.rig_path(new), saved)
        path.unlink(missing_ok=True)
        self.rig.name = new
        self.settings.active_rig = new
        self.save_settings()
        log.info("renamed rig '%s' to '%s'", old, new)

    def delete_rig(self, name: str) -> None:
        self.rig_path(name).unlink()
        log.info("deleted rig '%s'", name)

    # -- fixture type files
    def type_path(self, name: str) -> Path:
        return self.types_dir / f"{name}.json"

    def save_fixture_type(self, ftype: FixtureType) -> None:
        # the file name is the type name, so it isn't repeated inside the file
        path = self.type_path(ftype.name)
        path.parent.mkdir(parents=True, exist_ok=True)
        data = ftype.model_dump(mode="json", exclude_none=True, exclude={"name"})
        tmp = path.with_suffix(".json.tmp")
        tmp.write_text(json.dumps(data, indent=2) + "\n", encoding="utf-8")
        tmp.replace(path)

    def load_fixture_type(self, name: str) -> FixtureType | None:
        ftype = load_model(self.type_path(name), FixtureType, name=name)
        if ftype is not None:
            ftype.name = name
        return ftype

    def type_name_problem(self, name: str) -> str | None:
        """Why ``name`` can't be used for a new fixture type, or None."""
        if not RIG_NAME.fullmatch(name):
            return "use letters, digits, space, - _ . (max 64, starting with a letter or digit)"
        taken = next((n for n in self.fixture_types if n.lower() == name.lower()), None)
        if taken is not None:
            return f"the fixture type '{taken}' already exists"
        return None

    def type_usage(self) -> dict[str, list[str]]:
        """Fixture type -> the rigs using it: every rig file, the active rig as it is live."""
        usage: dict[str, set[str]] = {}
        for name in self.list_names(self.rigs_dir):
            rig = self.rig if name == self.rig.name else load_model(self.rig_path(name), Rig, name=name)
            for fx in rig.fixtures if rig else []:
                usage.setdefault(fx.type, set()).add(name)
        if self.rig.name not in self.list_names(self.rigs_dir):  # active rig without a file yet
            for fx in self.rig.fixtures:
                usage.setdefault(fx.type, set()).add(self.rig.name)
        return {t: sorted(r) for t, r in usage.items()}

    def rename_fixture_type(self, old: str, new: str) -> list[str]:
        """Rename a type's file and update every rig that uses it (files and the live rig, whose
        unsaved changes stay unsaved). Returns the rigs that were changed."""
        saved = self.load_fixture_type(old) or self.fixture_types[old].model_copy(deep=True)
        saved.name = new
        # delete before writing: on case-insensitive file systems (macOS, Windows) a rename that only
        # changes letter case would otherwise delete the file it just wrote
        self.type_path(old).unlink(missing_ok=True)
        self.save_fixture_type(saved)
        live = self.fixture_types.pop(old)
        live.name = new
        self.fixture_types[new] = live
        changed: list[str] = []
        for name in self.list_names(self.rigs_dir):
            rig = load_model(self.rig_path(name), Rig, name=name)
            if rig is not None and any(fx.type == old for fx in rig.fixtures):
                for fx in rig.fixtures:
                    if fx.type == old:
                        fx.type = new
                rig.name = name
                save_model(self.rig_path(name), rig)
                changed.append(name)
        for fx in self.rig.fixtures:
            if fx.type == old:
                fx.type = new
                if self.rig.name not in changed:
                    changed.append(self.rig.name)
        log.info("renamed fixture type '%s' to '%s' (rigs updated: %s)", old, new, ", ".join(changed) or "none")
        return changed

    def delete_fixture_type(self, name: str) -> None:
        self.type_path(name).unlink(missing_ok=True)
        self.fixture_types.pop(name, None)
        log.info("deleted fixture type '%s'", name)
