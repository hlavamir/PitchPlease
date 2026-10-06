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
import { DEFAULT_UI, applyTheme, type UiSettings } from './theme'
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
  const [ui, setUi] = useState<UiSettings>(DEFAULT_UI)
  const [footer, setFooter] = useState<FooterSelection | null>(null)

  useEffect(() => {
    api.get<MacroDef[]>('/api/macros/defs').then((list) => setDefs(Object.fromEntries(list.map((d) => [d.name, d]))))
    api.get<{ desktop: boolean }>('/api/app-info').then((info) => setDesktop(info.desktop)).catch(() => undefined)
    api.get<SettingsData>('/api/settings').then((s) => s.ui && setUi({ ...DEFAULT_UI, ...s.ui }))
    const onHash = () => setPage(initialPage())
    window.addEventListener('hashchange', onHash)
    return () => window.removeEventListener('hashchange', onHash)
  }, [])

  useEffect(() => applyTheme(ui), [ui])

  const go = useCallback((p: Page) => {
    setPage(p)
    history.replaceState(null, '', `#${p}`)
  }, [])

  // 1–7 switch pages (not while typing in a field)
  useEffect(() => {
    const onKey = (e: KeyboardEvent) => {
      if (isTyping(e) || e.metaKey || e.ctrlKey || e.altKey) return
      const n = Number(e.key)
      if (Number.isInteger(n) && n >= 1 && n <= PAGES.length) {
        e.preventDefault()
        go(PAGES[n - 1])
      }
    }
    window.addEventListener('keydown', onKey)
    return () => window.removeEventListener('keydown', onKey)
  }, [go])

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
  return (
    <SelectionContext.Provider value={setFooter}>
      <div className="flex h-full flex-col">
        <header className="flex h-11 flex-none items-stretch border-b border-edge">
          <div className="flex items-center gap-2.5 border-r border-edge px-4">
            <Glyph />
            <h1 className="lbl text-glow text-[15px] font-semibold tracking-[0.14em]">PitchControl</h1>
          </div>
          <nav className="flex items-stretch">
            {PAGES.map((p, i) => (
              <button
                key={p}
                onClick={() => go(p)}
                className={`lbl flex items-center gap-2 border-r border-edge px-4 text-[12px] ${
                  page === p ? 'glow-on bg-ink text-ground' : 'text-ink hover:bg-panel-2'
                }`}
              >
                <span className="font-mono text-[11px] opacity-60">{i + 1}</span>
                {p}
              </button>
            ))}
          </nav>
          <div className="ml-auto flex items-center gap-4 px-4">
            {desktop && (
              <span className="flex gap-1">
                <button className="lbl glow-hover border border-edge px-2 py-0.5 text-[10px]" onClick={() => api.post('/api/open-browser')}>
                  Open in browser
                </button>
                <button className="lbl glow-hover border border-edge px-2 py-0.5 text-[10px]" onClick={() => api.post('/api/open-data-folder')}>
                  Data folder
                </button>
              </span>
            )}
            <span className={`font-mono text-[13px] ${engine.connected ? 'text-ink' : 'text-dim'}`}>
              {engine.connected ? `${(s?.fps ?? 0).toFixed(1)} FPS` : 'ENGINE OFFLINE'}
            </span>
            <StatusDot ok={s?.io.audio ? s.io.audio.running : null} label="audio" error={s?.io.audio?.error} />
            <StatusDot ok={s?.io.midi ? Boolean(s.io.midi.port) : null} label="midi" error={s?.io.midi?.error} />
            <StatusDot ok={out?.enttec ? out.enttec.connected : null} label="enttec" error={out?.enttec?.error} />
            <StatusDot ok={out?.artnet ? out.artnet.connected : null} label="art-net" error={out?.artnet?.error} />
            <StatusDot ok={out?.pitchpls_v2 ? out.pitchpls_v2.connected : null} label="v2" error={out?.pitchpls_v2?.error} />
          </div>
        </header>

        <main className="min-h-0 flex-1 overflow-auto p-3">
          {page === 'General' && <General engine={engine} defs={defs} />}
          {page === 'Dimmers' && <Dimmers engine={engine} defs={defs} />}
          {page === 'Fixtures' && <Fixtures engine={engine} defs={defs} />}
          {page === 'Outputs' && <Output engine={engine} />}
          {page === 'Inputs' && <Inputs engine={engine} />}
          {page === 'Fog' && <Fog engine={engine} />}
          {page === 'Settings' && <Settings ui={ui} onChange={setUi} />}
        </main>

        {ui.key_hints && (
          <footer className="flex h-7 flex-none items-center gap-5 border-t border-edge px-4 text-[11px]">
            {KEYS.map(([cap, what]) => (
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
