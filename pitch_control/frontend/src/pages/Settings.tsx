import { useEffect, useRef, useState, type PointerEvent } from 'react'
import { api, type Settings as SettingsData } from '../api'
import { Button, Section } from '../components/forms'
import { DESIGN_SIZE, INKS, clampScale, fitScale, type InkName, type UiSettings } from '../theme'
import { useGridNav, type NavItem } from '../useGridNav'

const INK_NAMES: [InkName, string][] = [
  ['grey', 'Grey'],
  ['amber', 'Amber'],
  ['phosphor', 'Phosphor'],
]

const KEYMAP: [string, string][] = [
  ['W  S', 'Move the selection up / down a row'],
  ['A  D', 'Move the selection left / right'],
  ['↑  ↓', 'Change the selected value'],
  ['SHIFT', 'Fine steps while changing a value'],
  ['⏎', 'Press the selected button · load the selected scene'],
  ['SHIFT ⏎', 'Save the selected scene'],
  ['ESC', 'Cancel a pending hue / saturation change'],
  ['1 – 8', 'Switch page'],
  ['F', 'Full screen on / off (desktop app)'],
]

/** Horizontal segmented slider: click or drag anywhere, ←/→ style keyboard handled by the page grid. */
function HSlider({ value, min, max, onChange, selected, onSelect }: { value: number; min: number; max: number; onChange: (v: number) => void; selected: boolean; onSelect: () => void }) {
  const ref = useRef<HTMLDivElement>(null)
  const t = (value - min) / (max - min)
  const set = (e: PointerEvent<HTMLDivElement>) => {
    const r = ref.current!.getBoundingClientRect()
    onChange(min + Math.min(1, Math.max(0, (e.clientX - r.left) / r.width)) * (max - min))
  }
  const cells = 24
  const level = t * cells
  return (
    <div
      ref={ref}
      className={`flex h-[22px] cursor-ew-resize touch-none ${selected ? 'glow-sel' : ''}`}
      onPointerDown={(e) => {
        onSelect()
        e.currentTarget.setPointerCapture(e.pointerId)
        set(e)
      }}
      onPointerMove={(e) => e.buttons && set(e)}
    >
      {Array.from({ length: cells }, (_, i) => {
        const fill = Math.max(0, Math.min(1, level - i))
        const top = i === Math.ceil(level) - 1
        return (
          <div
            key={i}
            className="relative flex-1"
            style={{
              background: `rgb(var(--ink-rgb) / ${(0.06 + 0.94 * fill).toFixed(3)})`,
              boxShadow:
                'inset -1px 0 0 rgba(15,16,17,.6)' + (top && fill > 0.5 ? ', 0 0 calc(10px * var(--glow)) rgb(var(--ink-rgb) / calc(0.4 * var(--glow)))' : ''),
              zIndex: top ? 1 : undefined,
            }}
          />
        )
      })}
    </div>
  )
}

/**
 * Settings: appearance (ink colour, glow, brightness, key hints) and the keyboard reference.
 * Changes apply immediately and are saved to settings.json, so they are restored next session.
 */
