// Types and helpers for the PitchControl backend API.

export type MacroKind = 'fader' | 'toggle' | 'button' | 'momentary' | 'radio'

export interface MacroDef {
  name: string
  label: string
  min: number
  max: number
  steps: number
  kind: MacroKind
  page: 'general' | 'dimmers' | 'scenes'
  default: number
  display_name: string
  radio_group: string | null
  deferred: boolean // applied on release / when the MIDI knob rests (hue, saturation)
  display_scale: number // shown value = value in range × display_scale
  unit: string
  decimals: number
}

export interface FixtureState {
  name: string
  type: string
  group: 'A' | 'B'
  transport: 'dmx' | 'pitchpls_v2'
  universe: number
  address: number
  uv: [number, number][]
  rgb: [number, number, number][]
  output: number[]
}

export interface MidiEvent {
  t: number
  text: string
  macro: string | null
  note: string
}

export interface IoStatus {
  connected?: boolean
  running?: boolean
  error: string | null
  frames?: number
  level?: number
  port?: string | null
  controller?: string | null
  channel?: number | null
  received?: number
  recent?: MidiEvent[]
}

export interface EngineState {
  frame: number
  fps: number
  tick_ms: number
  macros: Record<string, number>
  pending: Record<string, number> // deferred macro values waiting for the knob to rest
  phase: number
  strobo: number
  idle: number
  peaks_total: number
  trigger: number
  bands: number[]
  band_peaks: number[]
  peaks_map: number[]
  preset: string
  colors: { A: number[]; B: number[] }
  colors_hsb: { A: number[]; B: number[] }
  fixtures: FixtureState[]
  fog: Record<string, boolean>
  io: {
    outputs: { enttec: IoStatus | null; artnet: IoStatus | null; pitchpls_v2: IoStatus | null }
    audio: IoStatus | null
    midi: IoStatus | null
  }
}

export interface HSB {
  h: number
  s: number
  b: number
}

export interface DeviceRef {
  serial_number?: string | null
  vid?: number | null
  pid?: number | null
  description?: string | null
  port?: string | null
}

export interface SerialDevice {
  port: string
  description: string | null
  manufacturer: string | null
  serial_number: string | null
  vid: number | null
  pid: number | null
  label: string
}

export interface AudioDevice {
  index: number
  name: string
  hostapi: string
  label: string
  channels: number
}

export interface FogMachine {
  name: string
  enabled: boolean
  universe: number
  channel: number
  on_value: number
  off_value: number
  interval_s: number
  duration_s: number
  manual_macro: string | null
}

export interface Settings {
  fps: number
  preview_fps: number
  active_rig: string
  active_controller: string | null
  midi_input: string | null
  audio: {
    device: string | null
    channels: number[]
    gain: number
    sample_rate: number
    [key: string]: unknown
  }
  outputs: {
    enttec: { enabled: boolean; device: DeviceRef; universe: number }
    artnet: { enabled: boolean; targets: { universe: number; ip: string; artnet_universe?: number | null }[] }
    pitchpls_v2: { enabled: boolean; device: DeviceRef; baudrate: number; mode: number; strips: number; pixels_per_strip: number }
  }
  fog: { machines: FogMachine[] }
  masks: { line_falloff: number; transition_s: number }
  auto_colors: HSB[]
  ui: { ink: 'grey' | 'amber' | 'phosphor'; glow: number; brightness: number; key_hints: boolean; start_fullscreen: boolean }
  [key: string]: unknown
}

export interface FixtureInstance {
  name: string
  type: string
  enabled: boolean
  group: 'A' | 'B'
  universe: number
  address: number
  position: [number, number]
  rotation: number
  length: number
  pixel_positions?: [number, number][] | null
  pixels?: number | null
  brightness_gamma?: number | null
  rgb_gamma?: number | null
  react_to_strobo?: boolean | null
  strobo_color?: HSB | null
  real_strobo: boolean
  channel_values: Record<string, number>
  dimmer_macro?: string | null
  hue_source: 'group' | 'A' | 'B' | 'const'
  hue: number
  saturation_source: 'group' | 'A' | 'B' | 'const'
  saturation: number
  brightness_source: 'pipeline' | 'const'
  brightness: number
  idle_mask_range: { min: number; max: number; curve: number; macro?: string | null }
  [key: string]: unknown
}

export interface Rig {
  name: string
  description: string
  fixtures: FixtureInstance[]
}

export interface FixtureType {
  name: string
  description: string
  transport: 'dmx' | 'pitchpls_v2'
  pixels: number
  channels: Record<string, unknown>[]
  [key: string]: unknown
}

async function request<T>(method: string, url: string, body?: unknown): Promise<T> {
  const res = await fetch(url, {
    method,
    headers: body === undefined ? undefined : { 'Content-Type': 'application/json' },
    body: body === undefined ? undefined : JSON.stringify(body),
  })
  if (!res.ok) {
    const text = await res.text()
    let detail: unknown
    try {
      detail = JSON.parse(text).detail
    } catch {
      detail = undefined
    }
    // FastAPI errors carry a readable "detail"; show that alone
    throw new Error(typeof detail === 'string' ? detail : `${method} ${url}: ${res.status} ${text}`)
  }
  return res.json() as Promise<T>
}

export const api = {
  get: <T>(url: string) => request<T>('GET', url),
  put: <T>(url: string, body: unknown) => request<T>('PUT', url, body),
  post: <T>(url: string, body?: unknown) => request<T>('POST', url, body ?? {}),
  delete: <T>(url: string) => request<T>('DELETE', url),
}

export function rgbCss(rgb: number[], scale = 255): string {
  const [r, g, b] = rgb.map((x) => Math.round((x * 255) / scale))
  return `rgb(${r}, ${g}, ${b})`
}
