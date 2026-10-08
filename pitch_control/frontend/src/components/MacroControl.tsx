import { useRef, useState, type PointerEvent } from 'react'
import type { MacroDef } from '../api'
import { MACRO_TIPS, macroHint } from '../hints'

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

export function valueInRange(def: MacroDef, control: number): number {
  const steps = def.steps > 1 ? def.steps - 1 : 1
  const q = Math.floor(control * steps + 0.5) / steps
  return def.min + q * (def.max - def.min)
}

/** The value as shown in the UI: scaled, with decimals and unit (hue in degrees, saturation in %). */
export function formatValue(def: MacroDef, control: number): string {
  const v = valueInRange(def, control) * (def.display_scale ?? 1)
  const text = v.toFixed(def.decimals ?? 2)
  const signed = def.unit === '°' && v > 0.5 ? `+${text}` : text
  return `${signed}${def.unit ?? ''}`
}

/** Hue/saturation faders: a stepped colour scale on the left and the resulting colour in the value dot. */
export interface ColorTrack {
  steps: string[] // colour scale, bottom (control 0) → top (control 1), desaturated for the UI
  colorAt: (control: number) => string // the output colour this fader produces at a control value
}

const UI_SAT = 0.6 // the scale is shown half-desaturated; the dot shows the real colour

export function colorTrackFor(name: string, macros: Record<string, number>, defs: Record<string, MacroDef>): ColorTrack | undefined {
  const m = /^(Hue|Saturation) ([AB])$/.exec(name)
  if (!m) return undefined
  const hueDef = defs[`Hue ${m[2]}`]
  const satDef = defs[`Saturation ${m[2]}`]
  if (!hueDef || !satDef) return undefined
  const hue = valueInRange(hueDef, macros[hueDef.name] ?? 0)
  const sat = valueInRange(satDef, macros[satDef.name] ?? 1)
  const isHue = m[1] === 'Hue'
  const steps = Array.from({ length: 12 }, (_, i) => {
    const t = i / 11
    return isHue ? hsvCss(hueDef.min + t * (hueDef.max - hueDef.min), UI_SAT, 0.86) : hsvCss(hue, t * UI_SAT, 0.86)
  })
  return {
    steps,
    colorAt: (control) => (isHue ? hsvCss(valueInRange(hueDef, control), sat, 1) : hsvCss(hue, valueInRange(satDef, control), 1)),
  }
}

interface Props {
  def: MacroDef
  value: number // shown value (a pending target, if any)
  applied?: number // value the engine is using now (differs while a hue/saturation change is pending)
  setMacro: (name: string, value: number) => void
  toggleMacro: (name: string) => void
  colorTrack?: ColorTrack
  pending?: boolean
  selected?: boolean
  onSelect?: () => void
  tag?: string // small hint on buttons: TGL, HOLD, A…D
  index?: number // position number shown in the fader head
  className?: string
  disabled?: boolean // fader: greyed out, no input (a dimmer no fixture uses)
  name?: string // fader: editable name (Dimmers); double-click the head to rename, '' = macro name
  onRename?: (name: string) => void
}

// scale next to a fader: a primary line every 25 %, a secondary one halfway between
const TICKS = [0, 12.5, 25, 37.5, 50, 62.5, 75, 87.5, 100]

/** One macro: segmented fader, toggle, momentary button or radio button. */
export function MacroControl(props: Props) {
  const { def, value, setMacro, toggleMacro, selected, onSelect, tag } = props
  if (def.kind === 'fader') return <Fader {...props} />

  const on = value > 0.5
  const cls = `lbl flex h-10 w-full items-center justify-between gap-1.5 px-2.5 text-left text-[11px] select-none transition-colors ${
    on ? `bg-ink text-ground ${def.kind === 'momentary' ? 'glow-held' : 'glow-on'}` : 'glow-hover bg-panel text-ink'
  } ${selected ? 'glow-sel' : ''}`
  const content = (
    <>
      <span className="truncate">{def.label}</span>
      {tag && <span className="font-mono text-[10px] opacity-70">{tag}</span>}
    </>
  )

  if (def.kind === 'momentary') {
    return (
      <button
        className={cls}
        data-hint="hold"
        data-tip={MACRO_TIPS[def.name]}
        onPointerDown={() => {
          onSelect?.()
          setMacro(def.name, 1)
        }}
        onPointerUp={() => setMacro(def.name, 0)}
        onPointerLeave={() => on && setMacro(def.name, 0)}
      >
        {content}
      </button>
    )
  }
  const press = () => {
    onSelect?.()
    if (def.kind === 'radio' || def.kind === 'button') setMacro(def.name, 1)
    else toggleMacro(def.name)
  }
  return (
    <button className={cls} onClick={press} data-hint={macroHint(def)} data-tip={MACRO_TIPS[def.name]}>
      {content}
    </button>
  )
}

