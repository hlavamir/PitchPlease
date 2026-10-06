import { useRef, useState, type PointerEvent } from 'react'
import type { MacroDef } from '../api'

interface Props {
  def: MacroDef
  value: number
  setMacro: (name: string, value: number) => void
  toggleMacro: (name: string) => void
  accent?: 'A' | 'B'
  colorTrack?: ColorTrack
  pending?: boolean // a MIDI value is waiting to be applied
  className?: string
}

/** A fader whose track shows colours: the full range as a gradient plus the selected colour. */
export interface ColorTrack {
  gradient: string // CSS gradient, bottom (control 0) to top (control 1)
  colorAt: (control: number) => string // the colour this fader produces at a control value
}

/** HSV (0..1, hue wraps) → CSS rgb(). */
export function hsvCss(h: number, s: number, v: number): string {
  const hh = (((h % 1) + 1) % 1) * 6
  const i = Math.floor(hh)
  const f = hh - i
  const p = v * (1 - s)
  const q = v * (1 - s * f)
  const t = v * (1 - s * (1 - f))
  const [r, g, b] = [
    [v, t, p],
    [q, v, p],
    [p, v, t],
    [p, q, v],
    [t, p, v],
    [v, p, q],
  ][i % 6]
  return `rgb(${Math.round(r * 255)}, ${Math.round(g * 255)}, ${Math.round(b * 255)})`
}

/**
 * Colour tracks for the Hue A/B and Saturation A/B faders, computed from the macro values (not the
 * auto colours), so they show what the group colour will be once Auto Color is switched off.
 */
export function colorTrackFor(name: string, macros: Record<string, number>, defs: Record<string, MacroDef>): ColorTrack | undefined {
  const m = /^(Hue|Saturation) ([AB])$/.exec(name)
  if (!m) return undefined
  const group = m[2]
  const hueDef = defs[`Hue ${group}`]
  const satDef = defs[`Saturation ${group}`]
  if (!hueDef || !satDef) return undefined
  const hue = valueInRange(hueDef, macros[hueDef.name] ?? 0)
  const sat = valueInRange(satDef, macros[satDef.name] ?? 1)
  const isHue = m[1] === 'Hue'
  const stops: string[] = []
  for (let i = 0; i <= 12; i++) {
    const t = i / 12
    const c = isHue ? hsvCss(hueDef.min + t * (hueDef.max - hueDef.min), 1, 1) : hsvCss(hue, satDef.min + t * (satDef.max - satDef.min), 1)
    stops.push(`${c} ${(t * 100).toFixed(1)}%`)
  }
  return {
    gradient: `linear-gradient(to top, ${stops.join(', ')})`,
    colorAt: (control) => (isHue ? hsvCss(valueInRange(hueDef, control), sat, 1) : hsvCss(hue, valueInRange(satDef, control), 1)),
  }
}

function valueInRange(def: MacroDef, control: number) {
  const steps = def.steps > 1 ? def.steps - 1 : 1
  const q = Math.floor(control * steps + 0.5) / steps
  return def.min + q * (def.max - def.min)
}

function accentFor(name: string): 'A' | 'B' | undefined {
  if (/\bA$/.test(name)) return 'A'
  if (/\bB$/.test(name)) return 'B'
  return undefined
}

/** One macro: vertical fader, toggle, momentary button or radio button. */
export function MacroControl({ def, value, setMacro, toggleMacro, accent, colorTrack, pending, className }: Props) {
  const group = accent ?? accentFor(def.name)
  const color = group === 'A' ? 'var(--color-group-a)' : group === 'B' ? 'var(--color-group-b)' : 'var(--color-accent)'

  if (def.kind === 'fader') {
    return (
      <Fader def={def} value={value} color={color} setMacro={setMacro} colorTrack={colorTrack} pending={pending} className={className} />
    )
  }

  const on = value > 0.5
  const base = 'h-11 w-full rounded px-2 text-sm font-medium transition-colors select-none'
  const style = on ? { background: color, color: '#111' } : undefined
  const off = on ? '' : 'bg-panel-2 text-neutral-300 hover:bg-edge'

  if (def.kind === 'momentary') {
    return (
      <button
        className={`${base} ${off}`}
        style={style}
        onPointerDown={() => setMacro(def.name, 1)}
        onPointerUp={() => setMacro(def.name, 0)}
        onPointerLeave={() => on && setMacro(def.name, 0)}
      >
        {def.label}
      </button>
    )
  }
  if (def.kind === 'radio') {
    return (
      <button className={`${base} ${off}`} style={style} onClick={() => setMacro(def.name, 1)}>
        {def.label}
      </button>
    )
  }
  if (def.kind === 'button') {
    return (
      <button className={`${base} bg-panel-2 hover:bg-edge`} onClick={() => setMacro(def.name, 1)}>
        {def.label}
      </button>
    )
  }
  return (
    <button className={`${base} ${off}`} style={style} onClick={() => toggleMacro(def.name)}>
      {def.label}
    </button>
  )
}

/**
 * Vertical fader where the whole tile is the control: drag up/down anywhere (relative, no jump on
 * click), hold Shift for fine control, double-click to reset to the default value.
 *
 * Deferred macros (hue, saturation) are only sent when the mouse is released; a dashed outline
 * marks a value that is not applied yet (also while a MIDI knob is still moving).
 */
