from pathlib import Path

from pitchcontrol import desktop


def test_source_run_uses_repo_config(monkeypatch, tmp_path):
    monkeypatch.setattr(desktop, "user_dir", lambda: tmp_path / "docs")
    res = desktop.resource_dir()
    data, reason = desktop.choose_data_dir(None, res)
    assert reason == "repo" and (data / "config" / "settings.json").exists()


def test_data_argument_wins(monkeypatch, tmp_path):
    monkeypatch.setattr(desktop, "user_dir", lambda: tmp_path / "docs")
    assert desktop.choose_data_dir(tmp_path / "x", desktop.resource_dir()) == (tmp_path / "x", "--data")


def test_pointer_file(monkeypatch, tmp_path):
    docs = tmp_path / "docs"
    target = tmp_path / "elsewhere"
    (target / "config").mkdir(parents=True)
    docs.mkdir()
    (docs / "data_folder.txt").write_text(str(target) + "\n")
    monkeypatch.setattr(desktop, "user_dir", lambda: docs)
    data, reason = desktop.choose_data_dir(None, desktop.resource_dir())
    assert data == target and reason.startswith("from")


def test_fallback_when_repo_missing(monkeypatch, tmp_path):
    monkeypatch.setattr(desktop, "user_dir", lambda: tmp_path / "docs")
    monkeypatch.setattr(desktop, "repo_folder", lambda res: None)
    assert desktop.choose_data_dir(None, Path("/nonexistent")) == (tmp_path / "docs", "fallback")


def test_default_install_never_overwrites(tmp_path):
    src, dst = tmp_path / "src", tmp_path / "dst"
    (src / "rigs").mkdir(parents=True)
    (src / "rigs" / "a.json").write_text("default")
    (src / "rigs" / "b.json").write_text("default")
    (src / "state").mkdir()
    (src / "state" / "macros.json").write_text("{}")
    (dst / "rigs").mkdir(parents=True)
    (dst / "rigs" / "a.json").write_text("mine")
    copied = desktop.install_default_config(src, dst)
    assert (dst / "rigs" / "a.json").read_text() == "mine"
    assert (dst / "rigs" / "b.json").read_text() == "default"
    assert not (dst / "state").exists() and len(copied) == 1
