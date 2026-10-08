import { useCallback, useEffect, useRef, useState, type ReactNode } from 'react'
import { api, type Settings } from '../api'

/**
 * A panel: square, 1px hairline border, a header strip with an optional number ("01 / Macros").
 * ``bodyClassName`` replaces the default padding (e.g. "p-0" for grids drawn with 1px gaps).
 */
export function Section({
  title,
  index,
  children,
  right,
  className = '',
  bodyClassName = 'p-3',
}: {
  title: string
  index?: string
  children: ReactNode
  right?: ReactNode
  className?: string // e.g. "flex-1" to let the panel (and its content) stretch
  bodyClassName?: string
}) {
  return (
    <section className={`@container flex min-w-0 flex-col border border-edge bg-panel ${className}`}>
      <div className="flex h-[26px] flex-none items-center justify-between gap-2 border-b border-edge px-2.5 text-[11px]">
        <h2 className="lbl truncate font-medium">
          {index && <span className="font-mono opacity-55">{index} / </span>}
          {title}
        </h2>
        <div className="lbl flex items-center gap-2 text-dim">{right}</div>
      </div>
      <div className={`flex min-h-0 flex-1 flex-col ${bodyClassName}`}>{children}</div>
    </section>
  )
}

/** One labelled form row. ``plain`` renders a div instead of a <label>, so clicking the label text
 * doesn't activate the first control (override rows, whose first control is the checkbox). */
export function Row({ label, children, hint, plain }: { label: string; children: ReactNode; hint?: string; plain?: boolean }) {
  const Tag = plain ? 'div' : 'label'
  return (
    <Tag className="grid grid-cols-[8.5rem_minmax(0,1fr)] items-center gap-2 py-0.5 text-[13px]">
      <span className="lbl truncate text-[11px] text-dim" title={hint ?? label}>
        {label}
      </span>
      {/* inputs shrink instead of overflowing into the next column */}
      <span className="flex min-w-0 items-center gap-2 [&>*]:min-w-0 [&>select]:max-w-full">{children}</span>
    </Tag>
  )
}

/** Parse what a person types: "0.5", ".5", "-.5", "0,5" (comma as decimal separator). */
export function parseNumber(text: string): number | null {
  const t = text.trim().replace(',', '.')
  if (t === '' || t === '-' || t === '.' || t === '-.') return null
  const v = Number(t.startsWith('.') ? `0${t}` : t.startsWith('-.') ? `-0${t.slice(1)}` : t)
  return Number.isFinite(v) ? v : null
}

/** Float noise off: 0.1 + 0.2 → 0.3. */
const tidy = (v: number) => Number(v.toFixed(6))

/** Vertical right-drag distance (px) for one step. */
const DRAG_PX = 6

/**
 * Number field that keeps exactly what you type and applies it on Enter (the field keeps focus,
 * so you can type the next value right away) or when the field loses focus. Escape reverts.
 *
 * ↑ / ↓ and a vertical right-mouse drag change the value by ``step`` (with Shift: ``fineStep``)
 * and apply each change immediately. Defaults: integers 1 / 1, floats 0.1 / 0.01. Without a value
 * (empty, or "multiple values" in multi-edit) only typing works.
 */
