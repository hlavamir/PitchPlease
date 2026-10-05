import { useEffect, useState } from 'react'
import { api, type MacroDef } from './api'
import { StatusDot } from './components/forms'
import { Dimmers } from './pages/Dimmers'
import { Fixtures } from './pages/Fixtures'
import { Fog } from './pages/Fog'
import { General } from './pages/General'
import { Inputs } from './pages/Inputs'
import { Output } from './pages/Output'
import { useEngine } from './useEngine'

const PAGES = ['General', 'Dimmers', 'Fixtures', 'Output', 'Inputs', 'Fog'] as const
type Page = (typeof PAGES)[number]

function initialPage(): Page {
  const hash = decodeURIComponent(location.hash.slice(1))
  return (PAGES as readonly string[]).includes(hash) ? (hash as Page) : 'General'
}

export default function App() {
  const engine = useEngine()
  const [page, setPage] = useState<Page>(initialPage)
  const [defs, setDefs] = useState<Record<string, MacroDef>>({})
  const [desktop, setDesktop] = useState(false)

  useEffect(() => {
    api.get<MacroDef[]>('/api/macros/defs').then((list) => setDefs(Object.fromEntries(list.map((d) => [d.name, d]))))
    api.get<{ desktop: boolean }>('/api/app-info').then((info) => setDesktop(info.desktop)).catch(() => undefined)
    const onHash = () => setPage(initialPage())
    window.addEventListener('hashchange', onHash)
    return () => window.removeEventListener('hashchange', onHash)
  }, [])

  const go = (p: Page) => {
    setPage(p)
    history.replaceState(null, '', `#${p}`)
  }

  const s = engine.state
  const out = s?.io.outputs
  return (
    <div className="flex min-h-full flex-col">
      <header className="flex flex-wrap items-center gap-x-6 gap-y-2 border-b border-edge bg-panel px-4 py-2">
        <h1 className="text-lg font-bold tracking-tight">
          Pitch<span className="text-accent">Control</span>
        </h1>
        <nav className="flex flex-wrap gap-1">
          {PAGES.map((p) => (
            <button
              key={p}
              onClick={() => go(p)}
              className={`rounded px-3 py-1.5 text-sm ${page === p ? 'bg-accent font-semibold text-neutral-900' : 'text-neutral-300 hover:bg-panel-2'}`}
            >
              {p}
            </button>
          ))}
        </nav>
        <div className="ml-auto flex flex-wrap items-center gap-4">
          {desktop && (
            <span className="flex gap-1">
              <button className="rounded px-2 py-1 text-xs text-neutral-400 hover:bg-panel-2" onClick={() => api.post('/api/open-browser')}>
                Open in browser
              </button>
              <button className="rounded px-2 py-1 text-xs text-neutral-400 hover:bg-panel-2" onClick={() => api.post('/api/open-data-folder')}>
                Data folder
              </button>
            </span>
          )}
          <StatusDot ok={engine.connected} label={engine.connected ? `${s?.fps ?? 0} fps` : 'engine offline'} />
          <StatusDot ok={s?.io.audio ? s.io.audio.running : null} label="audio" error={s?.io.audio?.error} />
          <StatusDot ok={s?.io.midi ? Boolean(s.io.midi.port) : null} label="midi" error={s?.io.midi?.error} />
          <StatusDot ok={out?.enttec ? out.enttec.connected : null} label="enttec" error={out?.enttec?.error} />
          <StatusDot ok={out?.artnet ? out.artnet.connected : null} label="art-net" error={out?.artnet?.error} />
          <StatusDot ok={out?.pitchpls_v2 ? out.pitchpls_v2.connected : null} label="v2" error={out?.pitchpls_v2?.error} />
        </div>
      </header>
      <main className="flex-1 p-3">
        {page === 'General' && <General engine={engine} defs={defs} />}
        {page === 'Dimmers' && <Dimmers engine={engine} defs={defs} />}
        {page === 'Fixtures' && <Fixtures engine={engine} defs={defs} />}
        {page === 'Output' && <Output engine={engine} />}
        {page === 'Inputs' && <Inputs engine={engine} />}
        {page === 'Fog' && <Fog engine={engine} />}
      </main>
    </div>
  )
}
