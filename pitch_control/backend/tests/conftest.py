import shutil
from pathlib import Path

import pytest

from pitchcontrol.config.loader import ConfigStore

CONFIG = Path(__file__).resolve().parents[2] / "config"


@pytest.fixture
def config_dir(tmp_path: Path) -> Path:
    """A copy of the shipped default config, safe to modify."""
    dst = tmp_path / "config"
    shutil.copytree(CONFIG, dst, ignore=shutil.ignore_patterns("state"))
    return dst


@pytest.fixture
def store(config_dir: Path) -> ConfigStore:
    s = ConfigStore(config_dir)
    s.load_all()
    return s
