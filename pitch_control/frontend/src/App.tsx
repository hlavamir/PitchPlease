import { useCallback, useEffect, useRef, useState } from 'react'
import { api, type MacroDef, type Settings as SettingsData } from './api'
import { StatusDot } from './components/forms'
import { HINT_KEYS, MOD, hintAt, type HintKind } from './hints'
import { Dimmers } from './pages/Dimmers'
import { Fixtures } from './pages/Fixtures'
import { Fog } from './pages/Fog'
import { General } from './pages/General'
import { Inputs } from './pages/Inputs'
import { Output } from './pages/Output'
import { Rig } from './pages/Rig'
import { ControlDesk } from './pages/ControlDesk'
import { Settings } from './pages/Settings'
import { DEFAULT_UI, applyScale, applyTheme, clampScale, type UiSettings } from './theme'
import { useEngine } from './useEngine'
import { SelectionContext, isTyping, type FooterSelection } from './useGridNav'

const PAGES = ['General', 'Dimmers', 'Fixtures', 'Rig', 'Inputs', 'Outputs', 'Fog', 'Settings', 'Control Desk'] as const
type Page = (typeof PAGES)[number]

function initialPage(): Page {
  let hash = decodeURIComponent(location.hash.slice(1))
  if (hash === 'Output') hash = 'Outputs' // old bookmark
  return (PAGES as readonly string[]).includes(hash) ? (hash as Page) : 'General'
}

const KEYS: [string, string][] = [
  ['W S', 'row'],
  ['A D', 'column'],
  ['↑ ↓', 'value'],
  ['SHIFT', 'fine'],
  ['⏎', 'press'],
  ['ESC', 'cancel'],
  ['1–9', 'page'],
  ['F', 'full screen'],
  [`${MOD} + −`, 'UI scale'],
]

/** The 3×3 pixel mark next to the wordmark. */
function Glyph() {
  return (
    <span className="grid grid-cols-3 gap-px">
      {[1, 0, 1, 0, 1, 0, 1, 0, 1].map((on, i) => (
        <span key={i} className={`size-1 ${on ? 'bg-ink' : ''}`} />
      ))}
    </span>
  )
}

