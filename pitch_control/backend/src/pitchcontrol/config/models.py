"""Configuration models.

Every model allows unknown keys (``extra="allow"``) so that a typo never stops the
show; the loader reports unknown keys to the log instead (see ``loader.py``).
Missing keys are filled with the defaults defined here.
"""

from __future__ import annotations

import logging
from typing import Generic, Literal, TypeVar

from pydantic import BaseModel, ConfigDict, Field, field_validator, model_validator

log = logging.getLogger(__name__)


def _merge_legacy_gamma(data, where: str):
    """Old configs had brightness_gamma (on the HSV value) and rgb_gamma (per channel); both are now
    one per-channel ``gamma``. Their product is the closest single curve."""
    if not isinstance(data, dict) or not ({"brightness_gamma", "rgb_gamma"} & data.keys()):
        return data
    data = dict(data)
    old = {k: data.pop(k) for k in ("brightness_gamma", "rgb_gamma") if k in data}
    if "gamma" not in data:
        values = [float(v) for v in old.values() if v is not None]
        if values:
            g = 1.0
            for v in values:
                g *= v
            data["gamma"] = g
        log.info("%s: %s replaced by gamma = %s (one per-channel gamma now)", where, ", ".join(old), data.get("gamma"))
    return data


class Model(BaseModel):
    model_config = ConfigDict(extra="allow", populate_by_name=True)


# --------------------------------------------------------------------------- colours


class HSB(Model):
    """A colour as hue / saturation / brightness, all 0..1 (hue wraps)."""

    h: float = 0.0
    s: float = 1.0
    b: float = 1.0


# --------------------------------------------------------------------------- fixture types

PixelFormat = Literal["R", "RGB", "RGBW"]


class Shutter(Model):
    """Shutter / strobe channel values used for "real strobo" (see port-design, Future: Hardware Strobe)."""

    open: int = 0
    strobo: int = 255


class ChannelSlot(Model):
    """One entry of a fixture profile.

    Exactly one of ``value`` (constant), ``pixels`` (the pixel block), ``macro``
    (a macro's value scaled to 0..255) or ``shutter`` must be given.
    """

    name: str | None = None
    value: int | None = Field(default=None, ge=0, le=255)
    pixels: PixelFormat | None = None
    macro: str | None = None
    shutter: Shutter | None = None

    @model_validator(mode="after")
    def _exactly_one_kind(self) -> "ChannelSlot":
        kinds = [self.value is not None, self.pixels is not None, self.macro is not None, self.shutter is not None]
        if sum(kinds) != 1:
            raise ValueError("a channel needs exactly one of: value, pixels, macro, shutter")
        return self

    @property
    def kind(self) -> str:
        if self.value is not None:
            return "value"
        if self.pixels is not None:
            return "pixels"
        if self.macro is not None:
            return "macro"
        return "shutter"


class FixtureType(Model):
    name: str = ""
    description: str = ""
    transport: Literal["dmx", "pitchpls_v2"] = "dmx"
    pixels: int = Field(default=1, ge=1)
    channels: list[ChannelSlot] = Field(default_factory=lambda: [ChannelSlot(pixels="RGB")])
    # Decodes the perceptual values the engine works with into what the device expects, per output
    # channel: device value = value ** gamma. 1 = send perceptual values unchanged, for devices that
    # decode themselves (PitchPlease v2 / v3 firmware apply 2.2). Must be > 0 (an invalid value falls
    # back to 1 with a warning).
    gamma: float = 1.0
    strobo_color: HSB = Field(default_factory=lambda: HSB(h=0, s=0, b=1))
    # Whether a fixture flashes on strobo peaks is a rig setting (FixtureInstance.react_to_strobo).
    # Type files written before 2026-10-08 still say it; that value only fills in rig fixtures that
    # don't set it themselves (ConfigStore.load_rig), and is not written back.
    legacy_react_to_strobo: bool | None = Field(default=None, exclude=True)

    @model_validator(mode="before")
    @classmethod
    def _legacy(cls, data):
        data = _merge_legacy_gamma(data, f"fixture type {data.get('name', '') if isinstance(data, dict) else ''}".strip())
        if isinstance(data, dict) and "react_to_strobo" in data:
            data = dict(data)
            data["legacy_react_to_strobo"] = data.pop("react_to_strobo")
        return data

    @field_validator("gamma", mode="before")
    @classmethod
    def _gamma_positive(cls, v):
        if v is None or float(v) <= 0:
            log.warning("fixture type: gamma must be > 0 (got %r), using 1", v)
            return 1.0
        return v

    def channel_count(self, pixels: int | None = None) -> int:
        px = pixels if pixels is not None else self.pixels
        total = 0
        for ch in self.channels:
            total += px * len(ch.pixels) if ch.pixels else 1
        return total


