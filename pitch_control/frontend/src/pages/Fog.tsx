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
            <input type="text" className="w-full" value={m.name} onChange={(e) => update((s) => (s.fog.machines[i].name = e.target.value))} />
          </Row>
          <Row label="Timer" plain hint="Fog automatically: a burst every N seconds that lasts M seconds; off = only the manual trigger fogs">
            <Toggle checked={m.enabled} onChange={(v) => update((s) => (s.fog.machines[i].enabled = v))} />
            <span className="text-dim">every</span>
            <NumberInput value={m.interval_s} min={1} className="w-20" onChange={(v) => update((s) => (s.fog.machines[i].interval_s = v))} />
            <span className="text-dim">s for</span>
            <NumberInput value={m.duration_s} min={0} className="w-20" onChange={(v) => update((s) => (s.fog.machines[i].duration_s = v))} />
            <span className="text-dim">s</span>
          </Row>
          <Row label="DMX channel" plain hint="Where the machine listens: DMX universe (as on the Outputs page) and channel 1–512">
            <span className="text-dim">universe</span>
            <UniverseSelect value={m.universe} onChange={(v) => update((s) => (s.fog.machines[i].universe = v))} />
            <span className="text-dim">channel</span>
            <NumberInput value={m.channel} integer min={1} max={512} className="w-20" onChange={(v) => update((s) => (s.fog.machines[i].channel = v))} />
          </Row>
          <Row label="DMX values" plain hint="Values (0–255) sent while fogging (on) and while idle (off); some machines need a minimum on value">
            <span className="text-dim">on</span>
            <NumberInput value={m.on_value} integer min={0} max={255} className="w-20" onChange={(v) => update((s) => (s.fog.machines[i].on_value = v))} />
            <span className="text-dim">off</span>
            <NumberInput value={m.off_value} integer min={0} max={255} className="w-20" onChange={(v) => update((s) => (s.fog.machines[i].off_value = v))} />
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
