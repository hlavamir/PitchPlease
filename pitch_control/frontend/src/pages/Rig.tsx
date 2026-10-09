import { useCallback, useEffect, useRef, useState, type ReactNode } from 'react'
import { api, channelCount, type FixtureInstance, type FixtureType, type HSB, type MacroDef, type Override, type Rig } from '../api'
import { OutputMonitor } from '../components/OutputMonitor'
import { Preview } from '../components/Preview'
import { RigPanel, type RigList } from '../components/RigPanel'
import { hsvCss } from '../components/MacroControl'
import { Button, Check, NumberInput, Row, Section, Toggle } from '../components/forms'
import type { EngineConnection } from '../useEngine'
import { useElementWidth } from '../useElementWidth'

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
  react_to_strobo: false,
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

// a field whose value differs between the selected fixtures (multi-edit)
const MIXED = Symbol('mixed')
type Mixed<T> = T | typeof MIXED
const MIXED_OPTION = '__mixed__'

/** Tells the Fixtures page which type to open (the "edit type" link). */
export const OPEN_TYPE_KEY = 'pitchcontrol.openFixtureType'

const WHITE: HSB = { h: 0, s: 0, b: 1 }

/**
 * The rig of one event: the rig file, the fixtures in it and everything that differs per fixture.
 * Fixture types (pixels, channel layout, defaults) are edited on the Fixtures page; a fixture can
 * override some type values (checkbox; the undo arrow goes back to the type's value).
 */
