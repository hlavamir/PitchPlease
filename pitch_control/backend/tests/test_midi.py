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