function Fader({
  def,
  value,
  color,
  setMacro,
  colorTrack,
  pending,
  className,
}: {
  def: MacroDef
  value: number
  color: string
  setMacro: (name: string, value: number) => void
  colorTrack?: ColorTrack
  pending?: boolean
  className?: string
}) {
  const [dragValue, setDragValue] = useState<number | null>(null)
  const drag = useRef<{
    startY: number
    startValue: number
    last: number
    height: number
    fine: boolean
    pending: number | null
    frame: number
  } | null>(null)
  const current = dragValue ?? value // while dragging, show the local value (the engine echoes at ~15 fps)
  const notApplied = Boolean(pending) || (def.deferred && dragValue !== null && dragValue !== value)
  const fillColor = colorTrack ? colorTrack.colorAt(current) : color

  const send = () => {
    const d = drag.current
    if (!d) return
    d.frame = 0
    if (d.pending !== null) setMacro(def.name, d.pending)
    d.pending = null
  }

  const onPointerDown = (e: PointerEvent<HTMLDivElement>) => {
    if (e.button !== 0) return
    e.currentTarget.setPointerCapture(e.pointerId)
    const rect = e.currentTarget.getBoundingClientRect()
    drag.current = {
      startY: e.clientY,
      startValue: value,
      last: value,
      height: Math.max(rect.height - 16, 40),
      fine: e.shiftKey,
      pending: null,
      frame: 0,
    }
    setDragValue(value)
  }

  const onPointerMove = (e: PointerEvent<HTMLDivElement>) => {
    const d = drag.current
    if (!d) return
    if (e.shiftKey !== d.fine) {
      // re-anchor when Shift is pressed or released so the value does not jump
      d.fine = e.shiftKey
      d.startY = e.clientY
      d.startValue = d.last
    }
    const scale = d.fine ? 0.1 : 1
    const next = Math.min(1, Math.max(0, d.startValue + ((d.startY - e.clientY) / d.height) * scale))
    d.last = next
    setDragValue(next)
    d.pending = next
    // deferred macros wait for the release; others are sent at most once per animation frame
    if (!def.deferred && !d.frame) d.frame = requestAnimationFrame(send)
  }

  const onPointerUp = () => {
    const d = drag.current
    if (d?.frame) cancelAnimationFrame(d.frame)
    send()
    drag.current = null
    setDragValue(null)
  }

  return (
    <div
      role="slider"
      aria-label={def.label}
      aria-valuemin={0}
      aria-valuemax={1}
      aria-valuenow={current}
      tabIndex={0}
      className={`relative flex min-h-28 cursor-ns-resize touch-none flex-col justify-between overflow-hidden rounded bg-panel-2 p-2 select-none ${
        notApplied ? 'outline-2 outline-offset-[-2px] outline-white/60 outline-dashed' : ''
      } ${className ?? 'h-44'}`}
      onPointerDown={onPointerDown}
      onPointerMove={onPointerMove}
      onPointerUp={onPointerUp}
      onPointerCancel={onPointerUp}
      onDoubleClick={() => setMacro(def.name, def.default)}
      onKeyDown={(e) => {
        const step = e.shiftKey ? 0.01 : 1 / 32
        if (e.key === 'ArrowUp') setMacro(def.name, Math.min(1, value + step))
        if (e.key === 'ArrowDown') setMacro(def.name, Math.max(0, value - step))
      }}
      title={`Drag up/down · Shift = fine · double-click = reset${def.deferred ? ' · applied on release' : ''}`}
    >
      {/* fill below the value: the selected colour for colour faders, the accent colour otherwise */}
      <div
        className="pointer-events-none absolute inset-x-0 bottom-0"
        style={{ height: `${current * 100}%`, background: fillColor, opacity: dragValue !== null ? 0.55 : 0.4 }}
      />
      {colorTrack && (
        // the full colour range as a narrow strip on the left edge
        <div className="pointer-events-none absolute inset-y-0 left-0 w-[10%] opacity-80" style={{ background: colorTrack.gradient }} />
      )}
      {/* subtle centre mark */}
      <div className="pointer-events-none absolute inset-x-2 top-1/2 h-px bg-white/15" />
      <div
        className="pointer-events-none absolute inset-x-0"
        style={{
          height: colorTrack ? 4 : 2,
          bottom: `calc(${current * 100}% - ${colorTrack ? 2 : 1}px)`,
          background: fillColor,
          boxShadow: colorTrack ? '0 0 0 1px rgba(0,0,0,0.6)' : undefined,
        }}
      />
      <div className="relative h-8 text-center text-xs leading-tight text-neutral-200 [text-shadow:0_1px_2px_rgba(0,0,0,0.8)]">
        {def.label}
      </div>
      <div className="relative flex items-center justify-center gap-1.5 font-mono text-xs text-neutral-200 [text-shadow:0_1px_2px_rgba(0,0,0,0.8)]">
        {colorTrack && <span className="size-3 rounded-sm ring-1 ring-black/60" style={{ background: fillColor }} />}
        {valueInRange(def, current).toFixed(2)}
      </div>
    </div>
  )
}
