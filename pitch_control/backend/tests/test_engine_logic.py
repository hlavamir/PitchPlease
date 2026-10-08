import math

import numpy as np
import pytest

from pitchcontrol.config.models import AudioSettings, FixtureInstance, IdleMaskRange
from pitchcontrol.engine.audio_analysis import AudioFeatures, SpectrumAnalyzer, make_layout, trigger_weights
from pitchcontrol.engine.colors import GroupColors
from pitchcontrol.engine.fixtures import Fixture, GroupBrightness, pixel_positions
from pitchcontrol.engine.macros import MacroBank, from_legacy_values, quantise
from pitchcontrol.engine.masks import MaskGenerator, MaskParams, PeaksMap, mixed_mask, sample_linear_clamp
from pitchcontrol.engine.noise import noise_mask
from pitchcontrol.engine.phase import PhaseTracker


# ---------------------------------------------------------------- audio


def test_band_layout():
    layout = make_layout(AudioSettings())
    assert layout.count == 32
    assert layout.edges[0] == pytest.approx(35) and layout.edges[-1] == pytest.approx(10000)
    assert np.all(np.diff(layout.edges) >= 48000 / 2048 - 1e-9)  # every band ≥ one FFT bin
    assert np.all(layout.bin_hi > layout.bin_lo)


def test_trigger_weights_linear_over_octaves():
    w = trigger_weights(np.array([50, 100, 300, 1000, 5000, 8000.0]), 100, 5000)
    assert w[0] == 1 and w[1] == 1 and w[4] == 0 and w[5] == 0
    span = math.log2(50)
    assert w[2] == pytest.approx(1 - math.log2(3) / span)  # ≈ 0.72 at 300 Hz
    assert w[3] == pytest.approx(1 - math.log2(10) / span)  # ≈ 0.41 at 1 kHz