# --------------------------------------------------------------------------- rigs

T = TypeVar("T")


class Override(Model, Generic[T]):
    """A fixture's override of a fixture-type value. Switched off, the type's value is used but the
    override value is kept, so switching it on again restores it (the UI's override checkbox)."""

    enabled: bool = True
    value: T


OVERRIDABLE = ("gamma", "strobo_color")


def _wrap_plain_overrides(data, where: str):
    """Old rigs stored overrides as plain values ("gamma": 2.0, "channel_values": {"mode": 2});
    they become enabled overrides. The per-fixture pixel count is no longer overridable."""
    if not isinstance(data, dict):
        return data
    data = dict(data)
    for key in OVERRIDABLE:
        v = data.get(key)
        if v is not None and not (isinstance(v, dict) and "value" in v):
            data[key] = {"enabled": True, "value": v}
    cv = data.get("channel_values")
    if isinstance(cv, dict):
        data["channel_values"] = {
            k: v if isinstance(v, dict) and "value" in v else {"enabled": True, "value": v} for k, v in cv.items()
        }
    if data.get("pixels") is not None:
        log.warning("%s: a per-fixture pixel count is no longer supported (ignored); use a fixture type with that many pixels", where)
    data.pop("pixels", None)
    return data



class IdleMaskRange(Model):
    """Remap of the sampled mask value: ``lerp(min, max, mask ** (2 ** curve))``.

    If ``macro`` is set, the range only applies while that macro is on (> 0.5),
    otherwise the identity range is used. This is how "Invert Discoball" works.
    """

    min: float = 0.0
    max: float = 1.0
    curve: float = 0.0
    macro: str | None = None


