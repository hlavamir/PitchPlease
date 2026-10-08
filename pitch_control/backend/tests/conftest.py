import shutil
from pathlib import Path

import pytest

from pitchcontrol.config.loader import ConfigStore

# A fixed copy of the config (as of 2026-10-08) instead of the shipped pitch_control/config, which
# Miro edits in the app (renamed types and rigs broke name-based tests before). The shipped config
# is checked on its own in test_shipped_config_loads.
CONFIG = Path(__file__).resolve().parent / "config"
SHIPPED_CONFIG = Path(__file__).resolve().parents[2] / "config"


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