const SEGMENTS = 20
const SEAM = 'inset 0 1px 0 rgba(15,16,17,.6)'
const halo = 'calc(10px * var(--glow))'

/** One segment: no gaps, a 1px darker seam; the ink fades in with the fill (0..1). */
function segmentStyle(fill: number, bright: boolean, pending: boolean) {
  if (pending) {
    return { background: 'rgb(var(--ink-rgb) / 0.14)', boxShadow: `${SEAM}, inset 0 0 0 1px rgb(var(--ink-rgb) / 0.7)` }
  }
  const glow = bright && fill > 0.5 ? `, 0 0 ${halo} rgb(var(--ink-rgb) / calc(0.4 * var(--glow)))` : ''
  return {
    background: `rgb(var(--ink-rgb) / ${(0.06 + 0.94 * fill).toFixed(3)})`,
    boxShadow: SEAM + glow,
    zIndex: glow ? 1 : undefined,
    position: 'relative' as const,
    transition: 'background-color 120ms linear',
  }
}

/**
 * Segmented fader; the whole tile is the control: drag up/down anywhere (relative, no jump on
 * click), Shift for fine control, double-click to reset. Deferred macros (hue, saturation) are sent
 * on release; until applied, the segments between the applied value and the target are outlined.
 */
function Fader({ def, value, applied, setMacro, colorTrack, pending, selected, onSelect, index, className, disabled, name, onRename }: Props) {
  const [dragValue, setDragValue] = useState<number | null>(null)
  const [draft, setDraft] = useState<string | null>(null) // the name being edited
  const draftDone = useRef(false)
  const headRef = useRef<HTMLDivElement>(null)
  const drag = useRef<{
    startY: number
    startValue: number
    last: number
    height: number
    fine: boolean
    pending: number | null
    frame: number
  } | null>(null)
  const current = dragValue ?? value
  const engineValue = applied ?? value
  const notApplied = Boolean(pending) || (def.deferred && dragValue !== null && Math.abs(dragValue - engineValue) > 1e-6)

  const send = () => {
    const d = drag.current
    if (!d) return
    d.frame = 0
    if (d.pending !== null) setMacro(def.name, d.pending)
    d.pending = null
  }

  const onPointerDown = (e: PointerEvent<HTMLDivElement>) => {
    if (e.button !== 0 || disabled) return
    // a renamable name only selects: a drag would capture the pointer and turn the
    // double-click into a value reset
    if (onRename && headRef.current?.contains(e.target as Node)) {
      onSelect?.()
      return
    }
    onSelect?.()
    e.currentTarget.setPointerCapture(e.pointerId)
    const rect = e.currentTarget.getBoundingClientRect()
    drag.current = { startY: e.clientY, startValue: value, last: value, height: Math.max(rect.height - 70, 40), fine: e.shiftKey, pending: null, frame: 0 }
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
    const next = Math.min(1, Math.max(0, d.startValue + ((d.startY - e.clientY) / d.height) * (d.fine ? 0.1 : 1)))
    d.last = next
    setDragValue(next)
    d.pending = next
    // deferred macros wait for the release; others go out at most once per animation frame
    if (!def.deferred && !d.frame) d.frame = requestAnimationFrame(send)
  }

  const onPointerUp = () => {
    const d = drag.current
    if (d?.frame) cancelAnimationFrame(d.frame)
    send()
    drag.current = null
    setDragValue(null)
  }

  const level = current * SEGMENTS
  const top = Math.ceil(level) - 1
  const appliedLevel = engineValue * SEGMENTS
  // while a change is pending, the segments between the applied value and the target are outlined
  const lo = Math.floor(Math.min(level, appliedLevel))
  const hi = Math.ceil(Math.max(level, appliedLevel))
  const segments = Array.from({ length: SEGMENTS }, (_, s) => {
    const fill = Math.max(0, Math.min(1, level - s))
    return segmentStyle(fill, s === top || Boolean(selected), notApplied && s >= lo && s < hi)
  })

  const finishRename = (commit: boolean) => {
    if (draftDone.current || draft === null) return
    draftDone.current = true
    if (commit && draft.trim() !== (name ?? '')) onRename?.(draft.trim())
    setDraft(null)
  }

  return (
    <div
      role="slider"
      aria-label={def.label}
      aria-valuemin={0}
      aria-valuemax={1}
      aria-valuenow={current}
      aria-disabled={disabled || undefined}
      className={`relative flex min-h-28 touch-none flex-col bg-panel select-none ${disabled ? '' : 'cursor-ns-resize'} ${selected && !disabled ? 'glow-sel' : ''} ${
        notApplied ? 'outline outline-1 outline-offset-[-4px] outline-dashed outline-ink' : ''
      } ${className ?? 'h-44'}`}
      onPointerDown={onPointerDown}
      onPointerMove={onPointerMove}
      onPointerUp={onPointerUp}
      onPointerCancel={onPointerUp}
      onDoubleClick={() => !disabled && setMacro(def.name, def.default)}
      data-hint={disabled ? 'dimmer-off' : macroHint(def)}
      data-tip={
        disabled
          ? 'No fixture uses this dimmer, so it is disabled and ignores MIDI'
          : (MACRO_TIPS[def.name] ?? (def.page === 'dimmers' ? 'Brightness of the fixtures that follow this dimmer (Rig → Dimmer)' : undefined))
      }
    >
      <div
        ref={headRef}
        className={`lbl flex h-[30px] flex-none items-center gap-2 overflow-hidden px-2.5 text-[11px] whitespace-nowrap ${
          selected && !disabled && draft === null ? 'bg-ink text-ground' : 'border-b border-seam'
        } ${onRename ? 'cursor-text' : ''}`}
        onDoubleClick={(e) => {
          if (!onRename) return
          e.stopPropagation() // not the value reset
          draftDone.current = false
          setDraft(name ?? '')
        }}
      >
        {index !== undefined && <span className="font-mono opacity-60">{String(index).padStart(2, '0')}</span>}
        {draft !== null ? (
          <input
            type="text"
            autoFocus
            className="h-[22px] min-w-0 flex-1 px-1 text-[11px] normal-case"
            value={draft}
            placeholder={def.name}
            onFocus={(e) => e.currentTarget.select()}
            onChange={(e) => setDraft(e.target.value)}
            onPointerDown={(e) => e.stopPropagation()} // no fader drag from the field
            onDoubleClick={(e) => e.stopPropagation()}
            onKeyDown={(e) => {
              if (e.key === 'Enter') finishRename(true)
              else if (e.key === 'Escape') finishRename(false)
            }}
            onBlur={() => finishRename(true)}
          />
        ) : (
          <span className={`truncate ${disabled ? 'text-dim' : ''}`}>{def.label}</span>
        )}
      </div>
      <div className="flex min-h-0 flex-1 gap-1.5 py-2 pr-2.5 pl-2">
        {colorTrack ? (
          <div className="flex w-[5px] flex-none flex-col-reverse">
            {colorTrack.steps.map((c, i) => (
              <div key={i} className="flex-1" style={{ background: c, boxShadow: 'inset 0 1px 0 rgba(15,16,17,.35)' }} />
            ))}
          </div>
        ) : (
          <div className="relative w-2.5 flex-none">
            {TICKS.map((p) => (
              <div
                key={p}
                className={`absolute right-0 h-px ${p % 25 === 0 ? 'w-2.5' : 'w-1.5'}`}
                // 0 % on the bottom edge, 100 % on the top edge of the segment column
                style={{ bottom: `calc(${p}% - ${p / 100}px)`, background: `rgb(var(--ink-rgb) / ${p % 25 === 0 ? (disabled ? 0.25 : 0.75) : 0.3})` }}
              />
            ))}
          </div>
        )}
        <div className={`flex flex-1 flex-col-reverse ${disabled ? 'hatch opacity-60' : ''}`}>
          {!disabled && segments.map((st, i) => <div key={i} className="flex-1" style={st} />)}
        </div>
      </div>
      <div className="flex h-[26px] flex-none items-center justify-between border-t border-seam px-2.5">
        {colorTrack ? (
          <span className="size-3" style={{ background: colorTrack.colorAt(current), boxShadow: `0 0 0 1px #0f1011, 0 0 8px ${colorTrack.colorAt(current)}` }} />
        ) : (
          <span />
        )}
        {disabled ? (
          <span className="lbl text-[10px] text-dim">no fixtures</span>
        ) : (
          <span className="text-glow font-mono text-[16px]">{formatValue(def, current)}</span>
        )}
      </div>
    </div>
  )
}