class FixtureInstance(Model):
    name: str = ""
    type: str = ""
    enabled: bool = True
    group: Literal["A", "B"] = "A"

    # DMX placement (1-based address, as printed on fixtures)
    universe: int = Field(default=0, ge=0)
    address: int = Field(default=1, ge=1, le=512)

    # placement in the square UV scene (u right, v down, 0..1)
    position: tuple[float, float] = (0.5, 0.5)
    rotation: float = 0.0  # degrees, clockwise on screen (90 = down, 270 = vertical with the first pixel at the bottom)
    length: float = 0.0  # pixels are spread along this length, centred on position
    pixel_positions: list[tuple[float, float]] | None = None  # explicit positions override the spread

    # overrides of fixture-type values (None = never overridden; switched off = type's value)
    gamma: Override[float] | None = None  # > 0
    strobo_color: Override[HSB] | None = None
    channel_values: dict[str, Override[int]] = Field(default_factory=dict)  # constant channels by name
    react_to_strobo: bool = False  # flash on strobo peaks (a rig setting)
    real_strobo: bool = False  # use the type's shutter channel on peaks (only for types with one)

    dimmer_macro: str | None = None

    @model_validator(mode="before")
    @classmethod
    def _legacy(cls, data):
        where = f"fixture {data.get('name', '') if isinstance(data, dict) else ''}".strip()
        data = _wrap_plain_overrides(_merge_legacy_gamma(data, where), where)
        # react_to_strobo used to be a type value with a per-fixture override: an enabled override
        # becomes the fixture's value; a switched-off or missing one is left unset, so load_rig
        # fills it in from the old type value
        v = data.get("react_to_strobo") if isinstance(data, dict) else None
        if isinstance(v, dict):
            data = dict(data)
            if v.get("enabled", True):
                data["react_to_strobo"] = v.get("value")
            else:
                data.pop("react_to_strobo")
        return data

    @field_validator("gamma", mode="after")
    @classmethod
    def _gamma_positive(cls, v):
        if v is not None and v.value <= 0:
            log.warning("fixture: gamma override must be > 0 (got %r), dropped", v.value)
            return None
        return v

    @field_validator("channel_values", mode="after")
    @classmethod
    def _channel_values_in_range(cls, v):
        for name, o in v.items():
            if not 0 <= o.value <= 255:
                raise ValueError(f"channel value '{name}' must be 0–255, got {o.value}")
        return v

    def override(self, key: str, default):
        """The fixture's value for an overridable type property."""
        o = getattr(self, key)
        return o.value if o is not None and o.enabled else default

    def channel_value(self, name: str | None, default: int) -> int:
        o = self.channel_values.get(name) if name else None
        return o.value if o is not None and o.enabled else default

    # colour sources (see port-design, Colour and Brightness Model)
    hue_source: Literal["group", "A", "B", "const"] = "group"
    hue: float = 0.0
    saturation_source: Literal["group", "A", "B", "const"] = "group"
    saturation: float = 1.0
    brightness_source: Literal["pipeline", "const"] = "pipeline"
    brightness: float = 1.0

    idle_mask_range: IdleMaskRange = Field(default_factory=IdleMaskRange)


class Rig(Model):
    name: str = ""
    description: str = ""
    fixtures: list[FixtureInstance] = Field(default_factory=list)
    # names of the dimmer macros in this rig ("Dimmer 03" → "D Pinspots"); without a name the UI
    # shows the macro name. Which dimmer a fixture follows is its dimmer_macro; a dimmer that no
    # fixture uses is unassigned: disabled in the UI and ignored by MIDI.
    dimmer_names: dict[str, str] = Field(default_factory=dict)


# --------------------------------------------------------------------------- settings


class DeviceRef(Model):
    """A USB serial device, matched by serial number + VID:PID first, port path as fallback."""

    serial_number: str | None = None
    vid: int | None = None
    pid: int | None = None
    description: str | None = None
    port: str | None = None


class AudioSettings(Model):
    device: str | None = None  # name (substring) of the input device; None = system default
    channels: list[int] = Field(default_factory=lambda: [1, 2])  # 1-based input channels, summed
    gain: float = 1.0
    sample_rate: int = 48000
    fft_size: int = 2048
    hop: int = 512
    bands: int = 32
    fmin: float = 35.0
    fmax: float = 10000.0
    floor_db: float = -80.0
    range_db: float = 80.0
    release_s: float = 0.08
    normalisation_decay: float = 0.998  # per frame
    normalisation_floor: float = 0.25  # stops quiet bands (noise) from being scaled up to full level
    trigger_full_hz: float = 100.0
    trigger_zero_hz: float = 5000.0


class EnttecSettings(Model):
    enabled: bool = False
    device: DeviceRef = Field(default_factory=DeviceRef)
    universe: int = 0


class ArtNetTarget(Model):
    universe: int = 0  # internal universe
    ip: str = "127.255.255.255"
    artnet_universe: int | None = None  # defaults to ``universe``


class ArtNetSettings(Model):
    enabled: bool = False
    targets: list[ArtNetTarget] = Field(default_factory=list)


