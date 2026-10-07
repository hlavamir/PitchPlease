import { useEffect, useState } from 'react'
import { api, type MacroDef, type Rig } from '../api'
import { MacroControl } from '../components/MacroControl'
import { Section } from '../components/forms'
import { useMacroNav } from '../macroNav'
import type { EngineConnection } from '../useEngine'
import { useGridNav } from '../useGridNav'

/**
 * The 16 dimmers. Names come from the active rig (double-click a name to rename it); a dimmer
 * that no fixture of the rig uses is disabled here and ignored by MIDI.
 */
export function Dimmers({ engine, defs }: { engine: EngineConnection; defs: Record<string, MacroDef> }) {
  const dimmers = Object.values(defs).filter((d) => d.page === 'dimmers')
  const macros = engine.state?.macros ?? {}
  const [rig, setRig] = useState<Rig | null>(null)
  const [error, setError] = useState<string | null>(null)
  useEffect(() => {
    api.get<Rig>('/api/rig').then(setRig)
  }, [])

  const names = rig?.dimmer_names ?? {}
  const used = new Set((rig?.fixtures ?? []).map((f) => f.dimmer_macro).filter(Boolean))
  const label = (d: MacroDef) => names[d.name] || d.name
  const disabled = (d: MacroDef) => rig !== null && !used.has(d.name)

  const rename = async (macro: string, name: string) => {
    try {
      const res = await api.post<{ dimmer_names: Record<string, string> }>('/api/rig/dimmer-name', { macro, name })
      setRig((r) => r && { ...r, dimmer_names: res.dimmer_names })
      setError(null)
    } catch (e) {
      setError(e instanceof Error ? e.message : String(e))
    }
  }

  const { item } = useMacroNav(engine, defs)
  // disabled dimmers are empty slots: the keys skip them
  const navRow = (row: MacroDef[]) => row.map((d) => (disabled(d) ? null : item(d.name, label(d))))
  const { selectedId, select } = useGridNav('Dimmers', [navRow(dimmers.slice(0, 8)), navRow(dimmers.slice(8, 16))])

  return (
    <div className="flex h-full flex-col">
      <Section
        index="01"
        title="Dimmers"
        right={`${used.size} in use · knob row 3 · faders — LCXL3`}
        className="min-h-[24rem] flex-1"
        bodyClassName="p-0"
      >
        <div className="grid min-h-0 flex-1 grid-cols-8 grid-rows-2 gap-px bg-edge">
          {dimmers.map((d, i) => (
            <MacroControl
              key={d.name}
              def={{ ...d, label: label(d) }}
              value={macros[d.name] ?? 0}
              setMacro={engine.setMacro}
              toggleMacro={engine.toggleMacro}
              selected={selectedId === d.name}
              onSelect={() => select(d.name)}
              index={i + 1}
              className="h-full"
              disabled={disabled(d)}
              name={names[d.name] ?? ''}
              onRename={(name) => rename(d.name, name)}
            />
          ))}
        </div>
        <p className="lbl border-t border-edge px-2.5 py-1.5 text-[10px] text-dim">
          {error ? (
            <span className="text-ink">✕ {error}</span>
          ) : (
            'Fixtures choose their dimmer on the Fixtures page · a dimmer no fixture uses is disabled and ignores MIDI · double-click a name to rename it (saved with the rig)'
          )}
        </p>
      </Section>
    </div>
  )
}
