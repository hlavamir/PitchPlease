import { useCallback, useRef } from 'react'
import type { MacroDef } from './api'
import { formatValue } from './components/MacroControl'
import { MACRO_TIPS, macroHint } from './hints'
import type { EngineConnection } from './useEngine'
import type { NavItem } from './useGridNav'

const STEP = 0.025 // ↑/↓: half a fader segment
const FINE_STEP = 0.0025 // Shift + ↑/↓

/**
 * Keyboard items for macros. Remembers what was just sent so key repeat does not lose steps while
 * the engine state (15 updates/s) catches up. Hue/saturation go through the engine's pending path:
 * they apply once the keys rest, like a MIDI knob.
 */
export function useMacroNav(engine: EngineConnection, defs: Record<string, MacroDef>) {
  const sent = useRef<Record<string, { v: number; t: number }>>({})
  const { state, setMacro, toggleMacro, setDeferred, cancelPending } = engine

  const shown = useCallback(
    (name: string) => state?.pending?.[name] ?? state?.macros?.[name] ?? 0,
    [state],
  )

  const item = (name: string, label?: string): NavItem | null => {
    const def = defs[name]
    if (!def) return null
    const base: NavItem = { id: name, label: label ?? def.label, hint: macroHint(def), tip: MACRO_TIPS[def.name] }
    if (def.kind === 'fader') {
      return {
        ...base,
        value: formatValue(def, shown(name)),
        adjust: (dir, fine) => {
          const last = sent.current[name]
          const from = last && performance.now() - last.t < 700 ? last.v : shown(name)
          const v = Math.min(1, Math.max(0, from + dir * (fine ? FINE_STEP : STEP)))
          sent.current[name] = { v, t: performance.now() }
          if (def.deferred) setDeferred(name, v)
          else setMacro(name, v)
        },
        cancel: def.deferred ? () => cancelPending(name) : undefined,
      }
    }
    if (def.kind === 'momentary') return { ...base, value: shown(name) > 0.5 ? 'ON' : 'OFF', press: (down) => setMacro(name, down ? 1 : 0) }
    if (def.kind === 'toggle') return { ...base, value: shown(name) > 0.5 ? 'ON' : 'OFF', press: (down) => down && toggleMacro(name) }
    return { ...base, press: (down) => down && setMacro(name, 1) }
  }

  return { item, shown }
}
