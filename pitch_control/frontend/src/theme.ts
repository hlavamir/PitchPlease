// Appearance: ink colour, its brightness and the glow strength (Settings → Appearance).

export type InkName = 'grey' | 'amber' | 'phosphor'

export interface UiSettings {
  ink: InkName
  glow: number // 0..1
  brightness: number // 0.4..1, dims the ink (less light at the DJ booth)
  key_hints: boolean
  start_fullscreen: boolean // desktop app: open in full screen
  scale: number // UI zoom 0.6..1.5; 1 = the design size
}

export const DEFAULT_UI: UiSettings = { ink: 'grey', glow: 1, brightness: 1, key_hints: true, start_fullscreen: false, scale: 1 }

// The layout is designed for a 1512 × 915 px window (14" MacBook) at scale 1.
export const DESIGN_SIZE = { width: 1512, height: 915 }
export const SCALE_MIN = 0.6
export const SCALE_MAX = 1.5
// The page layouts switch to columns from this width (in scaled px), see the "wide" variant in index.css.
const WIDE_FROM = 1280

export const clampScale = (s: number) => Math.round(Math.min(SCALE_MAX, Math.max(SCALE_MIN, s)) * 100) / 100

/** The largest scale at which the design size fits the current window (rounded down to 1 %). */
export function fitScale(): number {
  const s = Math.min(window.innerWidth / DESIGN_SIZE.width, window.innerHeight / DESIGN_SIZE.height)
  return clampScale(Math.floor(s * 100) / 100)
}

/**
 * Scale the whole UI with CSS zoom (like the OS display scaling: layout, text and pointer input all
 * follow). Media and container queries don't see the zoom consistently in WebKit and Chromium, so
 * the page layouts switch on a [data-wide] flag computed here from the scaled window width.
 */
export function applyScale(scale: number): void {
  const root = document.documentElement
  const s = clampScale(scale)
  root.style.zoom = s === 1 ? '' : String(s)
  root.style.setProperty('--ui-scale', String(s))
  // the window width in scaled px (vw units don't follow CSS zoom the same way in every engine)
  root.style.setProperty('--win-w', `${window.innerWidth / s}px`)
  root.toggleAttribute('data-wide', window.innerWidth / s >= WIDE_FROM)
}

export const INKS: Record<InkName, string> = {
  grey: '#d8d9d4',
  amber: '#e9c46a',
  phosphor: '#a8e6b5',
}

const GROUND = [15, 16, 17]

export function hexToRgb(hex: string): [number, number, number] {
  const n = parseInt(hex.slice(1), 16)
  return [(n >> 16) & 255, (n >> 8) & 255, n & 255]
}

/** Ink colour after the brightness setting (blended towards the ground colour). */
export function inkRgb(ui: UiSettings): [number, number, number] {
  const [r, g, b] = hexToRgb(INKS[ui.ink] ?? INKS.grey)
  const k = Math.min(1, Math.max(0.4, ui.brightness))
  return [r, g, b].map((v, i) => Math.round(GROUND[i] + (v - GROUND[i]) * k)) as [number, number, number]
}

export function applyTheme(ui: UiSettings): void {
  const root = document.documentElement
  root.style.setProperty('--ink-rgb', inkRgb(ui).join(' '))
  root.style.setProperty('--glow', String(Math.min(1, Math.max(0, ui.glow))))
}

/** The current ink as "r g b", for canvas drawing. */
export function currentInk(): string {
  return getComputedStyle(document.documentElement).getPropertyValue('--ink-rgb').trim() || '216 217 212'
}
