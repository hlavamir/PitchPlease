import { useEffect, useMemo, useRef, useState, type PointerEvent } from 'react'
import { api } from '../api'
import { Button, Section, Toggle } from '../components/forms'
import type { EngineConnection } from '../useEngine'
import { isTyping, useGridNav, type NavItem } from '../useGridNav'

const UNIVERSES = [0, 1, 2, 3]
const PER_PAGE = 64 // 4 rows × 16
const SUBPAGES = 512 / PER_PAGE
const POLL_MS = 100 // live output values

// universe and subpage stay as they were when coming back to the page
const memory = { universe: 0, subpage: 0 }

interface Strip {
  channel: number // 1–512
  live: number // output value as sent (0–255)
  override: number | undefined
  fixture?: string // "Pinspot 1 · 3": which fixture uses the channel, and its channel number
}

/** One DMX channel: drag up/down to set it (switches the override on), the switch releases it. */
function ChannelStrip({
  strip,
  selected,
  onSelect,
  setValue,
  release,
}: {
  strip: Strip
  selected: boolean
  onSelect: () => void
  setValue: (v: number) => void
  release: () => void
}) {
  const [dragValue, setDragValue] = useState<number | null>(null)
  const drag = useRef<{ startY: number; start: number; height: number; fine: boolean; frame: number; pending: number | null } | null>(null)
  const on = strip.override !== undefined
  const value = dragValue ?? strip.override ?? strip.live

  const send = () => {
    const d = drag.current
    if (!d) return
    d.frame = 0
    if (d.pending !== null) setValue(d.pending)
    d.pending = null
  }

  const onPointerDown = (e: PointerEvent<HTMLDivElement>) => {
    if (e.button !== 0) return
    onSelect()
    e.currentTarget.setPointerCapture(e.pointerId)
    const rect = e.currentTarget.getBoundingClientRect()
    // relative drag from the value shown: no jump, an unswitched channel starts at its live value
    drag.current = { startY: e.clientY, start: value, height: Math.max(rect.height, 40), fine: e.shiftKey, frame: 0, pending: null }
    setDragValue(value)
  }
  const onPointerMove = (e: PointerEvent<HTMLDivElement>) => {
    const d = drag.current
    if (!d) return
    if (e.shiftKey !== d.fine) {
      d.fine = e.shiftKey
      d.startY = e.clientY
      d.start = dragValue ?? d.start
    }
    const next = Math.round(Math.min(255, Math.max(0, d.start + ((d.startY - e.clientY) / d.height) * 255 * (d.fine ? 0.1 : 1))))
    setDragValue(next)
    d.pending = next
    if (!d.frame) d.frame = requestAnimationFrame(send)
  }
  const onPointerUp = () => {
    const d = drag.current
    if (d?.frame) cancelAnimationFrame(d.frame)
    send()
    drag.current = null
    setDragValue(null)
  }

  const fill = value / 255
  return (
    <div className={`flex min-h-0 min-w-0 flex-col bg-panel ${selected ? 'glow-sel' : ''}`} title={strip.fixture ? `${strip.fixture}` : 'not used by a fixture'}>
      <div className={`flex h-[26px] flex-none items-center justify-between gap-1 px-1.5 ${selected ? 'bg-ink text-ground' : 'border-b border-seam'}`}>
        <span className="font-mono text-[12px]">{String(strip.channel).padStart(3, '0')}</span>
        <Toggle
          checked={on}
          onChange={(v) => {
            onSelect()
            if (v) setValue(strip.live)
            else release()
          }}
        />
      </div>
      <div
        className="relative min-h-0 flex-1 cursor-ns-resize touch-none select-none"
        onPointerDown={onPointerDown}
        onPointerMove={onPointerMove}
        onPointerUp={onPointerUp}
        onPointerCancel={onPointerUp}
      >
        {/* overridden: bright ink; following the output: faint */}
        <div
          className={`absolute inset-x-1.5 bottom-1.5 ${on || dragValue !== null ? 'glow-on' : ''}`}
          style={{
            height: `calc((100% - 12px) * ${fill.toFixed(4)})`,
            background: on || dragValue !== null ? 'var(--color-ink)' : 'rgb(var(--ink-rgb) / 0.28)',
          }}
        />
        <div className="absolute inset-x-1.5 top-1.5 bottom-1.5 border border-seam" />
      </div>
      <div className="flex h-[22px] flex-none items-center justify-between gap-1 border-t border-seam px-1.5">
        <span className="lbl min-w-0 truncate text-[9px] text-dim">{strip.fixture ?? '—'}</span>
        <span className={`font-mono text-[13px] ${on ? 'text-glow' : 'text-dim'}`}>{value}</span>
      </div>
    </div>
  )
}

/**
 * Control Desk: every DMX output channel as a slider, 64 per subpage. A channel with its override
 * switched on sends the slider value instead of what the fixtures compute. Overrides are saved and
 * restored on start; the header shows how many are active.
 */
