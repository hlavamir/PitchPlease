import json
import logging

from pitchcontrol.config.loader import ConfigStore, load_model
from pitchcontrol.config.models import FixtureType


def test_default_config_loads_cleanly(store, caplog):
    assert {"pitchpls_v3", "pitchpls_v2", "cameo_qspot15_rgbw", "rgb_panel"} <= set(store.fixture_types)
    assert store.rig.name == store.settings.active_rig  # the rig file name, whatever the rig is called
    assert store.controller is not None and store.controller.channel == 13
    assert store.validate_rig() == []


def test_missing_keys_get_defaults(tmp_path):
    path = tmp_path / "minimal.json"
    path.write_text(json.dumps({"pixels": 3}))
    ftype = load_model(path, FixtureType, name="minimal")
    assert ftype.name == "minimal"
    assert ftype.brightness_gamma == 1.0
    assert ftype.channels[0].pixels == "RGB"
    assert ftype.channel_count() == 9


def test_unknown_keys_are_logged_not_fatal(tmp_path, caplog):
    path = tmp_path / "typo.json"
    path.write_text(json.dumps({"pixels": 2, "gama": 2.2, "_note": "annotations are fine"}))
    with caplog.at_level(logging.WARNING):
        ftype = load_model(path, FixtureType, name="typo")
    assert ftype is not None and ftype.pixels == 2
    assert "unknown key 'gama'" in caplog.text
    assert "_note" not in caplog.text


def test_invalid_file_is_skipped(config_dir, caplog):
    (config_dir / "fixtures" / "types" / "broken.json").write_text("{ not json")
    store = ConfigStore(config_dir)
    with caplog.at_level(logging.ERROR):
        store.load_all()
    assert "broken" not in store.fixture_types
    assert "invalid JSON" in caplog.text


def test_overlapping_addresses_are_reported(store):
    pinspot = next(f for f in store.rig.fixtures if f.type == "cameo_qspot15_rgbw")
    pinspot.address = 101  # inside v3 #1 (100..177)
    problems = store.validate_rig()
    assert any("overlaps" in p for p in problems)