export function NumberInput({
  value,
  onChange,
  min,
  max,
  integer = false,
  step,
  fineStep,
  className = 'w-24 shrink',
  placeholder,
  disabled,
}: {
  value: number | null | undefined
  onChange: (v: number) => void
  min?: number
  max?: number
  integer?: boolean
  step?: number
  fineStep?: number
  className?: string
  placeholder?: string
  disabled?: boolean
}) {
  const coarse = step ?? (integer ? 1 : 0.1)
  const fine = fineStep ?? (integer ? 1 : 0.01)
  const shown = value == null ? '' : String(value)
  const [text, setText] = useState(shown)
  // true while the field holds typed text that is not applied yet
  const [dirty, setDirty] = useState(false)
  const inputRef = useRef<HTMLInputElement>(null)
  const drag = useRef<{ id: number; lastY: number; acc: number; v: number } | null>(null)

  useEffect(() => {
    if (!dirty) setText(shown)
  }, [shown, dirty])

  const limit = (v: number) => {
    let r = integer ? Math.round(v) : tidy(v)
    if (min !== undefined) r = Math.max(min, r)
    if (max !== undefined) r = Math.min(max, r)
    return r
  }

  const apply = (v: number) => {
    setDirty(false)
    setText(String(v))
    if (v !== value) onChange(v)
  }

  /** Apply typed text; invalid text reverts. */
  const commit = () => {
    if (!dirty) return
    const v = parseNumber(text)
    if (v === null) {
      setDirty(false)
      setText(shown)
      return
    }
    apply(limit(v))
  }

  /** One step up (+1) or down (-1); the keys step from the typed text if it is valid. */
  const nudge = (from: number, dir: number, fineMode: boolean) => limit(from + dir * (fineMode ? fine : coarse))

  return (
    <input
      ref={inputRef}
      type="text"
      inputMode="decimal"
      data-hint="number"
      className={`${className} font-mono ${value != null && !disabled ? 'cursor-ns-resize focus:cursor-text' : ''}`}
      value={text}
      placeholder={placeholder}
      disabled={disabled}
      onChange={(e) => {
        setDirty(true)
        setText(e.target.value)
      }}
      onBlur={commit}
      onKeyDown={(e) => {
        if (e.key === 'Enter') {
          e.preventDefault()
          commit()
          e.currentTarget.select() // stays focused: type the next value and Enter again
        } else if (e.key === 'Escape') {
          setDirty(false)
          setText(shown)
          e.currentTarget.blur()
        } else if (e.key === 'ArrowUp' || e.key === 'ArrowDown') {
          e.preventDefault()
          if (value == null) return // nothing to step from (empty, or different values in multi-edit)
          const typed = dirty ? parseNumber(text) : null
          apply(nudge(typed ?? value, e.key === 'ArrowUp' ? 1 : -1, e.shiftKey))
        }
      }}
      onContextMenu={(e) => e.preventDefault()}
      onPointerDown={(e) => {
        if (e.button !== 2 || value == null || disabled) return
        e.preventDefault()
        e.currentTarget.setPointerCapture(e.pointerId)
        drag.current = { id: e.pointerId, lastY: e.clientY, acc: 0, v: value }
        setDirty(false)
      }}
      onPointerMove={(e) => {
        const d = drag.current
        if (!d || d.id !== e.pointerId) return
        d.acc += d.lastY - e.clientY // up = more
        d.lastY = e.clientY
        let v = d.v
        while (Math.abs(d.acc) >= DRAG_PX) {
          const dir = Math.sign(d.acc)
          v = nudge(v, dir, e.shiftKey)
          d.acc -= dir * DRAG_PX
        }
        if (v !== d.v) {
          d.v = v
          apply(v)
        }
      }}
      onPointerUp={(e) => {
        if (drag.current?.id === e.pointerId) drag.current = null
      }}
      onPointerCancel={() => (drag.current = null)}
    />
  )
}

/**
 * On/off switch (the one rounded element of the UI). Off: outlined track, dim knob on the left.
 * On: ink track with glow, dark knob on the right. ``mixed`` (multi-edit with different values)
 * puts the knob in the middle; clicking it switches on. Inside a <label> (e.g. Row) a click on the
 * label text toggles it too.
 */
export function Toggle({
  checked,
  onChange,
  label,
  mixed,
  disabled,
}: {
  checked: boolean
  onChange: (v: boolean) => void
  label?: string
  mixed?: boolean
  disabled?: boolean
}) {
  const on = checked && !mixed
  return (
    <span className="inline-flex items-center gap-2">
      <button
        type="button"
        role="switch"
        data-hint="switch"
        aria-checked={mixed ? 'mixed' : checked}
        aria-label={label}
        disabled={disabled}
        onClick={() => onChange(mixed ? true : !checked)}
        className={`relative h-[18px] w-[34px] flex-none rounded-full border transition-colors focus-visible:outline focus-visible:outline-1 focus-visible:outline-offset-2 focus-visible:outline-ink disabled:opacity-40 ${
          on ? 'glow-on border-ink bg-ink' : 'border-edge bg-panel-2 hover:border-dim'
        }`}
      >
        <span
          className={`absolute top-1/2 size-3 -translate-y-1/2 rounded-full transition-[left] duration-100 ${
            on ? 'left-[18px] bg-ground' : mixed ? 'left-[10px] bg-dim' : 'left-[2px] bg-dim'
          }`}
        />
      </button>
      {label && <span className="lbl text-[11px]">{label}</span>}
    </span>
  )
}