export function ControlDesk({ engine }: { engine: EngineConnection }) {
  const [universe, setUniverseState] = useState(memory.universe)
  const [subpage, setSubpageState] = useState(memory.subpage)
  const [live, setLive] = useState<number[]>(() => Array(512).fill(0))
  const [confirmReset, setConfirmReset] = useState(false)
  const setUniverse = (u: number) => setUniverseState((memory.universe = u))
  const setSubpage = (p: number) => setSubpageState((memory.subpage = p))

  // Q / E: previous / next subpage (the keyboard selection keeps its slot)
  useEffect(() => {
    const onKey = (e: KeyboardEvent) => {
      if (isTyping(e) || e.metaKey || e.ctrlKey || e.altKey) return
      const key = e.key.toLowerCase()
      if (key !== 'q' && key !== 'e') return
      e.preventDefault()
      setSubpageState((p) => (memory.subpage = Math.min(SUBPAGES - 1, Math.max(0, p + (key === 'e' ? 1 : -1)))))
    }
    window.addEventListener('keydown', onKey)
    return () => window.removeEventListener('keydown', onKey)
  }, [])

  // live output values of the shown universe
  useEffect(() => {
    let alive = true
    const poll = () =>
      api
        .get<{ values: number[] }>(`/api/dmx/${universe}`)
        .then((r) => alive && setLive(r.values))
        .catch(() => undefined)
    poll()
    const id = window.setInterval(poll, POLL_MS)
    return () => {
      alive = false
      window.clearInterval(id)
    }
  }, [universe])

  const all = engine.state?.overrides ?? {}
  const overrides = all[String(universe)] ?? {}
  const total = Object.values(all).reduce((n, chans) => n + Object.keys(chans).length, 0)

  // which fixture uses each channel of this universe
  const fixtureAt = useMemo(() => {
    const map: Record<number, string> = {}
    for (const fx of engine.state?.fixtures ?? []) {
      if (fx.transport !== 'dmx' || fx.universe !== universe) continue
      fx.output.forEach((_, i) => (map[fx.address + i] = `${fx.name} · ${i + 1}`))
    }
    return map
  }, [engine.state?.fixtures, universe])

  const first = subpage * PER_PAGE + 1
  const strips: Strip[] = Array.from({ length: PER_PAGE }, (_, i) => {
    const channel = first + i
    return { channel, live: live[channel - 1] ?? 0, override: overrides[String(channel)], fixture: fixtureAt[channel] }
  })

  const setValue = (channel: number, v: number) => engine.setOverride(universe, channel, v)
  const release = (channel: number) => engine.setOverride(universe, channel, null)

  // keys: W/S/A/D move, ↑/↓ change (switches the override on), ⏎ switches the override on / off
  const navItem = (st: Strip): NavItem => ({
    id: `ch-${st.channel}`,
    label: `Ch ${st.channel}${st.fixture ? ` (${st.fixture})` : ''}`,
    value: `${st.override ?? st.live}${st.override !== undefined ? ' OVR' : ''}`,
    adjust: (dir, fine) => setValue(st.channel, Math.min(255, Math.max(0, (st.override ?? st.live) + dir * (fine ? 1 : 5)))),
    press: (down) => down && (st.override !== undefined ? release(st.channel) : setValue(st.channel, st.live)),
  })
  const rows = [0, 1, 2, 3].map((r) => strips.slice(r * 16, r * 16 + 16).map(navItem))
  const { selectedId, select } = useGridNav('Control Desk', rows)

  const overridesOnSubpage = (p: number) => Object.keys(overrides).filter((c) => Math.floor((Number(c) - 1) / PER_PAGE) === p).length

  return (
    <div className="flex h-full flex-col gap-1.5">
      <div className="flex flex-none flex-wrap items-center gap-1.5">
        <label className="lbl flex items-center gap-2 text-[11px] text-dim">
          Universe
          <select value={universe} onChange={(e) => setUniverse(Number(e.target.value))}>
            {UNIVERSES.map((u) => (
              <option key={u} value={u}>
                {u}
              </option>
            ))}
          </select>
        </label>
        <div className="ml-2 flex border border-edge">
          {Array.from({ length: SUBPAGES }, (_, p) => {
            const n = overridesOnSubpage(p)
            return (
              <button
                key={p}
                onClick={() => setSubpage(p)}
                className={`lbl relative flex h-8 items-center gap-1.5 border-r border-edge px-3 font-mono text-[11px] last:border-r-0 ${
                  p === subpage ? 'glow-on bg-ink text-ground' : 'text-ink hover:bg-panel-2'
                }`}
                title={n ? `${n} override(s) on this subpage` : undefined}
              >
                {p * PER_PAGE + 1}–{(p + 1) * PER_PAGE}
                {n > 0 && <span className={`size-[5px] ${p === subpage ? 'bg-ground' : 'dot-on'}`} />}
              </button>
            )
          })}
        </div>
        <div className="ml-auto flex items-center gap-1.5">
          {confirmReset ? (
            <>
              <span className="text-[11px]">
                Release all {total} override{total === 1 ? '' : 's'} in every universe?
              </span>
              <Button
                primary
                onClick={async () => {
                  await api.delete('/api/overrides')
                  setConfirmReset(false)
                }}
              >
                Release all
              </Button>
              <Button onClick={() => setConfirmReset(false)}>Cancel</Button>
            </>
          ) : (
            <>
              <span className="lbl text-[11px] text-dim">
                {total} override{total === 1 ? '' : 's'} · saved across restarts
              </span>
              <Button onClick={() => setConfirmReset(true)} disabled={total === 0}>
                Reset all
              </Button>
            </>
          )}
        </div>
      </div>

      <Section
        index="01"
        title={`Universe ${universe} · channels ${first}–${first + PER_PAGE - 1}`}
        right="drag a channel to override it · the switch releases it · Q / E subpage"
        className="min-h-0 flex-1"
        bodyClassName="p-0"
      >
        <div className="grid min-h-[36rem] flex-1 grid-cols-8 gap-px bg-edge wide:min-h-0 wide:grid-cols-16 wide:grid-rows-4">
          {strips.map((st) => (
            <ChannelStrip
              key={st.channel}
              strip={st}
              selected={selectedId === `ch-${st.channel}`}
              onSelect={() => select(`ch-${st.channel}`)}
              setValue={(v) => setValue(st.channel, v)}
              release={() => release(st.channel)}
            />
          ))}
        </div>
      </Section>
    </div>
  )
}
