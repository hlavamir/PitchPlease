import mido

from pitchcontrol.config.models import Controller, MidiMapping
from pitchcontrol.engine.macros import MacroBank
from pitchcontrol.io.midi_in import MidiInput


def make():
    ctrl = Controller(name="t", channel=12, mappings=[MidiMapping(cc=5, macro="Strobo"), MidiMapping(cc=6, macro="Swap Colors", mode="toggle")])
    macros = MacroBank()
    return MidiInput(ctrl, None, macros), macros


def test_mapped_cc_sets_macro():
    midi, macros = make()
    midi.handle(mido.Message("control_change", channel=11, control=5, value=127))
    assert macros.control("Strobo") == 1.0
    assert midi.recent[-1]["macro"] == "Strobo"


def test_toggle_mode():
    midi, macros = make()
    midi.handle(mido.Message("control_change", channel=11, control=6, value=127))
    midi.handle(mido.Message("control_change", channel=11, control=6, value=0))
    assert macros.on("Swap Colors")


def test_wrong_channel_is_reported_not_applied():
    midi, macros = make()
    midi.handle(mido.Message("control_change", channel=0, control=5, value=127))
    assert macros.control("Strobo") == 0.0
    assert "mapping expects 12" in midi.recent[-1]["note"]
    assert midi.status()["received"] == 1


def test_colour_knob_applies_once_it_rests():
    ctrl = Controller(name="t", channel=12, mappings=[MidiMapping(cc=33, macro="Hue A")])
    macros = MacroBank()
    midi = MidiInput(ctrl, None, macros)
    for v in (10, 40, 90):  # turning the knob
        midi.handle(mido.Message("control_change", channel=11, control=33, value=v))
    assert macros.control("Hue A") == 0.0  # nothing applied while turning
    assert macros.pending()["Hue A"] == 90 / 127
    import time

    macros.apply_settled(time.monotonic() + 1.0, settle_s=0.4)
    assert macros.control("Hue A") == 90 / 127 and macros.pending() == {}


def _paged():
    ctrl = Controller(
        name="t",
        channel=13,
        pages={
            "general": [MidiMapping(cc=29, macro="Strobo Decay")],
            "dimmers": [MidiMapping(cc=29, macro="Dimmer 01")],
        },
        page_knob=13,
    )
    macros = MacroBank()
    return MidiInput(ctrl, None, macros), macros


def test_same_control_drives_the_active_page():
    midi, macros = _paged()
    midi.handle(mido.Message("control_change", channel=12, control=29, value=127))
    assert macros.control("Strobo Decay") == 1.0
    macros.set_control_page("dimmers")
    midi.handle(mido.Message("control_change", channel=12, control=29, value=0))
    assert macros.control("Dimmer 01") == 0.0 and macros.control("Strobo Decay") == 1.0


def test_page_knob_switches_pages():
    midi, macros = _paged()
    for v in (60, 61, 62):  # turning up
        midi.handle(mido.Message("control_change", channel=12, control=13, value=v))
    assert macros.control_page == "dimmers"
    midi.handle(mido.Message("control_change", channel=12, control=13, value=50))  # turning down
    assert macros.control_page == "general"


def test_shipped_lcxl3_mapping_matches_ui_layout(store):
    pages = store.controller.pages
    assert [m.macro for m in pages["general"][:8]][5] == "Saturation A"
    assert pages["dimmers"][8].cc == 5 and pages["dimmers"][8].macro == "Dimmer 09"
    assert store.controller.page_knob == 13
