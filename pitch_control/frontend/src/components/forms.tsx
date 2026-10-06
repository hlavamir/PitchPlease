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

export function Row({ label, children, hint }: { label: string; children: ReactNode; hint?: string }) {
  return (
    <label className="grid grid-cols-[8.5rem_minmax(0,1fr)] items-center gap-2 py-0.5 text-[13px]">
      <span className="lbl truncate text-[11px] text-dim" title={hint ?? label}>
        {label}
      </span>
      {/* inputs shrink instead of overflowing into the next column */}
      <span className="flex min-w-0 items-center gap-2 [&>*]:min-w-0 [&>select]:max-w-full">{children}</span>
    </label>
  )
}

/** Parse what a person types: "0.5", ".5", "-.5", "0,5" (comma as decimal separator). */
export function parseNumber(text: string): number | null {
  const t = text.trim().replace(',', '.')
  if (t === '' || t === '-' || t === '.' || t === '-.') return null
  const v = Number(t.startsWith('.') ? `0${t}` : t.startsWith('-.') ? `-0${t.slice(1)}` : t)
  return Number.isFinite(v) ? v : null
}

/**
 * Number field that keeps exactly what you type and only applies the value on Enter or when
 * the field loses focus. Invalid input (or Escape) reverts to the current value.
 */
export function NumberInput({
  value,
  onChange,
  min,
  max,
  className = 'w-24 shrink',
  placeholder,
}: {
  value: number | null | undefined
  onChange: (v: number) => void
  step?: number
  min?: number
  max?: number
  className?: string
  placeholder?: string
}) {
  const shown = value == null ? '' : String(value)
  const [text, setText] = useState(shown)
  const [editing, setEditing] = useState(false)

  useEffect(() => {
    if (!editing) setText(shown)
  }, [shown, editing])

  const cancelled = useRef(false)

  const commit = () => {
    setEditing(false)
    if (cancelled.current) {
      cancelled.current = false
      setText(shown)
      return
    }
    const v = parseNumber(text)
    if (v === null) {
      setText(shown)
      return
    }
    let clamped = v
    if (min !== undefined) clamped = Math.max(min, clamped)
    if (max !== undefined) clamped = Math.min(max, clamped)
    setText(String(clamped))
    if (clamped !== value) onChange(clamped)
  }

  return (
    <input
      type="text"
      inputMode="decimal"
      className={`${className} font-mono`}
      value={text}
      placeholder={placeholder}
      onFocus={() => setEditing(true)}
      onChange={(e) => {
        setEditing(true)
        setText(e.target.value)
      }}
      onBlur={commit}
      onKeyDown={(e) => {
        if (e.key === 'Enter') {
          ;(e.target as HTMLInputElement).blur() // blur commits
        } else if (e.key === 'Escape') {
          cancelled.current = true
          ;(e.target as HTMLInputElement).blur()
        }
      }}
    />
  )
}

export function Toggle({ checked, onChange, label }: { checked: boolean; onChange: (v: boolean) => void; label?: string }) {
  return (
    <span className="inline-flex items-center gap-2">
      <input type="checkbox" checked={checked} onChange={(e) => onChange(e.target.checked)} className="size-4" />
      {label && <span className="lbl text-[11px]">{label}</span>}
    </span>
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
