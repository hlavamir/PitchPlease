import json
import logging

import pytest

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
    assert ftype.gamma == 1.0
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


def test_gamma_must_be_positive():
    from pitchcontrol.config.models import FixtureInstance, FixtureType

    assert FixtureType(gamma=0).gamma == 1.0
    assert FixtureType(gamma=-1).gamma == 1.0
    assert FixtureType(gamma=2.2).gamma == 2.2
    assert FixtureInstance(gamma=0).gamma is None  # falls back to the type
    assert FixtureInstance(gamma=1.8).gamma.value == 1.8


def test_legacy_gamma_keys_are_merged():
    from pitchcontrol.config.models import FixtureInstance, FixtureType

    assert FixtureInstance.model_validate({"brightness_gamma": 2.0}).gamma.value == 2.0
    assert FixtureInstance.model_validate({"brightness_gamma": 2.0, "rgb_gamma": 1.1}).gamma.value == pytest.approx(2.2)
    assert FixtureInstance.model_validate({"gamma": 1.5, "brightness_gamma": 2.0}).gamma.value == 1.5  # new key wins
    t = FixtureType.model_validate({"brightness_gamma": 1.0})
    assert t.gamma == 1.0 and "brightness_gamma" not in t.model_dump()


def test_overrides_keep_their_value_when_switched_off():
    from pitchcontrol.config.models import FixtureInstance

    # old plain values become enabled overrides
    f = FixtureInstance.model_validate({"gamma": 2.0, "strobo_color": {"h": 0.5, "s": 1, "b": 1}, "channel_values": {"mode": 2}})
    assert f.gamma.enabled and f.override("gamma", 1.0) == 2.0
    assert f.override("strobo_color", None).h == 0.5
    assert f.channel_value("mode", 0) == 2
    # switched off: the type's value applies, the override value stays
    f = FixtureInstance.model_validate({"gamma": {"enabled": False, "value": 2.0}, "channel_values": {"mode": {"enabled": False, "value": 3}}})
    assert f.override("gamma", 1.0) == 1.0 and f.gamma.value == 2.0
    assert f.channel_value("mode", 0) == 0 and f.channel_values["mode"].value == 3
    assert f.channel_value(None, 7) == 7
    assert f.model_dump()["gamma"] == {"enabled": False, "value": 2.0}


def test_pixel_override_is_dropped(caplog):
    from pitchcontrol.config.models import FixtureInstance

    with caplog.at_level(logging.WARNING):
        f = FixtureInstance.model_validate({"name": "x", "pixels": 12})
    assert "pixels" not in f.model_dump()
    assert "pixel count is no longer supported" in caplog.text


def test_react_to_strobo_is_a_rig_setting(config_dir):
    import json

    from pitchcontrol.config.models import FixtureInstance, FixtureType

    # old type files: the value is kept aside, not written back
    t = FixtureType.model_validate({"react_to_strobo": True})
    assert t.legacy_react_to_strobo is True and "react_to_strobo" not in t.model_dump() and "legacy_react_to_strobo" not in t.model_dump()
    # old overrides: enabled -> the value, switched off -> unset (filled in from the type on load)
    assert FixtureInstance.model_validate({"react_to_strobo": {"enabled": True, "value": True}}).react_to_strobo is True
    assert "react_to_strobo" not in FixtureInstance.model_validate({"react_to_strobo": {"enabled": False, "value": True}}).model_fields_set
    assert FixtureInstance.model_validate({"react_to_strobo": True}).react_to_strobo is True

    # an old rig takes the old type value for fixtures that don't set it
    types = config_dir / "fixtures" / "types"
    (types / "flasher.json").write_text(json.dumps({"pixels": 1, "react_to_strobo": True}))
    rig = {"fixtures": [{"name": "a", "type": "flasher"}, {"name": "b", "type": "flasher", "react_to_strobo": False}]}
    (config_dir / "rigs" / "old.json").write_text(json.dumps(rig))
    store = ConfigStore(config_dir)
    store.load_all()
    store.load_rig("old")
    assert [f.react_to_strobo for f in store.rig.fixtures] == [True, False]


def test_shipped_config_loads(tmp_path):
    """The config in the repo (what a downloaded app starts with) loads cleanly: every rig fixture
    has its type and no DMX ranges overlap."""
    import shutil

    from conftest import SHIPPED_CONFIG

    dst = tmp_path / "shipped"
    shutil.copytree(SHIPPED_CONFIG, dst, ignore=shutil.ignore_patterns("state"))
    store = ConfigStore(dst)
    store.load_all()
    for rig in store.list_names(store.rigs_dir):
        store.load_rig(rig)
        assert store.rig.fixtures, f"rig {rig} is empty"
        assert store.validate_rig() == [], f"rig {rig}: {store.validate_rig()}"
