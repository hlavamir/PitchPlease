import type { MacroDef } from '../api'
import { MacroControl } from '../components/MacroControl'
import { Section } from '../components/forms'
import type { EngineConnection } from '../useEngine'

export function Dimmers({ engine, defs }: { engine: EngineConnection; defs: Record<string, MacroDef> }) {
  const dimmers = Object.values(defs).filter((d) => d.page === 'dimmers')
  const macros = engine.state?.macros ?? {}
  return (
    <Section title="Dimmers">
      <p className="mb-3 text-xs text-neutral-500">
        Fixtures reference a dimmer by its macro name (e.g. “Dimmer 01”) in the rig. Profiles can also bind a DMX channel
        to any macro.
      </p>
      <div className="grid grid-cols-4 gap-2 sm:grid-cols-8">
        {dimmers.map((d) => (
          <MacroControl
            key={d.name}
            def={{ ...d, label: d.display_name ? `${d.display_name}` : d.name }}
            value={macros[d.name] ?? 0}
            setMacro={engine.setMacro}
            toggleMacro={engine.toggleMacro}
          />
        ))}
      </div>
    </Section>
  )
}