/**
 * Small square checkbox in ink, for marking a value as overridden (Unreal-style override toggle).
 * ``mixed`` (multi-edit) shows a dash; clicking it switches all on.
 */
export function Check({ checked, mixed, onChange, title }: { checked: boolean; mixed?: boolean; onChange: (v: boolean) => void; title?: string }) {
  const on = checked && !mixed
  return (
    <button
      type="button"
      role="checkbox"
      data-hint="override"
      aria-checked={mixed ? 'mixed' : checked}
      title={title}
      onClick={() => onChange(mixed ? true : !checked)}
      className={`inline-flex size-[15px] flex-none items-center justify-center border font-mono text-[11px] leading-none ${
        on ? 'glow-on border-ink bg-ink text-ground' : 'border-edge text-ink hover:border-dim'
      }`}
    >
      {mixed ? '–' : on ? '✓' : ''}
    </button>
  )
}

export function Button({
  children,
  onClick,
  primary,
  disabled,
}: {
  children: ReactNode
  onClick: () => void
  primary?: boolean
  disabled?: boolean
}) {
  return (
    <button
      disabled={disabled}
      onClick={onClick}
      className={`lbl h-8 px-3 text-[11px] font-medium disabled:opacity-35 ${
        primary ? 'glow-on bg-ink text-ground' : 'glow-hover border border-edge bg-panel text-ink'
      }`}
    >
      {children}
    </button>
  )
}

export function StatusDot({ ok, label, error }: { ok: boolean | null | undefined; label: string; error?: string | null }) {
  // filled = OK, hollow = off, crossed = error
  return (
    <span className={`lbl inline-flex flex-none items-center gap-1.5 text-[11px] whitespace-nowrap ${ok ? 'text-ink' : 'text-dim'}`} title={error ?? undefined}>
      <span
        className={`relative inline-block size-[7px] ${ok ? 'dot-on' : 'border border-dim'} ${
          ok === false ? "after:absolute after:inset-[-2px] after:content-['×'] after:text-[9px] after:leading-[9px]" : ''
        }`}
      />
      {label}
    </span>
  )
}

/** Load settings, edit them locally, save them back with one PUT. */
export function useSettings() {
  const [settings, setSettings] = useState<Settings | null>(null)
  const [dirty, setDirty] = useState(false)
  const [message, setMessage] = useState<string | null>(null)

  const reload = useCallback(() => {
    api.get<Settings>('/api/settings').then((s) => {
      setSettings(s)
      setDirty(false)
    })
  }, [])
  useEffect(reload, [reload])

  const update = useCallback((fn: (s: Settings) => void) => {
    setSettings((prev) => {
      if (!prev) return prev
      const next = structuredClone(prev)
      fn(next)
      return next
    })
    setDirty(true)
  }, [])

  const save = useCallback(async () => {
    if (!settings) return
    try {
      await api.put('/api/settings', settings)
      setDirty(false)
      setMessage('Saved')
    } catch (e) {
      setMessage(String(e))
    }
    window.setTimeout(() => setMessage(null), 3000)
  }, [settings])

  return { settings, update, save, dirty, reload, message }
}

export function SaveBar({ dirty, save, reload, message }: { dirty: boolean; save: () => void; reload: () => void; message: string | null }) {
  return (
    <div className="flex items-center gap-3">
      {message && <span className="lbl text-[11px] text-dim">{message}</span>}
      <Button onClick={reload} disabled={!dirty}>
        Revert
      </Button>
      <Button onClick={save} primary disabled={!dirty}>
        Save
      </Button>
    </div>
  )
}
