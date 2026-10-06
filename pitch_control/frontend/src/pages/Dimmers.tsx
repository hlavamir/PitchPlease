import type { MacroDef } from '../api'
import { MacroControl } from '../components/MacroControl'
import { Section } from '../components/forms'
import { useMacroNav } from '../macroNav'
import type { EngineConnection } from '../useEngine'
import { useGridNav } from '../useGridNav'

export function Dimmers({ engine, defs }: { engine: EngineConnection; defs: Record<string, MacroDef> }) {
  const dimmers = Object.values(defs).filter((d) => d.page === 'dimmers')
  const macros = engine.state?.macros ?? {}
  const label = (d: MacroDef) => d.display_name || d.name
  const { item } = useMacroNav(engine, defs)
  const { selectedId, select } = useGridNav('Dimmers', [
    dimmers.slice(0, 8).map((d) => item(d.name, label(d))),
    dimmers.slice(8, 16).map((d) => item(d.name, label(d))),
  ])

  return (
    <div className="flex h-full flex-col">
      <Section
        index="01"
        title="Dimmers"
        right="knob row 3 · faders — LCXL3"
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
            />
          ))}
        </div>
        <p className="lbl border-t border-edge px-2.5 py-1.5 text-[10px] text-dim">
          Fixtures reference a dimmer by its macro name (e.g. “Dimmer 01”) in the rig · profiles can bind a DMX channel to any macro
        </p>
      </Section>
    </div>
  )
}
