import type { FogMachine } from '../api'
import { Button, NumberInput, Row, SaveBar, Section, StatusDot, Toggle, UniverseSelect, useSettings } from '../components/forms'
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
    // machines take half the page width side by side, or the full width under each other
    <div className="grid gap-1.5 wide:grid-cols-2">
      <div className="flex justify-between wide:col-span-2">
        <Button onClick={() => update((s) => s.fog.machines.push({ ...NEW_MACHINE }))} tip="Add a fog machine: a DMX channel that is switched on and off by a timer or by the Fog Machine button">
          Add fog machine
        </Button>
        <SaveBar dirty={dirty} save={save} reload={reload} message={message} />
      </div>
      {machines.map((m, i) => (
        <Section
          key={i}
          index={String(i + 1).padStart(2, '0')}
          title={m.name}
          right={<StatusDot ok={engine.state?.fog[m.name] ?? null} label={engine.state?.fog[m.name] ? 'fogging' : 'idle'} tip="Whether the machine is being sent its on value right now" />}
          tip="A fog machine as one DMX channel. On value while it fogs, off value otherwise; timer and manual trigger can fog"
        >
          <Row label="Name" hint="Name of the machine, used as this panel's title">
            <input type="text" value={m.name} onChange={(e) => update((s) => (s.fog.machines[i].name = e.target.value))} />
          </Row>
          <Row label="Timer enabled" hint="Fog automatically: every N seconds for M seconds (below); off = only the manual trigger fogs">
            <Toggle checked={m.enabled} onChange={(v) => update((s) => (s.fog.machines[i].enabled = v))} />
          </Row>
          <Row label="Universe / channel" hint="Where the machine listens: DMX universe (as on the Outputs page) and channel 1–512">
            <UniverseSelect value={m.universe} onChange={(v) => update((s) => (s.fog.machines[i].universe = v))} />
            <NumberInput value={m.channel} integer min={1} max={512} className="w-20" onChange={(v) => update((s) => (s.fog.machines[i].channel = v))} />
          </Row>
          <Row label="On / off value" hint="DMX values (0–255) sent while fogging and while idle; some machines need a minimum on value">
            <NumberInput value={m.on_value} integer min={0} max={255} className="w-20" onChange={(v) => update((s) => (s.fog.machines[i].on_value = v))} />
            <NumberInput value={m.off_value} integer min={0} max={255} className="w-20" onChange={(v) => update((s) => (s.fog.machines[i].off_value = v))} />
          </Row>
          <Row label="Every … for … seconds" hint="Timer: starts a fog burst every N seconds (first field) and keeps it on for M seconds (second field)">
            <NumberInput value={m.interval_s} min={1} className="w-20" onChange={(v) => update((s) => (s.fog.machines[i].interval_s = v))} />
            <NumberInput value={m.duration_s} min={0} className="w-20" onChange={(v) => update((s) => (s.fog.machines[i].duration_s = v))} />
          </Row>
          <Row label="Manual trigger" hint="Also fog while the Fog Machine button is held (General page, or a controller button)">
            <Toggle
              checked={m.manual_macro === 'Fog Machine'}
              onChange={(v) => update((s) => (s.fog.machines[i].manual_macro = v ? 'Fog Machine' : null))}
              label="Fog Machine button"
            />
          </Row>
          <div className="mt-2">
            <Button onClick={() => update((s) => s.fog.machines.splice(i, 1))} tip="Remove this fog machine (written with Save)">
              Remove
            </Button>
          </div>
        </Section>
      ))}
    </div>
  )
}
