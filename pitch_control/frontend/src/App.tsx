import { useCallback, useEffect, useRef, useState } from 'react'
import { api, type MacroDef, type Settings as SettingsData } from './api'
import { StatusDot } from './components/forms'
import { Dimmers } from './pages/Dimmers'
import { Fixtures } from './pages/Fixtures'
import { Fog } from './pages/Fog'
import { General } from './pages/General'
import { Inputs } from './pages/Inputs'
import { Output } from './pages/Output'
import { Settings } from './pages/Settings'
import { DEFAULT_UI, applyScale, applyTheme, clampScale, type UiSettings } from './theme'
import { useEngine } from './useEngine'
import { SelectionContext, isTyping, type FooterSelection } from './useGridNav'

const PAGES = ['General', 'Dimmers', 'Fixtures', 'Inputs', 'Outputs', 'Fog', 'Settings'] as const
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
  ['1–7', 'page'],
  ['F', 'full screen'],
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
  const [fullscreen, setFullscreen] = useState<{ supported: boolean; on: boolean }>({ supported: false, on: false })
  const [ui, setUi] = useState<UiSettings>(DEFAULT_UI)
  const [footer, setFooter] = useState<FooterSelection | null>(null)

  useEffect(() => {
    api.get<MacroDef[]>('/api/macros/defs').then((list) => setDefs(Object.fromEntries(list.map((d) => [d.name, d]))))
    api
      .get<{ desktop: boolean; fullscreen_supported: boolean; fullscreen: boolean }>('/api/app-info')
      .then((info) => {
        setDesktop(info.desktop)
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

  // 1–7 switch pages, F full screen (not while typing in a field)
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
              <StatusDot ok={s?.io.audio ? s.io.audio.running : null} label="audio" error={s?.io.audio?.error} />
              <StatusDot ok={s?.io.midi ? Boolean(s.io.midi.port) : null} label="midi" error={s?.io.midi?.error} />
              <StatusDot ok={out?.enttec ? out.enttec.connected : null} label="enttec" error={out?.enttec?.error} />
              <StatusDot ok={out?.artnet ? out.artnet.connected : null} label="art-net" error={out?.artnet?.error} />
              <StatusDot ok={out?.pitchpls_v2 ? out.pitchpls_v2.connected : null} label="v2" error={out?.pitchpls_v2?.error} />
            </div>
          </div>
          <nav className="flex h-9 items-stretch border-x border-b border-edge">
            {PAGES.map((p, i) => (
              <button
                key={p}
                onClick={() => go(p)}
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

        <main className="min-h-0 flex-1 overflow-auto p-1.5">
          {page === 'General' && <General engine={engine} defs={defs} />}
          {page === 'Dimmers' && <Dimmers engine={engine} defs={defs} />}
          {page === 'Fixtures' && <Fixtures engine={engine} defs={defs} />}
          {page === 'Outputs' && <Output engine={engine} />}
          {page === 'Inputs' && <Inputs engine={engine} />}
          {page === 'Fog' && <Fog engine={engine} />}
          {page === 'Settings' && <Settings ui={ui} onChange={setUi} desktop={desktop} />}
        </main>

        {ui.key_hints && (
          <footer className="mx-1.5 flex h-7 flex-none items-center gap-5 border-t border-edge px-2.5 text-[11px]">
            {KEYS.filter(([cap]) => cap !== 'F' || fullscreen.supported).map(([cap, what]) => (
              <span key={cap} className="lbl inline-flex items-center gap-1.5">
                <span className="border border-ink px-1 font-mono text-[11px] leading-[14px]">{cap}</span>
                <span className="text-dim">{what}</span>
              </span>
            ))}
            {footer && (
              <span className="lbl ml-auto">
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
