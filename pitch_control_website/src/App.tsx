import { useEffect } from 'react'
import { Route, Routes, useLocation } from 'react-router'
import Layout from './components/Layout'
import { DOCS, FAQ } from './content'
import Docs from './pages/Docs'
import Download from './pages/Download'
import Home from './pages/Home'
import NotFound from './pages/NotFound'
import Support from './pages/Support'
import { LATEST } from './site'

export interface Meta {
  title: string
  description: string
}

const SITE = 'PitchControl!'
const DEFAULT_DESCRIPTION =
  'PitchControl! is free, audio-reactive light control for macOS and Windows: strobo on the peaks, moving masks across your rig, DMX and Art-Net out, MIDI controller ready.'

/** Every page that is rendered to static HTML at build time. */
export const PATHS = ['/', '/download', '/docs', ...DOCS.map((d) => `/docs/${d.slug}`), '/support', '/404']

export function metaFor(path: string): Meta {
  const p = path.replace(/\/+$/, '') || '/'
  if (p === '/') return { title: `${SITE} · Audio-reactive light control`, description: DEFAULT_DESCRIPTION }
  if (p === '/download')
    return { title: `Download · ${SITE}`, description: `Download PitchControl! ${LATEST.version} for macOS (Apple Silicon) and Windows. Free and open source.` }
  if (p === '/docs') return { title: `Documentation · ${SITE}`, description: 'Learn PitchControl!: setup, playing a show, fixtures and rigs, audio, MIDI and outputs.' }
  if (p.startsWith('/docs/')) {
    const doc = DOCS.find((d) => d.slug === p.slice(6))
    if (doc) return { title: `${doc.title} · ${SITE} Docs`, description: doc.description || DEFAULT_DESCRIPTION }
  }
  if (p === '/support') return { title: `Support · ${SITE}`, description: FAQ.description || 'Answers to common questions about PitchControl!.' }
  return { title: `Page not found · ${SITE}`, description: DEFAULT_DESCRIPTION }
}

function useDocumentMeta() {
  const { pathname } = useLocation()
  useEffect(() => {
    const m = metaFor(pathname)
    document.title = m.title
    document.querySelector('meta[name="description"]')?.setAttribute('content', m.description)
  }, [pathname])
}

export default function App() {
  useDocumentMeta()
  return (
    <Routes>
      <Route element={<Layout />}>
        <Route index element={<Home />} />
        <Route path="download" element={<Download />} />
        <Route path="docs" element={<Docs />} />
        <Route path="docs/:slug" element={<Docs />} />
        <Route path="support" element={<Support />} />
        <Route path="*" element={<NotFound />} />
      </Route>
    </Routes>
  )
}