export function Settings({ ui, onChange, desktop }: { ui: UiSettings; onChange: (ui: UiSettings) => void; desktop?: boolean }) {
  const saveTimer = useRef<number | undefined>(undefined)

  const change = (patch: Partial<UiSettings>) => {
    const next = { ...ui, ...patch }
    onChange(next)
    window.clearTimeout(saveTimer.current)
    saveTimer.current = window.setTimeout(async () => {
      const current = await api.get<SettingsData>('/api/settings')
      await api.put('/api/settings', { ...current, ui: next })
    }, 300)
  }
  useEffect(() => () => window.clearTimeout(saveTimer.current), [])

  const pct = (v: number) => `${Math.round(v * 100)}%`

  // window size in real px (not affected by the UI scale), for "Fit window"
  const [win, setWin] = useState({ width: window.innerWidth, height: window.innerHeight })
  useEffect(() => {
    const onResize = () => setWin({ width: window.innerWidth, height: window.innerHeight })
    window.addEventListener('resize', onResize)
    return () => window.removeEventListener('resize', onResize)
  }, [])
  const clamp = (v: number, lo: number, hi: number) => Math.min(hi, Math.max(lo, v))
  const inkItems: NavItem[] = INK_NAMES.map(([name, label]) => ({ id: `ink-${name}`, label: `Ink ${label}`, value: ui.ink === name ? 'ON' : '', press: (down) => down && change({ ink: name }) }))
  const glowItem: NavItem = { id: 'glow', label: 'Glow', value: pct(ui.glow), adjust: (d, fine) => change({ glow: clamp(ui.glow + d * (fine ? 0.01 : 0.05), 0, 1) }) }
  const brightItem: NavItem = {
    id: 'brightness',
    label: 'UI brightness',
    value: pct(ui.brightness),
    adjust: (d, fine) => change({ brightness: clamp(ui.brightness + d * (fine ? 0.01 : 0.05), 0.4, 1) }),
  }
  const setScale = (s: number) => change({ scale: clampScale(s) })
  const scaleItem: NavItem = { id: 'scale', label: 'UI scale', value: pct(ui.scale), adjust: (d, fine) => setScale(ui.scale + d * (fine ? 0.01 : 0.05)) }
  const hintsItem: NavItem = { id: 'hints', label: 'Key hints', value: ui.key_hints ? 'ON' : 'OFF', press: (down) => down && change({ key_hints: !ui.key_hints }) }
  const { selectedId, select } = useGridNav('Settings', [inkItems, [glowItem], [brightItem], [scaleItem], [hintsItem]])

  return (
    <div className="grid gap-1.5 wide:grid-cols-2">
      <Section index="01" title="Appearance" right="saved · restored next session" bodyClassName="p-3.5 gap-[18px]">
        <div className="flex flex-col gap-2">
          <span className="lbl text-[11px] text-dim">Ink colour</span>
          <div className="grid grid-cols-3 gap-px border border-edge bg-edge">
            {INK_NAMES.map(([name, label]) => {
              const on = ui.ink === name
              return (
                <button
                  key={name}
                  onClick={() => {
                    select(`ink-${name}`)
                    change({ ink: name })
                  }}
                  className={`flex h-[92px] flex-col justify-between bg-panel p-3 text-left ${on ? 'glow-sel' : 'glow-hover'} ${selectedId === `ink-${name}` && !on ? 'outline outline-1 outline-offset-[-1px] outline-dim' : ''}`}
                  style={{ color: on ? INKS[name] : '#8a8c87' }}
                >
                  <span className="flex items-center justify-between">
                    <span className="lbl text-[12px]">{label}</span>
                    <span className="font-mono text-[11px] opacity-70">{INKS[name]}</span>
                  </span>
                  <span className="flex items-baseline gap-2.5" style={{ color: INKS[name] }}>
                    <span className="font-mono text-[26px]" style={{ textShadow: `0 0 8px ${INKS[name]}88` }}>
                      0.56
                    </span>
                    <span className="lbl text-[11px]">Strobo</span>
                  </span>
                </button>
              )
            })}
          </div>
        </div>

        {[
          { item: glowItem, value: ui.glow, min: 0, max: 1, note: 'Bloom under selected and active elements', key: 'glow' as const },
          { item: brightItem, value: ui.brightness, min: 0.4, max: 1, note: 'Dims the ink — less light on the DJ at the booth (40–100 %)', key: 'brightness' as const },
        ].map(({ item, value, min, max, note, key }) => (
          <div key={item.id} className="flex flex-col gap-2">
            <div className="flex items-baseline justify-between">
              <span className={`lbl text-[12px] ${selectedId === item.id ? 'bg-ink px-1.5 text-ground' : ''}`}>{item.label}</span>
              <span className="text-glow font-mono text-[16px]">{pct(value)}</span>
            </div>
            <HSlider value={value} min={min} max={max} onChange={(v) => change({ [key]: v })} selected={selectedId === item.id} onSelect={() => select(item.id)} />
            <span className="lbl text-[10px] text-dim">{note}</span>
          </div>
        ))}

        <div className="flex flex-col gap-2">
          <div className="flex items-baseline justify-between">
            <span className={`lbl text-[12px] ${selectedId === 'scale' ? 'bg-ink px-1.5 text-ground' : ''}`}>UI scale</span>
            <span className="text-glow font-mono text-[16px]">{pct(ui.scale)}</span>
          </div>
          <div className="flex gap-1.5" onClick={() => select('scale')}>
            <Button onClick={() => setScale(ui.scale - 0.05)} disabled={ui.scale <= 0.6}>
              −
            </Button>
            <Button onClick={() => setScale(ui.scale + 0.05)} disabled={ui.scale >= 1.5}>
              +
            </Button>
            <Button onClick={() => setScale(fitScale())}>Fit window</Button>
            <Button onClick={() => setScale(1)} disabled={ui.scale === 1}>
              100 %
            </Button>
          </div>
          <span className="lbl text-[10px] text-dim">
            Window {win.width} × {win.height} px · the layout is made for {DESIGN_SIZE.width} × {DESIGN_SIZE.height} at 100 % · fits at{' '}
            {pct(fitScale())} · 60–150 %
          </span>
        </div>

        <div className="flex items-center justify-between border-t border-seam pt-3.5">
          <span className="flex flex-col gap-1">
            <span className="lbl text-[12px]">Key hints</span>
            <span className="lbl text-[10px] text-dim">Show the keyboard legend at the bottom</span>
          </span>
          <button
            onClick={() => {
              select('hints')
              change({ key_hints: !ui.key_hints })
            }}
            className={`lbl h-[34px] px-4 text-[12px] ${ui.key_hints ? 'glow-on bg-ink text-ground' : 'glow-hover border border-edge'} ${selectedId === 'hints' ? 'glow-sel' : ''}`}
          >
            {ui.key_hints ? 'On' : 'Off'}
          </button>
        </div>
      </Section>

      <div className="flex min-w-0 flex-col gap-1.5">
      <Section index="02" title="Keyboard" right="no mouse needed" bodyClassName="px-3.5 pb-3.5 pt-1.5">
        {KEYMAP.map(([cap, what]) => (
          <div key={cap} className="flex h-[34px] items-center gap-3.5 border-b border-[#1d1f21]">
            <span className="min-w-16 border border-ink px-1.5 py-0.5 text-center font-mono text-[12px]">{cap}</span>
            <span className="lbl text-[12px]">{what}</span>
          </div>
        ))}
      </Section>
      {desktop && (
        <Section index="03" title="App" right="desktop app">
          <div className="flex gap-1.5">
            <button className="lbl glow-hover h-8 border border-edge px-3 text-[11px]" onClick={() => api.post('/api/open-browser')}>
              Open in browser
            </button>
            <button className="lbl glow-hover h-8 border border-edge px-3 text-[11px]" onClick={() => api.post('/api/open-data-folder')}>
              Open data folder
            </button>
          </div>
          <div className="mt-3 flex items-center justify-between border-t border-seam pt-3">
            <span className="flex flex-col gap-1">
              <span className="lbl text-[12px]">Start in full screen</span>
              <span className="lbl text-[10px] text-dim">F toggles full screen any time · covers the notch strip, hides menu bar and Dock</span>
            </span>
            <button
              onClick={() => change({ start_fullscreen: !ui.start_fullscreen })}
              className={`lbl h-[34px] px-4 text-[12px] ${ui.start_fullscreen ? 'glow-on bg-ink text-ground' : 'glow-hover border border-edge'}`}
            >
              {ui.start_fullscreen ? 'On' : 'Off'}
            </button>
          </div>
          <span className="lbl mt-3 text-[10px] text-dim">The browser view can also be used on a second screen or a phone (start with --host 0.0.0.0)</span>
        </Section>
      )}
      </div>
    </div>
  )
}