export function Rig({ engine, defs }: { engine: EngineConnection; defs: Record<string, MacroDef> }) {
  const [rig, setRig] = useState<Rig | null>(null)
  const [rigs, setRigs] = useState<RigList>({ active: '', available: [] })
  const [types, setTypes] = useState<Record<string, FixtureType>>({})
  // indices into rig.fixtures; click selects one, Shift + click adds / removes one (multi-edit)
  const [selection, setSelection] = useState<number[]>([0])
  const [dirty, setDirty] = useState(false)
  const [problems, setProblems] = useState<string[]>([])
  const [editorRef, editorWidth] = useElementWidth<HTMLDivElement>()

  const reload = useCallback(() => {
    api.get<Rig>('/api/rig').then(setRig)
    api.get<RigList & { unsaved: boolean }>('/api/rigs').then((r) => {
      setRigs(r)
      setDirty(r.unsaved)
    })
    api.get<Record<string, FixtureType>>('/api/fixture-types').then(setTypes)
  }, [])
  useEffect(reload, [reload])

  // every committed edit is applied to the engine immediately; the rig's Save writes the file.
  // Live updates are chained, so rig actions (duplicate, rename …) can wait for the last one.
  const live = useRef<Promise<unknown>>(Promise.resolve())
  const applyLive = (next: Rig) => {
    live.current = live.current.then(() => api.put('/api/rig?persist=false', next).catch((e) => setProblems([String(e)])))
  }

  const commitRig = (next: Rig, live = true) => {
    setRig(next)
    setDirty(true)
    if (live) applyLive(next)
  }

  const sel = rig ? selection.filter((i) => i < rig.fixtures.length) : []
  const fxs = sel.map((i) => rig!.fixtures[i])
  const multi = fxs.length > 1

  /** Apply an edit to every selected fixture. */
  const edit = (fn: (f: FixtureInstance) => void, live = true) => {
    if (!rig || !sel.length) return
    const next = structuredClone(rig)
    for (const i of sel) fn(next.fixtures[i])
    commitRig(next, live)
  }

  const clickFixture = (i: number, shift: boolean) => {
    if (!shift) return setSelection([i])
    setSelection((cur) => (cur.includes(i) ? (cur.length > 1 ? cur.filter((j) => j !== i) : cur) : [...cur, i]))
  }

  /** The value all selected fixtures share, or MIXED. */
  const same = <T,>(get: (f: FixtureInstance) => T): Mixed<T> => {
    if (!fxs.length) return MIXED
    const first = get(fxs[0])
    const key = JSON.stringify(first)
    return fxs.every((f) => JSON.stringify(get(f)) === key) ? first : MIXED
  }
  /** Props for a NumberInput: the shared value, or empty with a "multiple" placeholder. */
  const num = (get: (f: FixtureInstance) => number | null | undefined) => {
    const v = same(get)
    return v === MIXED ? { value: null, placeholder: 'multiple' } : { value: v ?? null }
  }
  /** Value for a <select>: the shared value, or MIXED_OPTION. */
  const opt = (get: (f: FixtureInstance) => string) => {
    const v = same(get)
    return v === MIXED ? MIXED_OPTION : v
  }
  /**
   * One overridable fixture-type value (Unreal-style): the checkbox marks it overridden; switched
   * off, the field is disabled but keeps the override value, so switching on restores it. "default"
   * shows the type's value; the undo arrow (shown while an override differs from it) goes back to it.
   */
  const overrideRow = <T,>(o: {
    label: string
    hint: string
    get: (f: FixtureInstance) => Override<T> | null | undefined
    set: (f: FixtureInstance, v: Override<T> | null) => void
    def: (f: FixtureInstance) => T
    show: (v: T) => ReactNode
    input: (value: T | null, disabled: boolean, editEach: (fn: (current: T) => T) => void) => ReactNode
  }) => {
    const on = same((f) => !!o.get(f)?.enabled)
    const value = same((f) => o.get(f)?.value ?? o.def(f))
    const dflt = same(o.def)
    const differs = fxs.some((f) => {
      const x = o.get(f)
      return !!x?.enabled && JSON.stringify(x.value) !== JSON.stringify(o.def(f))
    })
    const editEach = (fn: (current: T) => T) => edit((f) => o.set(f, { enabled: true, value: fn(o.get(f)?.value ?? o.def(f)) }))
    return (
      <Row key={o.label} label={o.label} hint={o.hint} plain>
        <Check
          checked={on === true}
          mixed={on === MIXED}
          tip="Tick to give this fixture its own value instead of the fixture type's; untick: the type value applies and yours is kept"
          onChange={(v) => edit((f) => o.set(f, { enabled: v, value: o.get(f)?.value ?? o.def(f) }))}
        />
        {o.input(value === MIXED ? null : value, on !== true, editEach)}
        <span className="lbl text-[10px] whitespace-nowrap text-dim">default {dflt === MIXED ? 'multiple' : o.show(dflt)}</span>
        {differs && (
          <button
            data-hint="undo"
            data-tip="Remove this fixture's override: the fixture type's value applies again"
            className="text-glow flex-none px-0.5 text-[15px] leading-none hover:opacity-80"
            onClick={() => edit((f) => o.set(f, null))}
          >
            ↺
          </button>
        )}
      </Row>
    )
  }

  /** H, S, B fields (0–1) with a swatch, for the strobo colour. */
  const hsbInputs = (value: HSB | null, disabled: boolean, editEach: (fn: (c: HSB) => HSB) => void) => (
    <>
      {(['h', 's', 'b'] as const).map((k) => (
        <NumberInput
          key={k}
          value={value ? value[k] : null}
          placeholder={value ? undefined : 'multiple'}
          disabled={disabled}
          min={0}
          max={1}
          className="w-14 shrink"
          onChange={(v) => editEach((c) => ({ ...c, [k]: v }))}
        />
      ))}
      {value && <span className="size-3.5 flex-none" style={{ background: hsvCss(value.h, value.s, value.b) }} />}
    </>
  )

  const mixedOption = (value: string) =>
    value === MIXED_OPTION && (
      <option value={MIXED_OPTION} disabled>
        multiple
      </option>
    )

  const save = async () => {
    if (!rig) return
    await live.current // a live update arriving after the save would mark the rig unsaved again
    const res = await api.put<{ ok: boolean; problems: string[] }>('/api/rig', rig)
    setProblems(res.problems)
    setDirty(false)
  }

  const revert = async () => {
    setRig(await api.post<Rig>('/api/rig/reload'))
    setDirty(false)
    setProblems([])
  }

  const addFixture = (copyOf?: FixtureInstance) => {
    if (!rig) return
    const next = structuredClone(rig)
    const base = copyOf ? structuredClone(copyOf) : { ...NEW_FIXTURE, type: Object.keys(types)[0] ?? '' }
    base.name = copyOf ? `${copyOf.name} copy` : base.name
    next.fixtures.push(base)
    setSelection([next.fixtures.length - 1])
    commitRig(next)
  }

  const removeFixture = () => {
    if (!rig) return
    const next = structuredClone(rig)
    next.fixtures.splice(sel[0], 1)
    setSelection([Math.max(0, sel[0] - 1)])
    commitRig(next)
  }

  const fx = fxs[0] // the fixture in single mode, the first selected one in multi-edit
  const typeOf = (f: FixtureInstance): FixtureType | undefined => types[f.type]
  const openType = (name: string) => {
    try {
      sessionStorage.setItem(OPEN_TYPE_KEY, name)
    } catch {
      /* the Fixtures page then opens its first type */
    }
  }
  const dimmerNames = Object.values(defs).filter((d) => d.page === 'dimmers')
  const sharedType = same((f) => f.type)
  const ftype = sharedType === MIXED ? undefined : types[sharedType]
  const enabled = same((f) => f.enabled)
  const hueSource = opt((f) => f.hue_source)
  const satSource = opt((f) => f.saturation_source)
  const briSource = opt((f) => f.brightness_source)
  const selectedNames = fxs.map((f) => f.name)

  return (
    <div className="grid gap-1.5 wide:h-full wide:grid-cols-[17rem_minmax(0,1fr)_22rem] wide:grid-rows-[minmax(0,1fr)]">
      {/* left: the rig as a whole (file) above the lights in it; side by side in the single-column layout */}
      <div className="grid min-w-0 grid-cols-2 items-start gap-1.5 wide:flex wide:min-h-0 wide:flex-col wide:items-stretch">
        <RigPanel
          index="01"
          rigs={rigs}
          dirty={dirty}
          description={rig?.description ?? ''}
          problems={problems}
          onDescription={(text) => rig && commitRig({ ...rig, description: text }, false)}
          onDescriptionCommit={() => rig && dirty && applyLive(rig)}
          save={save}
          revert={revert}
          settle={() => live.current}
          changed={() => {
            setSelection([0])
            setProblems([])
            reload()
          }}
        />
        <Section
          index="02"
          title="Fixtures"
          right={rig && `${rig.fixtures.length} in rig`}
          className="min-h-0 flex-1"
          bodyClassName="p-2.5 min-h-0"
          tip="The lights of the rig: group, name and universe:address. Click one to edit it; Shift + click selects several"
        >
          <ul className="flex min-h-0 flex-1 flex-col gap-0.5 overflow-auto select-none">
            {rig?.fixtures.map((f, i) => (
              <li key={i}>
                <button
                  onClick={(e) => clickFixture(i, e.shiftKey)}
                  data-hint="list-multi"
                  data-tip={`${f.name}: fixture type ${f.type}, group ${f.group}${f.enabled ? '' : '; disabled, sends nothing'}`}
                  className={`flex w-full items-center gap-2 px-2 py-1.5 text-left text-[13px] ${
                    sel.includes(i) ? 'glow-on bg-ink text-ground' : 'hover:bg-panel-2'
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
          <p className="lbl mt-2 text-[10px] text-dim">Shift + click: add to / remove from the selection</p>
          <div className="mt-2 flex flex-wrap gap-1.5">
            <Button onClick={() => addFixture()} tip="Add a new fixture to the rig (first fixture type, default placement)">
              Add
            </Button>
            <Button onClick={() => fx && addFixture(fx)} disabled={!fx || multi} tip="Copy the selected fixture, with all its values; change its address afterwards">
              Duplicate
            </Button>
            <Button onClick={removeFixture} disabled={!fx || multi} tip="Remove the selected fixture from the rig (written to the file with the rig's Save)">
              Remove
            </Button>
          </div>
        </Section>
      </div>

      <Section
        index="03"
        title={multi ? `${fxs.length} fixtures` : fx ? fx.name : 'Fixture'}
        right={multi && 'multi-edit · a value you enter applies to all'}
        tip="Values of the selected fixture(s). Changes apply to the lights at once; the rig's Save writes them to the file"
      >
        <div ref={editorRef} className="min-w-0">
          {fx && (
            <div className={`grid gap-x-6 ${editorWidth >= 744 ? 'grid-cols-2' : ''}`}>
              <div>
                <Row label="Name" hint="Unique name of this fixture in the rig; used in lists, the preview and on the Control Desk">
                  <input
                    type="text"
                    className="w-full disabled:opacity-50"
                    disabled={multi}
                    value={multi ? '' : fx.name}
                    placeholder={multi ? 'names stay unique' : undefined}
                    onChange={(e) => edit((f) => (f.name = e.target.value), false)}
                    onBlur={() => rig && applyLive(rig)}
                  />
                </Row>
                <Row label="Type" hint="Fixture type (pixels, channel layout, defaults), defined on the Fixtures page">
                  <select value={opt((f) => f.type)} onChange={(e) => edit((f) => (f.type = e.target.value))}>
                    {mixedOption(opt((f) => f.type))}
                    {sharedType !== MIXED && !types[sharedType] && <option value={sharedType}>{sharedType} (missing)</option>}
                    {Object.keys(types).map((t) => (
                      <option key={t}>{t}</option>
                    ))}
                  </select>
                </Row>
                {ftype && (
                  <Row label="" plain>
                    <span className="lbl text-[10px] text-dim">
                      {ftype.pixels} px {ftype.channels.find((c) => c.pixels)?.pixels ?? 'RGB'} ·{' '}
                      {ftype.transport === 'pitchpls_v2' ? 'v2 serial' : `${channelCount(ftype)} DMX ch`}
                    </span>
                    <a href="#Fixtures" data-hint="button" data-tip="Open this fixture type on the Fixtures page" className="lbl text-[10px] text-ink hover:underline" onClick={() => openType(ftype.name)}>
                      edit type ›
                    </a>
                  </Row>
                )}
                <Row label="Enabled" hint="A disabled fixture stays in the rig but is skipped: it sends nothing">
                  <Toggle checked={enabled === true} mixed={enabled === MIXED} onChange={(v) => edit((f) => (f.enabled = v))} />
                </Row>
                <Row label="Group" hint="Colour group: A and B follow the Hue / Saturation A and B macros on the General page">
                  <select value={opt((f) => f.group)} onChange={(e) => edit((f) => (f.group = e.target.value as 'A' | 'B'))}>
                    {mixedOption(opt((f) => f.group))}
                    <option>A</option>
                    <option>B</option>
                  </select>
                </Row>
                <Row label="Universe / address" hint="Where the fixture listens: DMX universe (as numbered on the Outputs page) and 1-based start channel">
                  <NumberInput {...num((f) => f.universe)} integer min={0} onChange={(v) => edit((f) => (f.universe = v))} className="w-16" />
                  <NumberInput {...num((f) => f.address)} integer min={1} max={512} onChange={(v) => edit((f) => (f.address = v))} className="w-20" />
                </Row>
                <Row label="Position (u, v)" hint="Centre of the fixture in the scene square: u = 0 left … 1 right, v = 0 top … 1 bottom">
                  <NumberInput {...num((f) => f.position[0])} onChange={(v) => edit((f) => (f.position = [v, f.position[1]]))} />
                  <NumberInput {...num((f) => f.position[1])} onChange={(v) => edit((f) => (f.position = [f.position[0], v]))} />
                </Row>
                <Row label="Rotation (°)" hint="Degrees, clockwise on screen: 90 = pointing down, 270 = vertical with the first pixel at the bottom">
                  <NumberInput {...num((f) => f.rotation)} step={15} fineStep={1} onChange={(v) => edit((f) => (f.rotation = v))} />
                </Row>
                <Row label="Length" hint="Scene length the pixels are spread over, centred on the position (0 = all pixels in one point)">
                  <NumberInput {...num((f) => f.length)} onChange={(v) => edit((f) => (f.length = v))} />
                </Row>
                <Row label="Dimmer" hint="The dimmer macro this fixture follows (faders on the Dimmers page); none = always full">
                  <select value={opt((f) => f.dimmer_macro ?? '')} onChange={(e) => edit((f) => (f.dimmer_macro = e.target.value || null))}>
                    {mixedOption(opt((f) => f.dimmer_macro ?? ''))}
                    <option value="">none</option>
                    {dimmerNames.map((d) => (
                      <option key={d.name} value={d.name}>
                        {d.name}
                        {rig?.dimmer_names?.[d.name] ? ` — ${rig.dimmer_names[d.name]}` : ''}
                      </option>
                    ))}
                  </select>
                </Row>
                <Row label="Reacts to strobo" hint="The fixture flashes on strobo peaks (audio or manual); off = it only shows the idle pattern">
                  <Toggle
                    checked={same((f) => f.react_to_strobo) === true}
                    mixed={same((f) => f.react_to_strobo) === MIXED}
                    onChange={(v) => edit((f) => (f.react_to_strobo = v))}
                  />
                </Row>
                {fxs.every((f) => typeOf(f)?.channels.some((c) => c.shutter)) && (
                  <Row label="Real strobo" hint="Also drive the fixture's own shutter channel on strobo peaks, for a hardware flash">
                    <Toggle
                      checked={same((f) => f.real_strobo) === true}
                      mixed={same((f) => f.real_strobo) === MIXED}
                      onChange={(v) => edit((f) => (f.real_strobo = v))}
                    />
                  </Row>
                )}
              </div>
              <div>
                <Row label="Hue source" hint="Where the hue comes from: a group's macro colour, or a constant">
                  <select value={hueSource} onChange={(e) => edit((f) => (f.hue_source = e.target.value as FixtureInstance['hue_source']))}>
                    {mixedOption(hueSource)}
                    <option value="group">own group</option>
                    <option value="A">group A</option>
                    <option value="B">group B</option>
                    <option value="const">constant</option>
                  </select>
                  {hueSource === 'const' && <NumberInput {...num((f) => f.hue)} onChange={(v) => edit((f) => (f.hue = v))} />}
                </Row>
                <Row label="Saturation source" hint="Where the saturation comes from: a group's macro colour, or a constant">
                  <select
                    value={satSource}
                    onChange={(e) => edit((f) => (f.saturation_source = e.target.value as FixtureInstance['saturation_source']))}
                  >
                    {mixedOption(satSource)}
                    <option value="group">own group</option>
                    <option value="A">group A</option>
                    <option value="B">group B</option>
                    <option value="const">constant</option>
                  </select>
                  {satSource === 'const' && (
                    <NumberInput {...num((f) => f.saturation)} onChange={(v) => edit((f) => (f.saturation = v))} />
                  )}
                </Row>
                <Row label="Brightness source" hint="Strobo / idle pipeline (normal) or a constant brightness">
                  <select
                    value={briSource}
                    onChange={(e) => edit((f) => (f.brightness_source = e.target.value as FixtureInstance['brightness_source']))}
                  >
                    {mixedOption(briSource)}
                    <option value="pipeline">strobo / idle pipeline</option>
                    <option value="const">constant</option>
                  </select>
                  {briSource === 'const' && (
                    <NumberInput {...num((f) => f.brightness)} onChange={(v) => edit((f) => (f.brightness = v))} />
                  )}
                </Row>
                <Row label="Idle remap min / max" hint="Idle brightness = lerp(min, max, mask ^ 2^curve); min above max inverts the mask">
                  <NumberInput {...num((f) => f.idle_mask_range.min)} onChange={(v) => edit((f) => (f.idle_mask_range.min = v))} className="w-20" />
                  <NumberInput {...num((f) => f.idle_mask_range.max)} onChange={(v) => edit((f) => (f.idle_mask_range.max = v))} className="w-20" />
                </Row>
                <Row label="Idle remap curve" hint="Exponent of the remap: mask ^ 2^curve; 0 = linear, above 0 darkens the mid-tones">
                  <NumberInput {...num((f) => f.idle_mask_range.curve)} onChange={(v) => edit((f) => (f.idle_mask_range.curve = v))} className="w-20" />
                </Row>
                <Row label="Remap only when" hint="The remap applies only while this macro is on (e.g. Invert Discoball); always = never conditional">
                  <select
                    value={opt((f) => f.idle_mask_range.macro ?? '')}
                    onChange={(e) => edit((f) => (f.idle_mask_range.macro = e.target.value || null))}
                  >
                    {mixedOption(opt((f) => f.idle_mask_range.macro ?? ''))}
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
          {fx && (
            <div className="mt-4 border-t border-seam pt-3">
              <p className="lbl mb-1.5 text-[10px] text-dim">Fixture type values · tick to override for this fixture · ↺ back to the type</p>
              {overrideRow<number>({
                label: 'Gamma',
                hint: 'Device curve: sent = value ^ gamma. 1 = unchanged (v2 / v3 decode it themselves); ~2.2 for fixtures without a curve',
                get: (f) => f.gamma,
                set: (f, v) => (f.gamma = v),
                def: (f) => typeOf(f)?.gamma ?? 1,
                show: (v) => v,
                input: (value, disabled, editEach) => (
                  <NumberInput
                    value={value}
                    placeholder={value == null ? 'multiple' : undefined}
                    disabled={disabled}
                    min={0.1}
                    max={5}
                    className="w-20 shrink"
                    onChange={(v) => editEach(() => v)}
                  />
                ),
              })}
              {overrideRow<HSB>({
                label: 'Strobo colour (HSB)',
                hint: 'Colour of this fixture\'s strobo flash: hue, saturation, brightness, each 0–1',
                get: (f) => f.strobo_color,
                set: (f, v) => (f.strobo_color = v),
                def: (f) => typeOf(f)?.strobo_color ?? WHITE,
                show: (v) => <span className="inline-block size-2.5 align-middle" style={{ background: hsvCss(v.h, v.s, v.b) }} />,
                input: hsbInputs,
              })}
              {ftype &&
                ftype.channels
                  .filter((c) => c.value != null && c.name)
                  .map((c) =>
                    overrideRow<number>({
                      label: `Channel “${c.name}”`,
                      hint: `Constant DMX value of the “${c.name}” channel (0–255), e.g. a mode or a fixed dimmer`,
                      get: (f) => f.channel_values?.[c.name!],
                      set: (f, v) => {
                        f.channel_values = { ...(f.channel_values ?? {}) }
                        if (v) f.channel_values[c.name!] = v
                        else delete f.channel_values[c.name!]
                      },
                      def: () => c.value!,
                      show: (v) => v,
                      input: (value, disabled, editEach) => (
                        <NumberInput
                          value={value}
                          placeholder={value == null ? 'multiple' : undefined}
                          disabled={disabled}
                          integer
                          min={0}
                          max={255}
                          className="w-20 shrink"
                          onChange={(v) => editEach(() => v)}
                        />
                      ),
                    }),
                  )}
              {sharedType === MIXED && <p className="lbl mt-1 text-[10px] text-dim">Channel values: select fixtures of one type.</p>}
            </div>
          )}
        </div>
      </Section>

      <Section
        index="04"
        title="Placement"
        bodyClassName="p-3 min-h-0 overflow-auto"
        tip="Where the fixtures sit in the scene square, and what each sends right now. Selected fixtures are outlined"
      >
        {/* in the single-column layout the preview and the output monitor share one row */}
        <div className="grid grid-cols-2 gap-3 wide:block">
          <div className="min-w-0">
            <Preview preview={engine.preview} state={engine.state} highlight={selectedNames} />
            <p className="mt-2 text-[11px] text-dim">
              Changes apply live (Enter or leaving a field); the rig’s Save writes the rig file, Revert reloads it. The outlined
              pixel is the first one.
            </p>
          </div>
          {fx && (
            <div className="min-w-0 wide:mt-3">
              <OutputMonitor state={engine.state} only={selectedNames} />
            </div>
          )}
        </div>
      </Section>
    </div>
  )
}
