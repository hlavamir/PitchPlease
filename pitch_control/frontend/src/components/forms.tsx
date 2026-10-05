import { useCallback, useEffect, useRef, useState, type ReactNode } from 'react'
import { api, type Settings } from '../api'

export function Section({ title, children, right }: { title: string; children: ReactNode; right?: ReactNode }) {
  return (
    <section className="@container min-w-0 rounded-lg border border-edge bg-panel p-3">
      <div className="mb-2 flex items-center justify-between gap-2">
        <h2 className="text-sm font-semibold tracking-wide text-neutral-300 uppercase">{title}</h2>
        {right}
      </div>
      {children}
    </section>
  )
}

export function Row({ label, children, hint }: { label: string; children: ReactNode; hint?: string }) {
  return (
    <label className="grid grid-cols-[8.5rem_minmax(0,1fr)] items-center gap-2 py-0.5 text-sm">
      <span className="truncate text-neutral-400" title={hint ?? label}>
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
      <input type="checkbox" checked={checked} onChange={(e) => onChange(e.target.checked)} className="size-4 accent-amber-500" />
      {label && <span>{label}</span>}
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
      className={`rounded px-3 py-1.5 text-sm font-medium disabled:opacity-40 ${
        primary ? 'bg-accent text-neutral-900 hover:brightness-110' : 'bg-panel-2 text-neutral-200 hover:bg-edge'
      }`}
    >
      {children}
    </button>
  )
}

export function StatusDot({ ok, label, error }: { ok: boolean | null | undefined; label: string; error?: string | null }) {
  const color = ok ? 'bg-emerald-500' : ok === false ? 'bg-red-500' : 'bg-neutral-600'
  return (
    <span className="inline-flex items-center gap-1.5 text-xs text-neutral-400" title={error ?? undefined}>
      <span className={`size-2 rounded-full ${color}`} />
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
      {message && <span className="text-xs text-neutral-400">{message}</span>}
      <Button onClick={reload} disabled={!dirty}>
        Revert
      </Button>
      <Button onClick={save} primary disabled={!dirty}>
        Save
      </Button>
    </div>
  )
}
