import type { FogMachine } from '../api'
import { Button, NumberInput, Row, SaveBar, Section, StatusDot, Toggle, useSettings } from '../components/forms'
import type { EngineConnection } from '../useEngine'

const NEW_MACHINE: FogMachine = {
  name: 'Fog',
  enabled: false,
  universe: 0,
  channel: 1,
  on_value: 255,
  off_value: 0,
  interval_s: 60,
  duration_s: 4,
  manual_macro: 'Fog Machine',
}

export function Fog({ engine }: { engine: EngineConnection }) {
  const { settings, update, save, dirty, reload, message } = useSettings()
  if (!settings) return null
  const machines = settings.fog.machines

  return (
    <div className="flex max-w-3xl flex-col gap-1.5">
      <div className="flex justify-between">
        <Button onClick={() => update((s) => s.fog.machines.push({ ...NEW_MACHINE }))}>Add fog machine</Button>
        <SaveBar dirty={dirty} save={save} reload={reload} message={message} />
      </div>
      {machines.map((m, i) => (
        <Section
          key={i}
          index={String(i + 1).padStart(2, '0')}
          title={m.name}
          right={<StatusDot ok={engine.state?.fog[m.name] ?? null} label={engine.state?.fog[m.name] ? 'fogging' : 'idle'} />}
        >
          <Row label="Name">
            <input type="text" value={m.name} onChange={(e) => update((s) => (s.fog.machines[i].name = e.target.value))} />
          </Row>
          <Row label="Timer enabled">
            <Toggle checked={m.enabled} onChange={(v) => update((s) => (s.fog.machines[i].enabled = v))} />
          </Row>
          <Row label="Universe / channel">
            <NumberInput value={m.universe} integer min={0} className="w-16" onChange={(v) => update((s) => (s.fog.machines[i].universe = v))} />
            <NumberInput value={m.channel} integer min={1} max={512} className="w-20" onChange={(v) => update((s) => (s.fog.machines[i].channel = v))} />
          </Row>
          <Row label="On / off value">
            <NumberInput value={m.on_value} integer min={0} max={255} className="w-20" onChange={(v) => update((s) => (s.fog.machines[i].on_value = v))} />
            <NumberInput value={m.off_value} integer min={0} max={255} className="w-20" onChange={(v) => update((s) => (s.fog.machines[i].off_value = v))} />
          </Row>
          <Row label="Every … for … seconds">
            <NumberInput value={m.interval_s} min={1} className="w-20" onChange={(v) => update((s) => (s.fog.machines[i].interval_s = v))} />
            <NumberInput value={m.duration_s} min={0} className="w-20" onChange={(v) => update((s) => (s.fog.machines[i].duration_s = v))} />
          </Row>
          <Row label="Manual trigger" hint="Macro that fogs while held (Fog Machine button)">
            <Toggle
              checked={m.manual_macro === 'Fog Machine'}
              onChange={(v) => update((s) => (s.fog.machines[i].manual_macro = v ? 'Fog Machine' : null))}
              label="Fog Machine button"
            />
          </Row>
          <div className="mt-2">
            <Button onClick={() => update((s) => s.fog.machines.splice(i, 1))}>Remove</Button>
          </div>
        </Section>
      ))}
    </div>
  )
}