class PitchPlsV2Settings(Model):
    enabled: bool = False
    device: DeviceRef = Field(default_factory=DeviceRef)
    baudrate: int = 921600
    mode: int = 0  # mirror mode byte understood by the v2.2 firmware
    strips: int = 4
    pixels_per_strip: int = 19  # the firmware mirrors these to 38 LEDs


class OutputSettings(Model):
    enttec: EnttecSettings = Field(default_factory=EnttecSettings)
    artnet: ArtNetSettings = Field(default_factory=ArtNetSettings)
    pitchpls_v2: PitchPlsV2Settings = Field(default_factory=PitchPlsV2Settings)


class FogMachine(Model):
    name: str = "Fog"
    enabled: bool = True
    universe: int = 0
    channel: int = Field(default=1, ge=1, le=512)
    on_value: int = Field(default=255, ge=0, le=255)
    off_value: int = Field(default=0, ge=0, le=255)
    interval_s: float = 60.0
    duration_s: float = 4.0
    manual_macro: str | None = "Fog Machine"


class FogSettings(Model):
    machines: list[FogMachine] = Field(default_factory=list)


class MaskSettings(Model):
    line_falloff: float = 0.12  # soft edge width of the line masks, in UV units
    transition_s: float = 2.5  # preset crossfade time


def _default_palette() -> list[HSB]:
    hues = [0, 0.041666668, 0.097222224, 0.30555555, 0.375, 0.6388889, 0.6805556, 0.7222222, 0.7777778]
    return [HSB(h=h, s=1, b=1) for h in hues]


class UiSettings(Model):
    """Appearance of the web UI, chosen on the Settings page."""

    ink: Literal["grey", "amber", "phosphor"] = "grey"
    glow: float = Field(default=1.0, ge=0.0, le=1.0)
    brightness: float = Field(default=1.0, ge=0.4, le=1.0)  # dims the ink: less light at the DJ booth
    key_hints: bool = True
    start_fullscreen: bool = False  # desktop app: open in full screen
    scale: float = Field(default=1.0, ge=0.6, le=1.5)  # UI zoom; 1 = the 1512×915 design size


class Settings(Model):
    fps: float = 40.0
    preview_fps: float = 15.0
    active_rig: str = "default"
    active_controller: str | None = "lcxl3"
    midi_input: str | None = None  # MIDI input port name (substring); None = take it from the controller file
    midi_settle_s: float = 0.4  # hue/saturation knobs apply once they rest this long
    audio: AudioSettings = Field(default_factory=AudioSettings)
    outputs: OutputSettings = Field(default_factory=OutputSettings)
    fog: FogSettings = Field(default_factory=FogSettings)
    masks: MaskSettings = Field(default_factory=MaskSettings)
    auto_colors: list[HSB] = Field(default_factory=_default_palette)
    ui: UiSettings = Field(default_factory=UiSettings)


# --------------------------------------------------------------------------- MIDI controllers


class MidiMapping(Model):
    cc: int = Field(ge=0, le=127)
    macro: str
    # absolute: CC value / 127 -> control value; toggle: flips on press; momentary: on while held
    mode: Literal["absolute", "toggle", "momentary"] = "absolute"


class Controller(Model):
    name: str = ""
    port_match: str = ""  # substring of the MIDI port name
    channel: int = Field(default=1, ge=1, le=16)  # 1-based MIDI channel
    mappings: list[MidiMapping] = Field(default_factory=list)  # active on every page
    # per control page ("general", "dimmers"): the same physical controls drive the active page,
    # as in vvvv; page mappings win over the global ones
    pages: dict[str, list[MidiMapping]] = Field(default_factory=dict)
    # CC of an absolute knob that switches pages: turning it up = next page, down = previous page
    page_knob: int | None = None


# --------------------------------------------------------------------------- scenes


class Scene(Model):
    name: str = ""
    values: dict[str, float] = Field(default_factory=dict)  # macro name -> control value (0..1)
