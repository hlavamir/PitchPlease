// Appearance: ink colour, its brightness and the glow strength (Settings → Appearance).

export type InkName = 'grey' | 'amber' | 'phosphor'

export interface UiSettings {
  ink: InkName
  glow: number // 0..1
  brightness: number // 0.4..1, dims the ink (less light at the DJ booth)
  key_hints: boolean
  start_fullscreen: boolean // desktop app: open in full screen
}

export const DEFAULT_UI: UiSettings = { ink: 'grey', glow: 1, brightness: 1, key_hints: true, start_fullscreen: false }

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
