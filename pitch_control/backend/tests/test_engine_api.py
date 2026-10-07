import numpy as np
from fastapi.testclient import TestClient

from pitchcontrol.engine.engine import Engine
from pitchcontrol.server.app import create_app


def test_engine_tick_produces_universe(store):
    engine = Engine(store, enable_hardware=False)
    for _ in range(5):
        engine.tick(1 / 40)
    uni = engine.universes[0]
    assert uni[99:105] == bytes([255, 0, 255, 255, 255, 255])  # v3 #1 header at address 100
    assert len(engine.v2_strips) == 4 and len(engine.v2_strips[0]) == 57


def test_engine_reacts_to_kick(store):
    engine = Engine(store, enable_hardware=False)
    engine.macros.set("Strobo", 1.0)
    sr = store.settings.audio.sample_rate
    t = np.arange(sr // 40) / sr
    for i in range(80):  # 2 s: silence, then a loud 55 Hz burst
        if i == 60:
            engine.analyzer.push(0.8 * np.sin(2 * np.pi * 55 * t))
        else:
            engine.analyzer.push(np.zeros_like(t))
        engine.tick(1 / 40)
        if engine.phase.on_peak:
            break
    assert engine.peaks_total >= 1


def test_scene_save_and_load(store):
    engine = Engine(store, enable_hardware=False)
    engine.macros.set("Hue A", 0.3)
    engine.save_scene(7)
    engine.macros.set("Hue A", 0.9)
    assert engine.load_scene(7)
    assert engine.macros.control("Hue A") == 0.3


def test_api_and_websocket(store):
    engine = Engine(store, enable_hardware=False)
    engine.tick(1 / 40)
    client = TestClient(create_app(engine))
    assert len(client.get("/api/macros/defs").json()) > 40
    assert client.post("/api/macros", json={"name": "Strobo", "value": 0.5}).json()["ok"]
    assert engine.macros.control("Strobo") == 0.5
    assert client.post("/api/macros", json={"name": "Nope", "value": 1}).status_code == 404
    rig = client.get("/api/rig").json()
    rig["fixtures"][0]["address"] = 101
    assert "problems" in client.put("/api/rig", json=rig).json()
    assert client.get("/api/audio/bands").json()["trigger_weights"][0] == 1.0
    with client.websocket_connect("/ws") as ws:
        state = ws.receive_json()
        assert "fixtures" in state and "bands" in state
        preview = ws.receive_bytes()
        assert len(preview) == 256 * 256
        ws.send_json({"type": "macro", "name": "Strobo", "value": 0.25})
        ws.receive_json()
    assert engine.macros.control("Strobo") == 0.25


def test_rig_management(store):
    engine = Engine(store, enable_hardware=False)
    client = TestClient(create_app(engine))
    rigs = lambda: client.get("/api/rigs").json()  # noqa: E731
    # the shipped rig's name changes with the events; call it "default" here so the expected
    # (sorted) rig lists below stay fixed
    if store.rig.name != "default":
        assert client.post("/api/rig/rename", json={"name": "default"}).json()["ok"]

    # live edit, then "save as": the copy gets the edit, the original file keeps its saved content
    rig = client.get("/api/rig").json()
    rig["fixtures"][0]["address"] = 101
    client.put("/api/rig?persist=false", json=rig)
    assert rigs()["unsaved"]
    assert client.post("/api/rig/duplicate", json={"name": "club"}).json()["name"] == "club"
    assert rigs() == {"active": "club", "available": ["club", "default"], "unsaved": False}
    assert store.settings.active_rig == "club"
    assert client.post("/api/rig/activate", json={"name": "default"}).json()["ok"]
    assert client.get("/api/rig").json()["fixtures"][0]["address"] == 100
    client.post("/api/rig/activate", json={"name": "club"})
    assert client.get("/api/rig").json()["fixtures"][0]["address"] == 101

    # names: taken (any case), unsafe
    assert client.post("/api/rig/duplicate", json={"name": "Default"}).status_code == 409
    assert client.post("/api/rig/new", json={"name": "../evil"}).status_code == 409
    assert client.post("/api/rig/new", json={"name": ""}).status_code == 409

    # rename keeps unsaved live changes unsaved and the saved file as it was
    rig = client.get("/api/rig").json()
    rig["fixtures"][0]["address"] = 102
    client.put("/api/rig?persist=false", json=rig)
    assert client.post("/api/rig/rename", json={"name": "club 2"}).json()["ok"]
    assert rigs() == {"active": "club 2", "available": ["club 2", "default"], "unsaved": True}
    assert (store.rigs_dir / "club 2.json").exists() and not (store.rigs_dir / "club.json").exists()
    assert client.post("/api/rig/reload").json()["fixtures"][0]["address"] == 101

    # new empty rig, delete it (switches to a neighbour), the last rig stays
    assert client.post("/api/rig/new", json={"name": "empty"}).json()["ok"]
    assert client.get("/api/rig").json()["fixtures"] == []
    assert client.delete("/api/rig").json()["active"] == "default"  # the next name, or the previous for the last
    assert client.delete("/api/rig").json()["active"] == "club 2"
    assert client.delete("/api/rig").status_code == 409
    assert rigs()["available"] == ["club 2"]


def test_dimmer_names_and_unused_dimmers_ignore_midi(store):
    import mido

    from pitchcontrol.config.models import Controller, MidiMapping
    from pitchcontrol.io.midi_in import MidiInput

    engine = Engine(store, enable_hardware=False)
    client = TestClient(create_app(engine))
    store.rig.dimmer_names = {"Dimmer 01": "Front"}

    # rename live: the rig is unsaved, an empty name removes the name
    res = client.post("/api/rig/dimmer-name", json={"macro": "Dimmer 02", "name": "  Back  "}).json()
    assert res["dimmer_names"] == {"Dimmer 01": "Front", "Dimmer 02": "Back"}
    assert client.get("/api/rigs").json()["unsaved"]
    client.post("/api/rig/dimmer-name", json={"macro": "Dimmer 01", "name": ""})
    assert client.get("/api/rig").json()["dimmer_names"] == {"Dimmer 02": "Back"}
    assert client.post("/api/rig/dimmer-name", json={"macro": "Strobo", "name": "x"}).status_code == 404

    # MIDI moves only dimmers that a fixture uses
    store.rig.fixtures[0].dimmer_macro = "Dimmer 02"
    for f in store.rig.fixtures[1:]:
        f.dimmer_macro = None
    ctrl = Controller(name="t", channel=1, mappings=[MidiMapping(cc=1, macro="Dimmer 01"), MidiMapping(cc=2, macro="Dimmer 02")])
    midi = MidiInput(ctrl, None, engine.macros, ignored=store.dimmer_unassigned)
    engine.macros.set("Dimmer 01", 1.0)
    engine.macros.set("Dimmer 02", 1.0)
    for cc in (1, 2):
        midi.handle(mido.Message("control_change", channel=0, control=cc, value=0))
    assert engine.macros.control("Dimmer 01") == 1.0  # unassigned: ignored
    assert engine.macros.control("Dimmer 02") == 0.0
    assert "unassigned" in midi.recent[0]["note"]
    assert not store.dimmer_unassigned("Dimmer 02") and store.dimmer_unassigned("Dimmer 01")
