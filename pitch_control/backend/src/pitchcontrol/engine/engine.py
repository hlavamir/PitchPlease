"""The PitchControl engine: one frame = audio → phase → mask → fixtures → outputs.

Runs in its own thread at ``settings.fps`` (40 by default), independent of the
web UI. Everything that changes the engine from outside (API, MIDI) goes through
the thread-safe ``MacroBank`` or ``Engine.lock``.
"""

from __future__ import annotations

import copy
import logging
import threading
import time

import numpy as np

from ..config.loader import ConfigStore, load_model, save_model
from ..config.models import Scene
from ..io.audio_in import AudioInput
from ..io.midi_in import MidiInput
from ..io.outputs import OutputManager
from .audio_analysis import AudioFeatures, SpectrumAnalyzer, trigger_weights
from .colors import GroupColors, hsv_to_rgb
from .fixtures import Fixture, GroupBrightness
from .fog import FogController
from .macros import MacroBank
from .masks import PRESET_NAMES, MaskGenerator, MaskParams, PeaksMap, mixed_mask
from .phase import PhaseTracker

log = logging.getLogger(__name__)

PREVIEW_SIZE = 256


class MacroState(Scene):
    """``state/macros.json``: auto-saved macro values for crash recovery."""


class Engine:
    def __init__(self, store: ConfigStore, enable_hardware: bool = True):
        self.store = store
        self.enable_hardware = enable_hardware
        self.lock = threading.RLock()
        self.macros = MacroBank()
        self._restore_macros()

        self.phase = PhaseTracker()
        self.colors = GroupColors()
        self.fog = FogController()
        self.fixtures: list[Fixture] = []
        self.universes: dict[int, bytearray] = {}
        self.v2_strips: list[list[int]] = []

        grid = (np.arange(PREVIEW_SIZE) + 0.5) / PREVIEW_SIZE
        self.preview_u, self.preview_v = np.meshgrid(grid, grid)
        self._preview_inputs: tuple[MaskParams, bool] = (MaskParams(), False)

        self.outputs = OutputManager(store.settings.outputs)
        self.audio: AudioInput | None = None
        self.midi: MidiInput | None = None

        self.frame = 0
        self.fps = 0.0
        self.tick_ms = 0.0
        self.peaks_total = 0
        self._last_save_version = self.macros.version
        self._last_save_time = time.monotonic()
        self._thread: threading.Thread | None = None
        self._stop = threading.Event()

        self.rebuild_audio_analysis()
        self.rebuild_masks()
        self.rebuild_fixtures()

    # ------------------------------------------------------------------ building
    def rebuild_audio_analysis(self) -> None:
        with self.lock:
            a = self.store.settings.audio
            self.analyzer = SpectrumAnalyzer(a)
            weights = trigger_weights(self.analyzer.layout.centres, a.trigger_full_hz, a.trigger_zero_hz)
            self.features = AudioFeatures(
                a.bands, weights, normalisation_decay=a.normalisation_decay, normalisation_floor=a.normalisation_floor
            )
            self.peaks = PeaksMap(a.bands)

    def rebuild_masks(self) -> None:
        with self.lock:
            m = self.store.settings.masks
            self.masks = MaskGenerator(transition_s=m.transition_s)

    def rebuild_fixtures(self) -> None:
        with self.lock:
            fixtures = []
            for inst in self.store.rig.fixtures:
                ftype = self.store.fixture_types.get(inst.type)
                if ftype is None or not inst.enabled:
                    continue
                fixtures.append(Fixture(inst, ftype))
            self.fixtures = fixtures
            sizes = [f.pixels for f in fixtures]
            self._offsets = np.concatenate(([0], np.cumsum(sizes))).astype(int)
            self._all_u = np.concatenate([f.uv[:, 0] for f in fixtures]) if fixtures else np.zeros(0)
            self._all_v = np.concatenate([f.uv[:, 1] for f in fixtures]) if fixtures else np.zeros(0)

    def start_io(self) -> None:
        if not self.enable_hardware:
            return
        s = self.store.settings
        self.outputs.restart(s.outputs)
        self.restart_audio()
        self.restart_midi()

    def restart_audio(self) -> None:
        if self.audio is not None:
            self.audio.stop()
        self.audio = None
        if not self.enable_hardware:
            return
        a = self.store.settings.audio
        self.rebuild_audio_analysis()
        self.audio = AudioInput(a.device, a.channels, a.sample_rate, lambda s: self.analyzer.push(s))
        self.audio.start()

    def restart_midi(self) -> None:
        if self.midi is not None:
            self.midi.stop()
        self.midi = None
        if not self.enable_hardware:
            return
        self.midi = MidiInput(self.store.controller, self.store.settings.midi_input, self.macros, ignored=self.store.dimmer_unassigned)
        self.midi.start()

    # ------------------------------------------------------------------ frame
    def tick(self, dt: float) -> None:
        t0 = time.perf_counter()
        with self.lock:
            m = self.macros
            s = self.store.settings
            self._handle_buttons()
            m.apply_settled(time.monotonic(), s.midi_settle_s)

            levels = self.analyzer.read_frame()
            self.features.update(levels)

            self.phase.update(
                dt,
                self.features.trigger_fraction,
                strobo_control=m.control("Strobo"),
                strobo_decay=m.value("Strobo Decay"),
                idle_attack=m.value("Idle Attack"),
                manual=m.on("Manual Strobo"),
            )
            on_peak = self.phase.on_peak
            if on_peak:
                self.peaks_total += 1

            params = MaskParams(
                preset=m.radio_index("preset"),
                shader_param=m.control("Shader Param"),
                line_falloff=s.masks.line_falloff,
            )
            self.masks.update(dt, params.preset, m.value("Shader Speed"), params.shader_param, on_peak)
            self.peaks.update(self.features.peak, self.features.peak_score, m.control("Audio Reactivity"))
            self.colors.update(on_peak, m, s.auto_colors)
            symmetry = m.on("Vertical Symmetry")

            mask = mixed_mask(self.masks, self.peaks, self._all_u, self._all_v, params, symmetry)
            groups = {
                "A": GroupBrightness(
                    m.value("Strobo Brightness") * m.control("Strobo Bright. A"),
                    m.value("Idle Brightness") * m.control("Idle Bright. A"),
                ),
                "B": GroupBrightness(
                    m.value("Strobo Brightness") * m.control("Strobo Bright. B"),
                    m.value("Idle Brightness") * m.control("Idle Bright. B"),
                ),
            }
            universes: dict[int, bytearray] = {}
            v2_strips: list[list[int]] = []
            for i, fx in enumerate(self.fixtures):
                fx.update(mask[self._offsets[i] : self._offsets[i + 1]], self.phase.phase, self.colors, groups[fx.inst.group], m)
                if fx.ftype.transport == "pitchpls_v2":
                    fx.last_output = fx.pixel_bytes("RGB")
                    v2_strips.append(fx.last_output)
                    continue
                data = fx.dmx_bytes(m)
                fx.last_output = data
                uni = universes.setdefault(fx.inst.universe, bytearray(512))
                start = fx.inst.address - 1
                end = min(start + len(data), 512)
                uni[start:end] = bytes(data[: end - start])
            self.fog.update(dt, s.fog.machines, m, universes)
            self.universes, self.v2_strips = universes, v2_strips

            self._preview_inputs = (params, symmetry)

        if self.enable_hardware:
            self.outputs.send(universes, v2_strips)
        self._autosave_macros()
        self.frame += 1
        self.tick_ms = (time.perf_counter() - t0) * 1000.0

    def _handle_buttons(self) -> None:
        for name in self.macros.take_buttons():
            parts = name.split()
            if len(parts) == 3 and parts[0] == "Scene" and parts[1].isdigit():
                index = int(parts[1]) - 1
                if parts[2] == "Save":
                    self.save_scene(index)
                elif parts[2] == "Load":
                    self.load_scene(index)

    # ------------------------------------------------------------------ scenes & persistence
    def save_scene(self, index: int, name: str | None = None) -> None:
        values = {k: v for k, v in self.macros.snapshot().items() if self.macros.defs[k].page not in ("scenes", "system")}
        old = self.store.load_scene(index)
        scene = Scene(name=name or (old.name if old and old.name else f"Scene {index + 1}"), values=values)
        self.store.save_scene(index, scene)
        log.info("saved scene %d", index + 1)

    def load_scene(self, index: int) -> bool:
        scene = self.store.load_scene(index)
        if scene is None:
            log.warning("scene %d does not exist", index + 1)
            return False
        self.macros.load(scene.values, source=f"scene {index + 1}")
        log.info("loaded scene %d (%s)", index + 1, scene.name)
        return True

    def _restore_macros(self) -> None:
        path = self.store.state_dir / "macros.json"
        if path.exists():
            state = load_model(path, MacroState)
            if state is not None:
                self.macros.load(state.values, source=str(path))
                log.info("restored macro values from %s", path)

    def _autosave_macros(self, force: bool = False) -> None:
        now = time.monotonic()
        if not force and (self.macros.version == self._last_save_version or now - self._last_save_time < 5.0):
            return
        self._last_save_version = self.macros.version
        self._last_save_time = now
        try:
            save_model(self.store.state_dir / "macros.json", MacroState(name="autosave", values=self.macros.snapshot()))
        except OSError as exc:
            log.warning("macro autosave failed: %s", exc)

    # ------------------------------------------------------------------ thread
    def start(self) -> None:
        self.start_io()
        self._stop.clear()
        self._thread = threading.Thread(target=self._run, name="engine", daemon=True)
        self._thread.start()

    def stop(self) -> None:
        self._stop.set()
        if self._thread is not None:
            self._thread.join(timeout=2)
        self._autosave_macros(force=True)
        if self.audio is not None:
            self.audio.stop()
        if self.midi is not None:
            self.midi.stop()
        self.outputs.stop()

    def _run(self) -> None:
        period = 1.0 / max(self.store.settings.fps, 1.0)
        next_time = time.perf_counter()
        last = next_time
        fps_count, fps_time = 0, next_time
        while not self._stop.is_set():
            now = time.perf_counter()
            dt = min(now - last, 0.25)
            last = now
            try:
                self.tick(dt)
            except Exception:  # noqa: BLE001 - keep the show running, but log every failure
                log.exception("engine tick failed")
            fps_count += 1
            if now - fps_time >= 1.0:
                self.fps = fps_count / (now - fps_time)
                fps_count, fps_time = 0, now
            period = 1.0 / max(self.store.settings.fps, 1.0)
            next_time += period
            delay = next_time - time.perf_counter()
            if delay > 0:
                time.sleep(delay)
            else:
                next_time = time.perf_counter()  # running late: don't try to catch up

    # ------------------------------------------------------------------ state for the UI
    def render_preview(self) -> bytes:
        """256×256 grayscale image of the current scene.

        Copies the mask state under the lock and renders outside it, so the
        (up to ~20 ms) preview never delays the engine frame / DMX output.
        """
        with self.lock:
            masks = copy.deepcopy(self.masks)
            peaks = copy.deepcopy(self.peaks)
            params, symmetry = self._preview_inputs
        img = mixed_mask(masks, peaks, self.preview_u, self.preview_v, params, symmetry)
        return (np.clip(img, 0.0, 1.0) * 255).astype(np.uint8).tobytes()

    def state(self) -> dict:
        with self.lock:
            fixtures = []
            for fx in self.fixtures:
                fixtures.append(
                    {
                        "name": fx.inst.name,
                        "type": fx.inst.type,
                        "group": fx.inst.group,
                        "transport": fx.ftype.transport,
                        "universe": fx.inst.universe,
                        "address": fx.inst.address,
                        "uv": np.round(fx.uv, 4).tolist(),
                        "rgb": (np.clip(fx.rgb, 0, 1) * 255).astype(int).tolist(),
                        "output": fx.last_output,
                    }
                )
            ca, cb = self.colors.a, self.colors.b
            rgb_a = hsv_to_rgb(np.array(ca.h), np.array(ca.s), np.array(ca.b)).tolist()
            rgb_b = hsv_to_rgb(np.array(cb.h), np.array(cb.s), np.array(cb.b)).tolist()
            return {
                "frame": self.frame,
                "fps": round(self.fps, 1),
                "tick_ms": round(self.tick_ms, 2),
                "macros": self.macros.snapshot(),
                "pending": self.macros.pending(),
                "phase": round(self.phase.phase, 4),
                "strobo": round(self.phase.strobo, 4),
                "idle": round(self.phase.idle, 4),
                "peaks_total": self.peaks_total,
                "trigger": round(self.features.trigger_fraction, 4),
                "bands": np.round(self.features.values, 3).tolist(),
                "band_peaks": self.features.peak.astype(int).tolist(),
                "peaks_map": np.round(self.peaks.blue, 3).tolist(),
                "preset": PRESET_NAMES[self.masks.current],
                "colors": {"A": rgb_a, "B": rgb_b},
                "colors_hsb": {"A": [ca.h, ca.s, ca.b], "B": [cb.h, cb.s, cb.b]},
                "fixtures": fixtures,
                "fog": self.fog.active,
                "io": {
                    "outputs": self.outputs.status(),
                    "audio": self.audio.status() if self.audio else None,
                    "midi": self.midi.status() if self.midi else None,
                },
            }

    def universe_dump(self) -> dict[str, list[int]]:
        with self.lock:
            return {str(k): list(v) for k, v in self.universes.items()}


