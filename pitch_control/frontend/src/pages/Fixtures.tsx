import { useCallback, useEffect, useRef, useState } from 'react'
import { api, channelCount, slotKind, type ChannelSlot, type FixtureType, type HSB, type MacroDef, type PixelFormat } from '../api'
import { hsvCss } from '../components/MacroControl'
import { Button, NumberInput, Row, Section } from '../components/forms'
import { OPEN_TYPE_KEY } from './Rig'

type Kind = ReturnType<typeof slotKind>

const KIND_LABEL: Record<Kind, string> = { value: 'constant', macro: 'macro', shutter: 'shutter', pixels: 'pixels' }
const FORMATS: PixelFormat[] = ['R', 'RGB', 'RGBW']

interface Status {
  unsaved: string[]
  usage: Record<string, string[]>
}

type Prompt = { kind: 'name'; action: 'new' | 'duplicate' | 'rename' } | { kind: 'delete' }

/** A slot of another kind, keeping its name. */
function slotOfKind(slot: ChannelSlot, kind: Kind, firstMacro: string): ChannelSlot {
  const name = slot.name ?? null
  if (kind === 'value') return { name, value: 0 }
  if (kind === 'macro') return { name, macro: firstMacro }
  if (kind === 'shutter') return { name, shutter: { open: 0, strobo: 255 } }
  return { name, pixels: 'RGB' }
}

/** The DMX channels of a type, as "start–end: what" lines. */
function channelMap(t: FixtureType): { from: number; to: number; text: string }[] {
  const rows: { from: number; to: number; text: string }[] = []
  let ch = 1
  for (const s of t.channels) {
    const n = s.pixels ? t.pixels * s.pixels.length : 1
    const label = s.name ? `${s.name} ` : ''
    let text: string
    if (s.pixels) text = `${label}pixels ${s.pixels} × ${t.pixels}`
    else if (s.value != null) text = `${label}= ${s.value}`
    else if (s.macro) text = `${label}← ${s.macro}`
    else text = `${label}shutter (open ${s.shutter?.open}, strobe ${s.shutter?.strobo})`
    rows.push({ from: ch, to: ch + n - 1, text })
    ch += n
  }
  return rows
}

/**
 * Fixture types: everything shared by all fixtures of one model (output, pixels, channel layout,
 * gamma, strobo defaults), one JSON file each in fixtures/types/. Edits apply live; Save writes
 * the file, Revert reloads it. Rig fixtures can override some values on the Rig page.
 */
