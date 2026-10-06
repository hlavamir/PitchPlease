import { useCallback, useEffect, useState } from 'react'
import { api, type FixtureInstance, type FixtureType, type MacroDef, type Rig } from '../api'
import { OutputMonitor } from '../components/OutputMonitor'
import { Preview } from '../components/Preview'
import { Button, NumberInput, Row, Section, Toggle } from '../components/forms'
import type { EngineConnection } from '../useEngine'

const NEW_FIXTURE: FixtureInstance = {
  name: 'New fixture',
  type: '',
  enabled: true,
  group: 'A',
  universe: 0,
  address: 1,
  position: [0.5, 0.5],
  rotation: 0,
  length: 0,
  real_strobo: false,
  channel_values: {},
  hue_source: 'group',
  hue: 0,
  saturation_source: 'group',
  saturation: 1,
  brightness_source: 'pipeline',
  brightness: 1,
  idle_mask_range: { min: 0, max: 1, curve: 0, macro: null },
}

export function Fixtures({ engine, defs }: { engine: EngineConnection; defs: Record<string, MacroDef> }) {
  const [rig, setRig] = useState<Rig | null>(null)
  const [rigs, setRigs] = useState<{ active: string; available: string[] }>({ active: '', available: [] })
  const [types, setTypes] = useState<Record<string, FixtureType>>({})
  const [selected, setSelected] = useState(0)
  const [dirty, setDirty] = useState(false)
  const [problems, setProblems] = useState<string[]>([])

  const reload = useCallback(() => {
    api.get<Rig>('/api/rig').then(setRig)
    api.get<typeof rigs & { unsaved: boolean }>('/api/rigs').then((r) => {
      setRigs(r)
      setDirty(r.unsaved)
    })
    api.get<Record<string, FixtureType>>('/api/fixture-types').then(setTypes)
  }, [])
  useEffect(reload, [reload])

  // every committed edit is applied to the engine immediately; "Save rig" writes the file
  const applyLive = (next: Rig) => {
    api.put('/api/rig?persist=false', next).catch((e) => setProblems([String(e)]))
  }

  const commitRig = (next: Rig, live = true) => {
    setRig(next)
    setDirty(true)
    if (live) applyLive(next)
  }

  const edit = (fn: (f: FixtureInstance) => void, live = true) => {
    if (!rig) return
    const next = structuredClone(rig)
    fn(next.fixtures[selected])
    commitRig(next, live)
  }

  const save = async () => {
    if (!rig) return
    const res = await api.put<{ ok: boolean; problems: string[] }>('/api/rig', rig)
    setProblems(res.problems)
    setDirty(false)
  }

  const revert = async () => {
    setRig(await api.post<Rig>('/api/rig/reload'))
    setDirty(false)
    setProblems([])
  }

  const activate = async (name: string) => {
    await api.post('/api/rig/activate', { name })
    reload()
  }

  const addFixture = (copyOf?: FixtureInstance) => {
    if (!rig) return
    const next = structuredClone(rig)
    const base = copyOf ? structuredClone(copyOf) : { ...NEW_FIXTURE, type: Object.keys(types)[0] ?? '' }
    base.name = copyOf ? `${copyOf.name} copy` : base.name
    next.fixtures.push(base)
    setSelected(next.fixtures.length - 1)
    commitRig(next)
  }

  const removeFixture = () => {
    if (!rig) return
    const next = structuredClone(rig)
    next.fixtures.splice(selected, 1)
    setSelected(Math.max(0, selected - 1))
    commitRig(next)
  }

  const fx = rig?.fixtures[selected]
  const dimmerNames = Object.values(defs).filter((d) => d.page === 'dimmers')
  const ftype = fx ? types[fx.type] : undefined

  return (
    <div className="grid gap-1.5 xl:grid-cols-[16rem_minmax(0,1fr)_22rem]">
      <Section
        index="01"
        title="Rig"
        right={
          <select value={rigs.active} onChange={(e) => activate(e.target.value)}>
            {rigs.available.map((r) => (
              <option key={r}>{r}</option>
            ))}
          </select>
        }
      >
        {rig?.description && <p className="mb-3 text-[11px] text-dim">{rig.description}</p>}
        <ul className="flex max-h-[calc(100vh-17rem)] flex-col gap-0.5 overflow-auto">
          {rig?.fixtures.map((f, i) => (
            <li key={i}>
              <button
                onClick={() => setSelected(i)}
                className={`flex w-full items-center gap-2 px-2 py-1.5 text-left text-[13px] ${
                  i === selected ? 'glow-on bg-ink text-ground' : 'hover:bg-panel-2'
                } ${f.enabled ? '' : 'text-dim'}`}
              >
                <span className="flex-none border border-edge px-1 font-mono text-[10px] leading-[14px] text-dim">{f.group}</span>
                <span className="flex-1 truncate">{f.name}</span>
                <span className="font-mono text-[11px] text-dim">
                  {types[f.type]?.transport === 'pitchpls_v2' ? 'serial' : `${f.universe}:${f.address}`}
                </span>
              </button>
            </li>
          ))}
        </ul>
        <div className="mt-3 flex flex-wrap gap-2">
          <Button onClick={() => addFixture()}>Add</Button>
          <Button onClick={() => fx && addFixture(fx)} disabled={!fx}>
            Duplicate
          </Button>
          <Button onClick={removeFixture} disabled={!fx}>
            Remove
          </Button>
        </div>
        <div className="mt-3 flex gap-2">
          <Button onClick={revert} disabled={!dirty}>
            Revert
          </Button>
          <Button onClick={save} primary disabled={!dirty}>
            Save rig
          </Button>
        </div>
        {problems.length > 0 && (
          <ul className="mt-3 list-disc pl-5 text-[11px] text-ink">
            {problems.map((p) => (
              <li key={p}>{p}</li>
            ))}
          </ul>
        )}
      </Section>

      <Section index="02" title={fx ? fx.name : 'Fixture'}>
        {fx && (
          <div className="grid gap-x-6 @3xl:grid-cols-2">
            <div>
              <Row label="Name">
                <input
                  type="text"
                  className="w-full"
                  value={fx.name}
                  onChange={(e) => edit((f) => (f.name = e.target.value), false)}
                  onBlur={() => rig && applyLive(rig)}
                />
              </Row>
              <Row label="Type">
                <select value={fx.type} onChange={(e) => edit((f) => (f.type = e.target.value))}>
                  {!types[fx.type] && <option value={fx.type}>{fx.type} (missing)</option>}
                  {Object.keys(types).map((t) => (
                    <option key={t}>{t}</option>
                  ))}
                </select>
              </Row>
              <Row label="Enabled">
                <Toggle checked={fx.enabled} onChange={(v) => edit((f) => (f.enabled = v))} />
              </Row>
              <Row label="Group">
                <select value={fx.group} onChange={(e) => edit((f) => (f.group = e.target.value as 'A' | 'B'))}>
                  <option>A</option>
                  <option>B</option>
                </select>
              </Row>
              <Row label="Universe / address">
                <NumberInput value={fx.universe} min={0} onChange={(v) => edit((f) => (f.universe = v))} className="w-16" />
                <NumberInput value={fx.address} min={1} max={512} onChange={(v) => edit((f) => (f.address = v))} className="w-20" />
              </Row>
              <Row label="Pixels" hint="Empty = from the fixture type">
                <NumberInput value={fx.pixels ?? ftype?.pixels} min={1} onChange={(v) => edit((f) => (f.pixels = v))} />
              </Row>
              <Row label="Position (u, v)">
                <NumberInput value={fx.position[0]} step={0.01} onChange={(v) => edit((f) => (f.position = [v, f.position[1]]))} />
                <NumberInput value={fx.position[1]} step={0.01} onChange={(v) => edit((f) => (f.position = [f.position[0], v]))} />
              </Row>
              <Row label="Rotation (turns)" hint="0.25 = 90°; 0.75 = vertical, first pixel at the bottom">
                <NumberInput value={fx.rotation} step={0.05} onChange={(v) => edit((f) => (f.rotation = v))} />
              </Row>
              <Row label="Length">
                <NumberInput value={fx.length} step={0.01} onChange={(v) => edit((f) => (f.length = v))} />
              </Row>
              <Row label="Dimmer macro">
                <select value={fx.dimmer_macro ?? ''} onChange={(e) => edit((f) => (f.dimmer_macro = e.target.value || null))}>
                  <option value="">none</option>
                  {dimmerNames.map((d) => (
                    <option key={d.name} value={d.name}>
                      {d.name}
                      {d.display_name ? ` — ${d.display_name}` : ''}
                    </option>
                  ))}
                </select>
              </Row>
            </div>
            <div>
              <Row label="React to strobo" hint="Empty = from the fixture type">
                <select
                  value={fx.react_to_strobo == null ? '' : String(fx.react_to_strobo)}
                  onChange={(e) => edit((f) => (f.react_to_strobo = e.target.value === '' ? null : e.target.value === 'true'))}
                >
                  <option value="">type default</option>
                  <option value="true">yes</option>
                  <option value="false">no</option>
                </select>
              </Row>
              <Row label="Brightness gamma">
                <NumberInput value={fx.brightness_gamma} step={0.1} onChange={(v) => edit((f) => (f.brightness_gamma = v))} />
              </Row>
              <Row label="RGB gamma">
                <NumberInput value={fx.rgb_gamma} step={0.1} onChange={(v) => edit((f) => (f.rgb_gamma = v))} />
              </Row>
              <Row label="Hue source">
                <select value={fx.hue_source} onChange={(e) => edit((f) => (f.hue_source = e.target.value as FixtureInstance['hue_source']))}>
                  <option value="group">own group</option>
                  <option value="A">group A</option>
                  <option value="B">group B</option>
                  <option value="const">constant</option>
                </select>
                {fx.hue_source === 'const' && <NumberInput value={fx.hue} step={0.01} onChange={(v) => edit((f) => (f.hue = v))} />}
              </Row>
              <Row label="Saturation source">
                <select
                  value={fx.saturation_source}
                  onChange={(e) => edit((f) => (f.saturation_source = e.target.value as FixtureInstance['saturation_source']))}
                >
                  <option value="group">own group</option>
                  <option value="A">group A</option>
                  <option value="B">group B</option>
                  <option value="const">constant</option>
                </select>
                {fx.saturation_source === 'const' && (
                  <NumberInput value={fx.saturation} step={0.01} onChange={(v) => edit((f) => (f.saturation = v))} />
                )}
              </Row>
              <Row label="Brightness source">
                <select
                  value={fx.brightness_source}
                  onChange={(e) => edit((f) => (f.brightness_source = e.target.value as FixtureInstance['brightness_source']))}
                >
                  <option value="pipeline">strobo / idle pipeline</option>
                  <option value="const">constant</option>
                </select>
                {fx.brightness_source === 'const' && (
                  <NumberInput value={fx.brightness} step={0.05} onChange={(v) => edit((f) => (f.brightness = v))} />
                )}
              </Row>
              <Row label="Idle remap min / max" hint="lerp(min, max, mask ^ 2^curve); min > max inverts">
                <NumberInput value={fx.idle_mask_range.min} step={0.05} onChange={(v) => edit((f) => (f.idle_mask_range.min = v))} className="w-20" />
                <NumberInput value={fx.idle_mask_range.max} step={0.05} onChange={(v) => edit((f) => (f.idle_mask_range.max = v))} className="w-20" />
              </Row>
              <Row label="Idle remap curve">
                <NumberInput value={fx.idle_mask_range.curve} step={0.5} onChange={(v) => edit((f) => (f.idle_mask_range.curve = v))} className="w-20" />
              </Row>
              <Row label="Remap only when" hint="If set, the remap applies only while this macro is on">
                <select
                  value={fx.idle_mask_range.macro ?? ''}
                  onChange={(e) => edit((f) => (f.idle_mask_range.macro = e.target.value || null))}
                >
                  <option value="">always</option>
                  {Object.values(defs)
                    .filter((d) => d.kind === 'toggle')
                    .map((d) => (
                      <option key={d.name}>{d.name}</option>
                    ))}
                </select>
              </Row>
            </div>
          </div>
        )}
        {ftype && (
          <details className="mt-4">
            <summary className="cursor-pointer text-[11px] text-dim">Fixture type “{ftype.name}”</summary>
            <pre className="mt-2 max-h-64 overflow-auto bg-panel-2 p-2 text-[11px]">{JSON.stringify(ftype, null, 2)}</pre>
          </details>
        )}
      </Section>

      <Section index="03" title="Placement">
        <Preview preview={engine.preview} state={engine.state} highlight={fx?.name} />
        <p className="mt-2 text-[11px] text-dim">
          Changes apply live (Enter or leaving a field); “Save rig” writes the rig file, “Revert” reloads it. The thick ring
          marks the first pixel.
        </p>
        {fx && (
          <div className="mt-3">
            <OutputMonitor state={engine.state} only={fx.name} />
          </div>
        )}
      </Section>
    </div>
  )
}