def test_kick_lands_in_low_bands():
    s = AudioSettings()
    an = SpectrumAnalyzer(s)
    t = np.arange(s.sample_rate // 4) / s.sample_rate
    an.push(0.5 * np.sin(2 * np.pi * 55 * t))  # 55 Hz "kick"
    levels = an.read_frame()
    assert levels.argmax() == np.searchsorted(an.layout.edges, 55) - 1
    assert levels[an.layout.centres > 1000].max() < 0.5 * levels.max()


def test_per_band_normalisation_and_peaks():
    f = AudioFeatures(4, np.ones(4))
    f.update(np.array([0.9, 0.3, 0.3, 0.0]))
    assert f.values[0] == pytest.approx(1.0) and f.values[1] == pytest.approx(1.0)  # each band scales to its own max
    assert f.values[3] == 0.0
    assert f.peak[:3].all() and not f.peak[3]
    assert f.trigger_fraction == pytest.approx(0.75)


# ---------------------------------------------------------------- macros & phase


def test_macro_range_and_quantise():
    m = MacroBank()
    m.set("Strobo Decay", 1.0)
    assert m.value("Strobo Decay") == pytest.approx(3.0)
    assert quantise(0.5, 2) == 1.0 and quantise(0.49, 2) == 0.0


def test_radio_group():
    m = MacroBank()
    m.set("Preset C", 1)
    assert m.radio_index("preset") == 2 and not m.on("Preset A")


def test_legacy_values_mapping():
    values = [0.0] * 128
    values[5] = 0.8  # Glitches
    values[32] = 0.25  # Dimmer 01
    out = from_legacy_values(values)
    assert out["Audio Reactivity"] == 0.8 and out["Dimmer 01"] == 0.25


def test_phase_cycle():
    p = PhaseTracker()
    p.update(0.025, trigger_fraction=1.0, strobo_control=1.0, strobo_decay=1.0, idle_attack=2.0, manual=False)
    assert p.on_peak and p.phase == 0.0 and p.strobo == 1.0
    p.update(1.0, 0.0, 1.0, 1.0, 2.0, False)
    assert p.phase == pytest.approx(0.5) and p.strobo == 0.0 and p.idle == 0.0
    p.update(2.0, 0.0, 1.0, 1.0, 2.0, False)
    assert p.phase == pytest.approx(1.0)
    # minimum time between peaks: at Strobo = 1 it is 0.5 s
    p.update(0.1, 1.0, 1.0, 1.0, 2.0, False)
    assert p.on_peak
    p.update(0.1, 1.0, 1.0, 1.0, 2.0, False)
    assert not p.on_peak


# ---------------------------------------------------------------- fixtures


def _fixture(store, **kw):
    inst = FixtureInstance(name="t", type="rgb_panel", **kw)
    return Fixture(inst, store.fixture_types["rgb_panel"])


def test_strobo_fixture_shows_strobo_then_idle(store):
    colors, macros = GroupColors(), MacroBank()
    colors.update(False, macros, [])
    fx = _fixture(store, react_to_strobo=True)
    g = GroupBrightness(strobo=1.0, idle=1.0)
    fx.update(np.array([1.0]), 0.0, colors, g, macros)  # at the peak: full strobo (white)
    assert np.allclose(fx.rgb, 1.0)
    fx.update(np.array([1.0]), 0.5, colors, g, macros)  # strobo over, idle not started: black
    assert np.allclose(fx.rgb, 0.0)
    fx.update(np.array([1.0]), 1.0, colors, g, macros)  # idle: group colour
    assert fx.rgb.max() == pytest.approx(1.0)


def test_non_strobo_fixture_goes_dark_on_peak(store):
    colors, macros = GroupColors(), MacroBank()
    colors.update(False, macros, [])
    fx = _fixture(store, react_to_strobo=False)
    g = GroupBrightness(strobo=1.0, idle=1.0)
    fx.update(np.array([1.0]), 0.0, colors, g, macros)
    assert np.allclose(fx.rgb, 0.0)
    fx.update(np.array([1.0]), 0.25, colors, g, macros)
    assert fx.rgb.max() == pytest.approx(0.5)
    fx.update(np.array([1.0]), 0.5, colors, g, macros)
    assert fx.rgb.max() == pytest.approx(1.0)


def test_invert_discoball_range_only_with_macro(store):
    colors, macros = GroupColors(), MacroBank()
    colors.update(False, macros, [])
    fx = _fixture(store, idle_mask_range=IdleMaskRange(min=1.0, max=0.0, curve=0.0, macro="Invert Discoball"))
    g = GroupBrightness(1.0, 1.0)
    fx.update(np.array([1.0]), 1.0, colors, g, macros)
    assert fx.rgb.max() == pytest.approx(1.0)
    macros.set("Invert Discoball", 1.0)
    fx.update(np.array([1.0]), 1.0, colors, g, macros)
    assert fx.rgb.max() == pytest.approx(0.0)


def test_gamma_on_output_per_channel(store):
    colors, macros = GroupColors(), MacroBank()
    colors.update(False, macros, [])
    g = GroupBrightness(1.0, 1.0)
    # the colour stays perceptual (preview); the device curve is applied to the output bytes
    fx = _fixture(store, gamma=2.0, saturation_source="const", saturation=0.5)
    fx.update(np.array([1.0]), 1.0, colors, g, macros)
    assert fx.rgb.min() == pytest.approx(0.5)
    assert min(fx.pixel_bytes("RGB")) == round(0.25 * 255)  # per channel: 0.5 ** 2
    fx = _fixture(store, gamma=1.0, saturation_source="const", saturation=0.5)
    fx.update(np.array([1.0]), 1.0, colors, g, macros)
    assert min(fx.pixel_bytes("RGB")) == round(0.5 * 255)  # 1 = unchanged


def test_rgbw_white_taken_after_gamma(store):
    colors, macros = GroupColors(), MacroBank()
    colors.update(False, macros, [])
    fx = _fixture(store, gamma=2.0, saturation_source="const", saturation=0.0)  # white
    fx.update(np.array([0.5]), 1.0, colors, GroupBrightness(1.0, 1.0), macros)
    r, g_, b, w = fx.pixel_bytes("RGBW")
    assert (r, g_, b) == (0, 0, 0) and w == round(0.25 * 255)


def test_pixel_spread_vertical():
    inst = FixtureInstance(position=(0.5, 0.5), rotation=270, length=0.6)
    uv = pixel_positions(inst, 4)
    assert np.allclose(uv[:, 0], 0.5)
    assert uv[0, 1] == pytest.approx(0.725) and uv[-1, 1] == pytest.approx(0.275)


# ---------------------------------------------------------------- masks


def test_masks_are_in_range_and_crossfade():
    gen = MaskGenerator(transition_s=2.0)
    u, v = np.meshgrid(np.linspace(0, 1, 32), np.linspace(0, 1, 32))
    p = MaskParams()
    for preset in range(4):
        out = gen.evaluate_preset(preset, u, v, p)
        assert out.min() >= 0 and out.max() <= 1
    gen.update(0.0, 0, 0.0, 0.0, False)
    gen.update(1.0, 2, 0.0, 0.0, False)  # switch to preset 2 and advance half the transition
    assert gen.transition == pytest.approx(0.5)
    blended = gen.evaluate(u, v, p)
    expected = 0.5 * (gen.evaluate_preset(0, u, v, p) + gen.evaluate_preset(2, u, v, p))
    assert np.allclose(blended, expected)


def test_noise_is_deterministic_and_varied():
    u, v = np.meshgrid(np.linspace(0, 1, 64), np.linspace(0, 1, 64))
    a = noise_mask(u, v, time=3.0)
    assert np.array_equal(a, noise_mask(u, v, time=3.0))
    assert a.std() > 0.05


def test_audio_reactivity_zero_means_raw_mask():
    peaks = PeaksMap(32)
    peaks.update(np.ones(32, dtype=bool), np.ones(32), reactivity=0.0)
    mask = np.linspace(0, 1, 11)
    assert np.allclose(peaks.apply(mask), mask)
    peaks.update(np.ones(32, dtype=bool), np.ones(32), reactivity=1.0)
    assert peaks.control == pytest.approx(1.0)


def test_symmetry_is_left_right_average():
    gen = MaskGenerator()
    peaks = PeaksMap(32)
    p = MaskParams(preset=0, shader_param=1.0)  # horizontal gradient: f(u) = u
    out = mixed_mask(gen, peaks, np.array([0.1, 0.9]), np.array([0.5, 0.5]), p, symmetry=True)
    assert np.allclose(out, 0.5)


def test_texture_sampling():
    table = np.array([0.0, 1.0])
    assert sample_linear_clamp(table, np.array([0.0, 0.25, 0.5, 0.75, 1.0])).tolist() == [0.0, 0.0, 0.5, 1.0, 1.0]