export function Fixtures({ defs }: { defs: Record<string, MacroDef> }) {
  const [types, setTypes] = useState<Record<string, FixtureType>>({})
  const [status, setStatus] = useState<Status>({ unsaved: [], usage: {} })
  const [selected, setSelected] = useState<string>('')
  const [prompt, setPrompt] = useState<Prompt | null>(null)
  const [name, setName] = useState('')
  const [message, setMessage] = useState<string | null>(null)

  const loadStatus = useCallback(() => api.get<Status>('/api/fixture-types/status').then(setStatus), [])
  const reload = useCallback(
    async (select?: string) => {
      const all = await api.get<Record<string, FixtureType>>('/api/fixture-types')
      setTypes(all)
      loadStatus()
      setSelected((cur) => {
        let wanted = select ?? cur
        if (!wanted) {
          try {
            wanted = sessionStorage.getItem(OPEN_TYPE_KEY) ?? ''
            sessionStorage.removeItem(OPEN_TYPE_KEY)
          } catch {
            wanted = ''
          }
        }
        return all[wanted] ? wanted : (Object.keys(all)[0] ?? '')
      })
    },
    [loadStatus],
  )
  useEffect(() => {
    reload()
  }, [reload])

  const t = types[selected]
  const unsaved = status.unsaved.includes(selected)
  const usedIn = status.usage[selected] ?? []
  // macros a channel can follow: the faders (dimmers first, they're what fixtures usually bind)
  const macroNames = Object.values(defs)
    .filter((d) => d.kind === 'fader')
    .sort((a, b) => (a.page === 'dimmers' ? 0 : 1) - (b.page === 'dimmers' ? 0 : 1))
    .map((d) => d.name)

  // live edits are chained so Save / Revert / Rename wait for the last one
  const live = useRef<Promise<unknown>>(Promise.resolve())
  const applyLive = (next: FixtureType) => {
    live.current = live.current
      .then(() => api.put(`/api/fixture-types/${encodeURIComponent(next.name)}?persist=false`, next))
      .then(loadStatus)
      .catch((e) => setMessage(String(e)))
  }
  const edit = (fn: (t: FixtureType) => void, liveNow = true) => {
    if (!t) return
    const next = structuredClone(t)
    fn(next)
    setTypes((all) => ({ ...all, [next.name]: next }))
    if (liveNow) applyLive(next)
  }

  const save = async () => {
    await live.current
    const res = await api.put<{ problems: string[] }>(`/api/fixture-types/${encodeURIComponent(selected)}`, types[selected])
    setMessage(res.problems.length ? `Saved · rig: ${res.problems.join('; ')}` : 'Saved')
    loadStatus()
  }
  const revert = async () => {
    await live.current
    const fresh = await api.post<FixtureType>(`/api/fixture-types/${encodeURIComponent(selected)}/reload`)
    setTypes((all) => ({ ...all, [selected]: { ...fresh, name: selected } }))
    setMessage(null)
    loadStatus()
  }

  const run = async (fn: () => Promise<string | undefined>) => {
    try {
      await live.current
      const select = await fn()
      setPrompt(null)
      await reload(select)
    } catch (e) {
      setMessage(e instanceof Error ? e.message : String(e))
    }
  }
  const submitName = (action: 'new' | 'duplicate' | 'rename') =>
    run(async () => {
      const n = name.trim()
      if (action === 'rename') {
        const res = await api.post<{ name: string; rigs_updated: string[] }>(`/api/fixture-types/${encodeURIComponent(selected)}/rename`, { name: n })
        setMessage(res.rigs_updated.length ? `Renamed · updated rigs: ${res.rigs_updated.join(', ')}` : 'Renamed')
        return res.name
      }
      await api.post('/api/fixture-types', action === 'new' ? { name: n } : { name: n, copy_of: selected })
      setMessage(null)
      return n
    })
  const askName = (action: 'new' | 'duplicate' | 'rename') => {
    setMessage(null)
    setName(action === 'rename' ? selected : action === 'duplicate' ? `${selected} copy` : '')
    setPrompt({ kind: 'name', action })
  }

  const moveSlot = (i: number, d: -1 | 1) =>
    edit((x) => {
      const j = i + d
      if (j < 0 || j >= x.channels.length) return
      ;[x.channels[i], x.channels[j]] = [x.channels[j], x.channels[i]]
    })

  const hsb = (c: HSB) => (
    <>
      {(['h', 's', 'b'] as const).map((k) => (
        <NumberInput key={k} value={c[k]} min={0} max={1} className="w-14 shrink" onChange={(v) => edit((x) => (x.strobo_color = { ...x.strobo_color, [k]: v }))} />
      ))}
      <span className="size-3.5 flex-none" style={{ background: hsvCss(c.h, c.s, c.b) }} />
    </>
  )

  const count = t ? channelCount(t) : 0

  return (
    <div className="grid gap-1.5 wide:h-full wide:grid-cols-[17rem_minmax(0,1fr)_22rem] wide:grid-rows-[minmax(0,1fr)]">
      <Section
        index="01"
        title="Fixture types"
        right={`${Object.keys(types).length} types`}
        bodyClassName="p-2.5 min-h-0 gap-2"
        tip="Fixture types: what a kind of light is (pixels, channels, defaults). One file each in config/fixtures; rigs place them"
      >
        <ul className="flex min-h-0 flex-1 flex-col gap-0.5 overflow-auto select-none">
          {Object.values(types).map((x) => (
            <li key={x.name}>
              <button
                onClick={() => {
                  setSelected(x.name)
                  setMessage(null)
                }}
                className={`flex w-full items-center gap-2 px-2 py-1.5 text-left text-[13px] ${x.name === selected ? 'glow-on bg-ink text-ground' : 'hover:bg-panel-2'}`}
                data-hint="list"
                data-tip={status.usage[x.name]?.length ? `Used in: ${status.usage[x.name].join(', ')}` : 'Not used in any rig'}
              >
                <span className="flex-1 truncate">{x.name}</span>
                {status.unsaved.includes(x.name) && <span className={`size-[6px] flex-none ${x.name === selected ? 'bg-ground' : 'dot-on'}`} data-hint="info" data-tip="Unsaved edits: live in the engine, Save writes the type file" />}
                <span className="font-mono text-[11px] opacity-70">{x.transport === 'pitchpls_v2' ? 'serial' : `${channelCount(x)} ch`}</span>
              </button>
            </li>
          ))}
        </ul>

        {prompt === null && (
          <div className="flex flex-wrap gap-1.5">
            <Button onClick={() => askName('new')} tip="Create a new type: 1 RGB pixel on DMX; shape it in the editor">
              New
            </Button>
            <Button onClick={() => askName('duplicate')} disabled={!t} tip="Copy the selected type under a new name, as a starting point for a similar light">
              Duplicate
            </Button>
            <Button onClick={() => askName('rename')} disabled={!t} tip="Rename the type file; every rig that uses it is updated">
              Rename
            </Button>
            <span data-tip={usedIn.length ? `Cannot delete: used in ${usedIn.join(', ')}` : undefined}>
              <Button onClick={() => setPrompt({ kind: 'delete' })} disabled={!t || usedIn.length > 0} tip="Delete the type file (asks first); refused while a rig uses it">
                Delete
              </Button>
            </span>
          </div>
        )}
        {prompt?.kind === 'name' && (
          <div className="flex flex-col gap-1.5 border border-edge p-2">
            <span className="lbl text-[10px] text-dim">
              {prompt.action === 'new' ? 'New fixture type (1 RGB pixel on DMX)' : prompt.action === 'duplicate' ? `Duplicate “${selected}”` : `Rename “${selected}” — rigs using it are updated`}
            </span>
            <input
              type="text"
              autoFocus
              onFocus={(e) => e.currentTarget.select()}
              value={name}
              placeholder="type name"
              data-tip="Name of the type file (also its name in rigs): letters, digits, space, - _ . ; ⏎ confirms, Esc cancels"
              onChange={(e) => setName(e.target.value)}
              onKeyDown={(e) => {
                if (e.key === 'Enter') submitName(prompt.action)
                else if (e.key === 'Escape') setPrompt(null)
              }}
            />
            <div className="flex gap-1.5">
              <Button primary onClick={() => submitName(prompt.action)} disabled={!name.trim()}>
                {prompt.action === 'new' ? 'Create' : prompt.action === 'rename' ? 'Rename' : 'Duplicate'}
              </Button>
              <Button onClick={() => setPrompt(null)}>Cancel</Button>
            </div>
          </div>
        )}
        {prompt?.kind === 'delete' && (
          <div className="flex flex-col gap-1.5 border border-ink p-2">
            <span className="text-[11px]">Delete the fixture type file “{selected}”? A committed file can be restored from git.</span>
            <div className="flex gap-1.5">
              <Button primary onClick={() => run(async () => (await api.delete(`/api/fixture-types/${encodeURIComponent(selected)}`), ''))}>
                Delete
              </Button>
              <Button onClick={() => setPrompt(null)}>Cancel</Button>
            </div>
          </div>
        )}
        {message && <p className="text-[11px] text-ink">{message}</p>}
      </Section>

      <Section
        index="02"
        title={t ? t.name : 'Fixture type'}
        right={
          t && (
            <>
              {unsaved ? (
                <span className="inline-flex items-center gap-1.5 text-ink" data-hint="info" data-tip="Edits are live in the engine but not written to the type file yet">
                  <span className="dot-on inline-block size-[7px]" />
                  unsaved
                </span>
              ) : (
                'saved'
              )}
              <button className="lbl h-[18px] border border-edge px-2 text-[10px] text-ink disabled:opacity-35" disabled={!unsaved} onClick={revert} data-tip="Throw away the unsaved edits and reload the type from its file">
                Revert
              </button>
              <button className="lbl glow-on h-[18px] bg-ink px-2 text-[10px] text-ground disabled:opacity-35" disabled={!unsaved} onClick={save} data-tip="Write the type to its file in config/fixtures">
                Save
              </button>
            </>
          )
        }
        bodyClassName="p-3 min-h-0 overflow-auto"
        tip="Editor of the selected fixture type. Edits apply to the lights at once; Save writes the file"
      >
        {t && (
          <>
            <Row label="Description" hint="Free text about this light; shown as the tip of the type in the Rig page's fixture list">
              <textarea
                rows={2}
                className="w-full resize-none text-[12px] leading-snug"
                value={t.description}
                onChange={(e) => edit((x) => (x.description = e.target.value), false)}
                onBlur={() => applyLive(types[selected])}
              />
            </Row>
            <Row label="Output" hint="DMX (Enttec / Art-Net, with a channel layout) or the PitchPlease v2 serial protocol (3 bytes per pixel)">
              <select value={t.transport} onChange={(e) => edit((x) => (x.transport = e.target.value as FixtureType['transport']))}>
                <option value="dmx">DMX</option>
                <option value="pitchpls_v2">PitchPlease v2 serial</option>
              </select>
            </Row>
            <Row label="Pixels" hint="Number of pixels (individually controlled segments) of one fixture, 1–512">
              <NumberInput value={t.pixels} integer min={1} max={512} onChange={(v) => edit((x) => (x.pixels = v))} />
            </Row>
            <Row
              label="Gamma"
              hint="Device curve: sent = value ^ gamma. 1 = unchanged (v2 / v3 decode it themselves); ~2.2 for fixtures without a curve"
            >
              <NumberInput value={t.gamma} min={0.1} max={5} className="w-20 shrink" onChange={(v) => edit((x) => (x.gamma = v))} />
            </Row>
            <Row label="Strobo colour (HSB)" hint="Colour of the strobo flash: hue, saturation, brightness, each 0–1; a rig fixture can override it">
              {hsb(t.strobo_color)}
            </Row>
            <Row label="Used in" hint="Rigs that place this type; a type in use cannot be deleted">
              <span className="text-[12px] text-dim">{usedIn.length ? usedIn.join(', ') : 'no rig'}</span>
            </Row>

            <div className="mt-3 border-t border-seam pt-3">
              <p className="lbl mb-2 text-[10px] text-dim">Channel layout · in DMX order from the fixture's address</p>
              {t.transport === 'pitchpls_v2' ? (
                <p className="text-[12px] text-dim">The PitchPlease v2 serial protocol sends 3 bytes (RGB) per pixel; a channel layout isn't used.</p>
              ) : (
                <div className="flex flex-col gap-1">
                  {t.channels.map((slot, i) => {
                    const kind = slotKind(slot)
                    return (
                      <div key={i} data-tip={`DMX channel ${i + 1} of the fixture: what it does, its name, and its value`} className="flex flex-wrap items-center gap-1.5 bg-panel-2 px-2 py-1 text-[12px]">
                        <span className="w-6 font-mono text-[11px] text-dim">{String(i + 1).padStart(2, '0')}</span>
                        <select
                          value={kind}
                          data-tip="What this DMX channel does: a constant, a macro (e.g. a dimmer), the shutter, or the pixel colours"
                          onChange={(e) => edit((x) => (x.channels[i] = slotOfKind(slot, e.target.value as Kind, macroNames[0] ?? 'Dimmer 01')))}
                        >
                          {(Object.keys(KIND_LABEL) as Kind[]).map((k) => (
                            <option key={k} value={k}>
                              {KIND_LABEL[k]}
                            </option>
                          ))}
                        </select>
                        <input
                          type="text"
                          className="w-28"
                          placeholder="name"
                          value={slot.name ?? ''}
                          onChange={(e) => edit((x) => (x.channels[i].name = e.target.value || null), false)}
                          onBlur={() => applyLive(types[selected])}
                          data-tip="Name of the channel. A named constant can be overridden per fixture on the Rig page"
                        />
                        {kind === 'value' && (
                          <NumberInput value={slot.value} integer min={0} max={255} className="w-16" tip="Constant value sent on this channel (0–255)" onChange={(v) => edit((x) => (x.channels[i].value = v))} />
                        )}
                        {kind === 'macro' && (
                          <select value={slot.macro ?? ''} data-tip="Macro whose value (0–1) is sent on this channel, e.g. a dimmer fader" onChange={(e) => edit((x) => (x.channels[i].macro = e.target.value))}>
                            {!macroNames.includes(slot.macro ?? '') && <option value={slot.macro ?? ''}>{slot.macro} (missing)</option>}
                            {macroNames.map((m) => (
                              <option key={m}>{m}</option>
                            ))}
                          </select>
                        )}
                        {kind === 'shutter' && (
                          <>
                            <span className="lbl text-[10px] text-dim">open</span>
                            <NumberInput value={slot.shutter?.open} integer min={0} max={255} className="w-14" tip="Shutter channel value for open (no strobe), 0–255" onChange={(v) => edit((x) => (x.channels[i].shutter = { ...x.channels[i].shutter!, open: v }))} />
                            <span className="lbl text-[10px] text-dim">strobe</span>
                            <NumberInput value={slot.shutter?.strobo} integer min={0} max={255} className="w-14" tip="Shutter channel value for the fixture's own strobe, 0–255" onChange={(v) => edit((x) => (x.channels[i].shutter = { ...x.channels[i].shutter!, strobo: v }))} />
                          </>
                        )}
                        {kind === 'pixels' && (
                          <select value={slot.pixels ?? 'RGB'} data-tip="Colour format of the pixel channels: R, RGB or RGBW (white is extracted from RGB)" onChange={(e) => edit((x) => (x.channels[i].pixels = e.target.value as PixelFormat))}>
                            {FORMATS.map((f) => (
                              <option key={f}>{f}</option>
                            ))}
                          </select>
                        )}
                        <span className="ml-auto flex gap-1">
                          <button className="px-1 text-dim hover:text-ink disabled:opacity-30" disabled={i === 0} data-tip="Move this channel up: earlier in the DMX order" onClick={() => moveSlot(i, -1)}>
                            ↑
                          </button>
                          <button className="px-1 text-dim hover:text-ink disabled:opacity-30" disabled={i === t.channels.length - 1} data-tip="Move this channel down: later in the DMX order" onClick={() => moveSlot(i, 1)}>
                            ↓
                          </button>
                          <button
                            className="px-1 text-dim hover:text-ink disabled:opacity-30"
                            disabled={t.channels.length === 1}
                            data-tip="Remove this channel from the layout"
                            onClick={() => edit((x) => x.channels.splice(i, 1))}
                          >
                            ✕
                          </button>
                        </span>
                      </div>
                    )
                  })}
                  <div className="mt-1">
                    <Button onClick={() => edit((x) => x.channels.push({ name: null, value: 0 }))} tip="Append a constant channel (value 0) at the end of the layout">
                      Add channel
                    </Button>
                  </div>
                </div>
              )}
            </div>
          </>
        )}
      </Section>

      <Section
        index="03"
        title="Channel map"
        right={t && t.transport === 'dmx' && `${count} channels`}
        bodyClassName="p-3 min-h-0 overflow-auto"
        tip="The DMX channels of one fixture, counted from its address, and how many fit one universe (512 channels)"
      >
        {t && t.transport === 'dmx' && (
          <>
            <div className="flex flex-col gap-px font-mono text-[12px]">
              {channelMap(t).map((r, i) => (
                <div key={i} className="flex gap-3 bg-panel-2 px-2 py-1">
                  <span className="w-16 flex-none text-dim">{r.from === r.to ? r.from : `${r.from}–${r.to}`}</span>
                  <span className="min-w-0 flex-1 truncate" data-tip={r.text}>
                    {r.text}
                  </span>
                </div>
              ))}
            </div>
            <p className="lbl mt-3 text-[10px] text-dim">
              {count} channels · {Math.floor(512 / Math.max(count, 1))} fixtures of this type fit one universe
            </p>
          </>
        )}
        {t && t.transport === 'pitchpls_v2' && (
          <p className="text-[12px] text-dim">
            v2 serial: {t.pixels} pixels × 3 bytes, sent on the PitchPlease v2 output (Outputs page).
          </p>
        )}
      </Section>
    </div>
  )
}