export default function App() {
  const engine = useEngine()
  const [page, setPage] = useState<Page>(initialPage)
  const [defs, setDefs] = useState<Record<string, MacroDef>>({})
  const [desktop, setDesktop] = useState(false)
  const [version, setVersion] = useState('')
  const [fullscreen, setFullscreen] = useState<{ supported: boolean; on: boolean }>({ supported: false, on: false })
  const [ui, setUi] = useState<UiSettings>(DEFAULT_UI)
  const [footer, setFooter] = useState<FooterSelection | null>(null)
  // footer context: the control under the mouse, or the keyboard selection, whichever was used last
  const [hover, setHover] = useState<{ kind: HintKind; tip?: string } | null>(null)
  const [inputMode, setInputMode] = useState<'mouse' | 'keys'>('mouse')
  const uiRef = useRef(ui)
  uiRef.current = ui

  useEffect(() => {
    api.get<MacroDef[]>('/api/macros/defs').then((list) => setDefs(Object.fromEntries(list.map((d) => [d.name, d]))))
    api
      .get<{ desktop: boolean; fullscreen_supported: boolean; fullscreen: boolean; version: string }>('/api/app-info')
      .then((info) => {
        setDesktop(info.desktop)
        setVersion(info.version)
        setFullscreen({ supported: info.fullscreen_supported, on: info.fullscreen })
      })
      .catch(() => undefined)
    api.get<SettingsData>('/api/settings').then((s) => s.ui && setUi({ ...DEFAULT_UI, ...s.ui }))
    const onHash = () => setPage(initialPage())
    window.addEventListener('hashchange', onHash)
    return () => window.removeEventListener('hashchange', onHash)
  }, [])

  useEffect(() => applyTheme(ui), [ui])
  useEffect(() => {
    applyScale(ui.scale)
    const onResize = () => applyScale(ui.scale) // the column layouts depend on the scaled width
    window.addEventListener('resize', onResize)
    return () => window.removeEventListener('resize', onResize)
  }, [ui.scale])

  const go = useCallback((p: Page) => {
    setPage(p)
    history.replaceState(null, '', `#${p}`)
  }, [])

  const toggleFullscreen = useCallback(async () => {
    const res = await api.post<{ fullscreen: boolean }>('/api/fullscreen').catch(() => null)
    if (res) setFullscreen((f) => ({ ...f, on: res.fullscreen }))
  }, [])

  // ⌘ (macOS) / Ctrl (Windows) with + or = (same key without Shift), − and 0: UI scale, like a
  // browser's zoom; saved like the Settings slider. Works while typing too (it needs the modifier).
  const saveTimer = useRef<number | undefined>(undefined)
  useEffect(() => {
    const mac = navigator.userAgent.includes('Mac')
    const onKey = (e: KeyboardEvent) => {
      if (!(mac ? e.metaKey : e.ctrlKey) || e.altKey) return
      let scale: number
      const cur = uiRef.current.scale
      if (e.key === '+' || e.key === '=' || e.code === 'NumpadAdd') scale = Math.round(cur * 20 + 1) / 20
      else if (e.key === '-' || e.key === '_' || e.code === 'NumpadSubtract') scale = Math.round(cur * 20 - 1) / 20
      else if (e.key === '0' || e.code === 'Numpad0') scale = 1
      else return
      e.preventDefault()
      const next = { ...uiRef.current, scale: clampScale(scale) }
      setUi(next)
      window.clearTimeout(saveTimer.current)
      saveTimer.current = window.setTimeout(async () => {
        const current = await api.get<SettingsData>('/api/settings')
        await api.put('/api/settings', { ...current, ui: next })
      }, 400)
    }
    window.addEventListener('keydown', onKey)
    return () => window.removeEventListener('keydown', onKey)
  }, [])

  // footer: follow the mouse until the navigation keys are used, then the keyboard selection
  useEffect(() => {
    const onOver = (e: PointerEvent) => setHover(hintAt(e.target))
    const onMove = () => setInputMode('mouse')
    const onLeave = () => setHover(null)
    const onKey = (e: KeyboardEvent) => {
      if (isTyping(e) || e.metaKey || e.ctrlKey || e.altKey) return
      if (['w', 'a', 's', 'd', 'q', 'e'].includes(e.key.toLowerCase()) || ['ArrowUp', 'ArrowDown', 'Enter', 'Escape'].includes(e.key)) setInputMode('keys')
    }
    document.addEventListener('pointerover', onOver)
    document.addEventListener('pointermove', onMove)
    document.documentElement.addEventListener('pointerleave', onLeave)
    window.addEventListener('keydown', onKey)
    return () => {
      document.removeEventListener('pointerover', onOver)
      document.removeEventListener('pointermove', onMove)
      document.documentElement.removeEventListener('pointerleave', onLeave)
      window.removeEventListener('keydown', onKey)
    }
  }, [])

  // 1–9 switch pages, F full screen (not while typing in a field)
  useEffect(() => {
    const onKey = (e: KeyboardEvent) => {
      if (isTyping(e) || e.metaKey || e.ctrlKey || e.altKey) return
      const n = Number(e.key)
      if (Number.isInteger(n) && n >= 1 && n <= PAGES.length) {
        e.preventDefault()
        go(PAGES[n - 1])
      }
      if (e.key.toLowerCase() === 'f' && fullscreen.supported) {
        e.preventDefault()
        toggleFullscreen()
      }
    }
    window.addEventListener('keydown', onKey)
    return () => window.removeEventListener('keydown', onKey)
  }, [go, fullscreen.supported, toggleFullscreen])

  // The MIDI controller drives the faders of the active control page (General or Dimmers), like the
  // vvvv tabs: opening one of those pages selects it on the controller ...
  const { connected, setMacro } = engine
  useEffect(() => {
    if (connected && (page === 'General' || page === 'Dimmers')) setMacro(`Page ${page}`, 1)
  }, [page, connected, setMacro])

  // ... and turning the controller's page knob switches the UI between them.
  const enginePage = engine.state ? ((engine.state.macros['Page Dimmers'] ?? 0) > 0.5 ? 'Dimmers' : 'General') : null
  const lastEnginePage = useRef<string | null>(null)
  useEffect(() => {
    const last = lastEnginePage.current
    lastEnginePage.current = enginePage
    if (enginePage && last && enginePage !== last && (page === 'General' || page === 'Dimmers') && enginePage !== page) {
      go(enginePage)
    }
  }, [enginePage, page, go])

  const s = engine.state
  const out = s?.io.outputs
  // footer keys: for the hovered / keyboard-selected control, or the general ones
  const context = inputMode === 'keys' ? (footer?.hint ? { kind: footer.hint, tip: footer.tip } : null) : hover
  const footerKeys = context
    ? HINT_KEYS[context.kind]
    : [...KEYS.filter(([cap]) => cap !== 'F' || fullscreen.supported), ...(page === 'Control Desk' ? ([['Q E', 'subpage']] as [string, string][]) : [])]
  const overrideCount = Object.values(s?.overrides ?? {}).reduce((n, chans) => n + Object.keys(chans).length, 0)
  // In full screen on a MacBook the camera notch covers the top 32 pt; below 100 % UI scale the top
  // row grows so that it still measures 38 pt on screen.
  const topRow = fullscreen.on && navigator.userAgent.includes('Mac') ? Math.max(38, Math.ceil(38 / clampScale(ui.scale))) : 38
  return (
    <SelectionContext.Provider value={setFooter}>
      <div className="flex h-full flex-col">
        {/* Two rows: the top one keeps its middle free, so in full screen on a MacBook the camera notch
            (32 px) sits in empty space between the logo and the indicators. */}
        {/* same 6 px side margin as the page content; the top row is 38 px (notch 32 px + 6) so
            the line below it clears the camera island */}
        <header className="flex-none px-1.5">
          <div className="flex items-center justify-between border-b border-edge" style={{ height: topRow }}>
            <div className="flex flex-none items-center gap-2.5 px-2.5">
              <Glyph />
              <h1 className="lbl text-glow text-[15px] font-semibold tracking-[0.14em]">PitchControl!</h1>
            </div>
            <div className="flex flex-none items-center gap-4 px-2.5 whitespace-nowrap">
              {/* fixed width: a changing FPS value never shifts the indicators */}
              <span className={`inline-block w-[7.5rem] text-right font-mono text-[13px] tabular-nums ${engine.connected ? 'text-ink' : 'text-dim'}`}>
                {engine.connected ? `${(s?.fps ?? 0).toFixed(1).padStart(4, '\u2007')} FPS` : 'ENGINE OFFLINE'}
              </span>
              {overrideCount > 0 && (
                // manual DMX overrides are saved across restarts: never let them go unnoticed
                <button onClick={() => go('Control Desk')} className="lbl glow-on bg-ink px-2 text-[11px] leading-[18px] text-ground" title="Manual DMX overrides active (Control Desk)">
                  {overrideCount} override{overrideCount === 1 ? '' : 's'}
                </button>
              )}
              <StatusDot ok={s?.io.audio ? s.io.audio.running : null} label="audio" error={s?.io.audio?.error} />
              <StatusDot ok={s?.io.midi ? Boolean(s.io.midi.port) : null} label="midi" error={s?.io.midi?.error} />
              {/* one dot per configured USB DMX interface */}
              {out?.enttec?.length ? (
                out.enttec.map((e, i) => (
                  <StatusDot key={i} ok={e ? e.connected : null} label={out.enttec.length > 1 ? `enttec ${i + 1}` : 'enttec'} error={e?.error} />
                ))
              ) : (
                <StatusDot ok={null} label="enttec" />
              )}
              <StatusDot ok={out?.artnet ? out.artnet.connected : null} label="art-net" error={out?.artnet?.error} />
              <StatusDot ok={out?.pitchpls_v2 ? out.pitchpls_v2.connected : null} label="v2" error={out?.pitchpls_v2?.error} />
            </div>
          </div>
          <nav className="flex h-9 items-stretch border-x border-b border-edge">
            {PAGES.map((p, i) => (
              <button
                key={p}
                onClick={() => go(p)}
                data-hint="tab"
                className={`lbl flex flex-none items-center gap-2 border-r border-edge px-4 text-[12px] whitespace-nowrap ${
                  page === p ? 'glow-on bg-ink text-ground' : 'text-ink hover:bg-panel-2'
                }`}
              >
                <span className="font-mono text-[11px] opacity-60">{i + 1}</span>
                {p}
              </button>
            ))}
            {fullscreen.supported && (
              <button onClick={toggleFullscreen} className={`lbl ml-auto flex items-center gap-2 border-l border-edge px-4 text-[12px] ${fullscreen.on ? 'text-ink' : 'text-dim'} hover:bg-panel-2`}>
                <span className="font-mono text-[11px] opacity-60">F</span>
                {fullscreen.on ? 'Exit full screen' : 'Full screen'}
              </button>
            )}
          </nav>
        </header>

        {/* side margins instead of padding: the scrollbar ends 6 px from the window edge, like the header */}
        <main className="page-scroll mx-1.5 min-h-0 flex-1 overflow-auto py-1.5">
          {page === 'General' && <General engine={engine} defs={defs} />}
          {page === 'Dimmers' && <Dimmers engine={engine} defs={defs} />}
          {page === 'Fixtures' && <Fixtures defs={defs} />}
          {page === 'Rig' && <Rig engine={engine} defs={defs} />}
          {page === 'Outputs' && <Output engine={engine} />}
          {page === 'Inputs' && <Inputs engine={engine} />}
          {page === 'Fog' && <Fog engine={engine} />}
          {page === 'Settings' && <Settings ui={ui} onChange={setUi} desktop={desktop} version={version} />}
          {page === 'Control Desk' && <ControlDesk engine={engine} />}
        </main>

        {ui.key_hints && (
          <footer className="mx-1.5 flex h-7 flex-none items-center gap-5 border-t border-edge px-2.5 text-[11px]">
            {footerKeys.map(([cap, what]) => (
              <span key={cap} className="lbl inline-flex flex-none items-center gap-1.5">
                <span className="border border-ink px-1 font-mono text-[11px] leading-[14px]">{cap}</span>
                <span className="text-dim">{what}</span>
              </span>
            ))}
            {context?.tip && <span className="min-w-0 truncate text-[12px] text-dim" title={context.tip}>{context.tip}</span>}
            {footer && (
              <span className="lbl ml-auto flex-none whitespace-nowrap">
                Sel{' '}
                <span className="font-mono text-[13px]">
                  · {footer.label}
                  {footer.value !== undefined && ` ${footer.value}`}
                </span>
              </span>
            )}
          </footer>
        )}
      </div>
    </SelectionContext.Provider>
  )
}
