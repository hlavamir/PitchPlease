import type { MacroDef } from './api'

// Context hints for the footer: which keys / mouse actions apply to the control under the mouse or
// selected with the keyboard, plus a short tooltip. Controls mark themselves with
// data-hint="<kind>" (and optionally data-tip="…"); keyboard-selectable items carry the same kind.

export type HintKind =
  | 'fader'
  | 'fader-deferred'
  | 'dimmer'
  | 'dimmer-off'
  | 'toggle'
  | 'hold'
  | 'press'
  | 'scene'
  | 'number'
  | 'switch'
  | 'override'
  | 'undo'
  | 'channel'
  | 'list'
  | 'list-multi'
  | 'slider'
  | 'tab'

export type Keys = [cap: string, what: string][]

/** The shortcut modifier: ⌘ on macOS, Ctrl elsewhere. */
export const MOD = typeof navigator !== 'undefined' && navigator.userAgent.includes('Mac') ? '⌘' : 'CTRL'

const MOVE: Keys = [['W A S D', 'move']]

export const HINT_KEYS: Record<HintKind, Keys> = {
  fader: [['DRAG ↕', 'value'], ['↑ ↓', 'value'], ['SHIFT', 'fine'], ['DBL-CLICK', 'reset'], ...MOVE],
  'fader-deferred': [['DRAG ↕', 'value'], ['↑ ↓', 'value'], ['SHIFT', 'fine'], ['ESC', 'cancel'], ['DBL-CLICK', 'reset'], ...MOVE],
  dimmer: [['DRAG ↕', 'value'], ['↑ ↓', 'value'], ['SHIFT', 'fine'], ['DBL-CLICK', 'reset'], ['DBL-CLICK NAME', 'rename'], ...MOVE],
  'dimmer-off': [['DBL-CLICK NAME', 'rename'], ['RIG → DIMMER', 'assign fixtures']],
  toggle: [['CLICK', 'on / off'], ['⏎', 'on / off'], ...MOVE],
  hold: [['HOLD', 'active while held'], ['⏎', 'hold'], ...MOVE],
  press: [['CLICK', 'select'], ['⏎', 'select'], ...MOVE],
  scene: [['CLICK', 'load'], ['⏎', 'load'], ['SHIFT ⏎', 'save'], ...MOVE],
  number: [['⏎', 'apply'], ['↑ ↓', 'step'], ['SHIFT', 'fine'], ['RIGHT-DRAG ↕', 'step'], ['ESC', 'revert']],
  switch: [['CLICK', 'on / off'], ['SPACE', 'on / off']],
  override: [['CLICK', 'override the type value'], ['UNTICKED', 'type value applies, yours is kept']],
  undo: [['CLICK', 'back to the type value']],
  channel: [['DRAG ↕', 'override'], ['↑ ↓', 'override'], ['SHIFT', 'fine'], ['⏎', 'override on / off'], ['Q E', 'subpage'], ...MOVE],
  list: [['CLICK', 'select']],
  'list-multi': [['CLICK', 'select'], ['SHIFT CLICK', 'add / remove']],
  slider: [['CLICK / DRAG', 'set'], ['↑ ↓', 'change'], ['SHIFT', 'fine'], ...MOVE],
  tab: [['1 – 9', 'page'], ['F', 'full screen'], [`${MOD} + −`, 'UI scale'], [`${MOD} 0`, 'UI scale 100 %']],
}

/** Footer hint kind of a macro control (see hints.ts). */
export function macroHint(def: MacroDef): HintKind {
  if (def.kind === 'fader') return def.page === 'dimmers' ? 'dimmer' : def.deferred ? 'fader-deferred' : 'fader'
  if (def.kind === 'momentary') return 'hold'
  if (def.kind === 'toggle') return 'toggle'
  return 'press'
}

/** What each macro does (the General page; see the wiki's vvvv-patch-logic for the details). */
export const MACRO_TIPS: Record<string, string> = {
  'Strobo Decay': 'How long the strobo flash takes to fade after a peak (seconds)',
  'Idle Attack': 'How long the idle colours take to fade back in after the strobo (seconds)',
  'Shader Speed': 'Speed and direction of the mask animation',
  'Shader Param': 'Preset parameter: Gradient = direction · Back & Forth = angle · Rotating Line = thickness · Noise = drift',
  'Hue A': 'Colour of group A (applied on release)',
  'Hue B': 'Colour of group B (applied on release)',
  'Saturation A': 'Colour saturation of group A (applied on release)',
  'Saturation B': 'Colour saturation of group B (applied on release)',
  'Audio Reactivity': 'How much the audio shapes the idle mask (0 = the plain mask; "Glitches" in vvvv)',
  Strobo: 'Strobo sensitivity: higher = lower peak threshold and shorter minimum time between flashes',
  'Strobo Brightness': 'Brightness of the strobo flash, all fixtures',
  'Idle Brightness': 'Brightness between flashes, all fixtures',
  'Strobo Bright. A': 'Strobo flash brightness of group A',
  'Idle Bright. A': 'Idle brightness of group A',
  'Strobo Bright. B': 'Strobo flash brightness of group B',
  'Idle Bright. B': 'Idle brightness of group B',
  'Manual Strobo': 'Flash by hand, independent of the audio',
  'Fog Machine': 'Fog while held (machines set up on the Fog page)',
  'Invert Discoball': 'Inverts the idle brightness of fixtures whose remap is bound to it (the pinspots)',
  'Vertical Symmetry': 'Mirrors the mask left ↔ right',
  'Auto Color Change': 'Picks new group colours from the palette after a random number of strobo flashes',
  'Swap Colors': 'Swaps the colours of groups A and B',
  'Preset A': 'Mask preset: a gradient',
  'Preset B': 'Mask preset: a band moving back and forth',
  'Preset C': 'Mask preset: a rotating line',
  'Preset D': 'Mask preset: drifting noise',
}

/** The hint of the element under the mouse (closest marked ancestor), or null. */
export function hintAt(target: EventTarget | null): { kind: HintKind; tip?: string } | null {
  const el = target instanceof Element ? target.closest<HTMLElement>('[data-hint]') : null
  if (!el) return null
  return { kind: el.dataset.hint as HintKind, tip: el.dataset.tip || undefined }
}
