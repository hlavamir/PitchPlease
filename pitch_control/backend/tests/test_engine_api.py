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
