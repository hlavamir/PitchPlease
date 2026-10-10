import { useEffect, useState } from 'react'
import { Link, NavLink, Outlet, useLocation, useNavigate } from 'react-router'
import { LATEST, LINKS } from '../site'
import DitherBackground from './DitherBackground'
import { Container, DonateButton, Glyph, Wordmark } from './ui'

export const NAV = [
  { to: '/', label: 'Home', end: true },
  { to: '/download', label: 'Download', end: false },
  { to: '/docs', label: 'Docs', end: false },
  { to: '/support', label: 'Support', end: false },
]

function Header() {
  const [open, setOpen] = useState(false)
  const location = useLocation()
  useEffect(() => setOpen(false), [location.pathname])

  return (
    <header className="glass-strong sticky top-0 z-30 border-b border-seam">
      <Container className="flex h-14 items-center justify-between gap-6">
        <Link to="/" aria-label="PitchControl! home" className="flex-none">
          <Wordmark />
        </Link>

        <div className="hidden h-full items-center gap-4 md:flex">
          <nav className="flex h-full items-stretch" aria-label="Main">
            {NAV.map((item) => (
              <NavLink
                key={item.to}
                to={item.to}
                end={item.end}
                className={({ isActive }) =>
                  `lbl relative flex items-center px-4 text-[13px] transition-colors ${isActive ? 'text-amber' : 'text-dim hover:text-ink'}`
                }
              >
                {({ isActive }) => (
                  <>
                    {item.label}
                    {isActive && <span className="absolute inset-x-3 -bottom-px h-px bg-amber shadow-[0_0_10px_rgb(233_196_106/0.7)]" />}
                  </>
                )}
              </NavLink>
            ))}
          </nav>
          <DonateButton compact primary />
        </div>

        <button
          className="lbl flex h-8 items-center gap-2 border border-edge px-3 text-[12px] text-ink md:hidden"
          aria-expanded={open}
          aria-controls="mobile-nav"
          onClick={() => setOpen((o) => !o)}
        >
          {open ? 'Close' : 'Menu'}
        </button>
      </Container>

      {open && (
        <nav id="mobile-nav" className="border-t border-seam bg-ground md:hidden" aria-label="Main">
          <Container className="flex flex-col py-2">
            {NAV.map((item) => (
              <NavLink
                key={item.to}
                to={item.to}
                end={item.end}
                className={({ isActive }) => `lbl flex items-center gap-3 border-b border-seam py-3.5 text-[14px] ${isActive ? 'text-amber' : 'text-ink'}`}
              >
                {item.label}
              </NavLink>
            ))}
            <div className="flex gap-2 py-4">
              <DonateButton primary className="flex-1" />
            </div>
          </Container>
        </nav>
      )}
    </header>
  )
}

function Footer() {
  const col = 'flex flex-col gap-2.5 text-[14px]'
  const head = 'lbl mb-1 text-[12px] text-faint'
  const a = 'text-dim transition-colors hover:text-ink'
  return (
    <footer className="glass mt-32 border-t border-seam">
      <Container className="grid gap-10 py-12 sm:grid-cols-2 lg:grid-cols-[1.6fr_1fr_1fr_1fr]">
        <div className="flex flex-col gap-4">
          <Wordmark />
          <p className="max-w-xs text-[14px] leading-relaxed text-dim">
            Audio-reactive light control for macOS and Windows. Free and open source.
          </p>
          <p className="max-w-xs text-[14px] leading-relaxed text-faint">
            Developed by Miroslav Hlava
            <br />
            Germany 2026
          </p>
        </div>
        <div className={col}>
          <div className={head}>Product</div>
          <Link className={a} to="/download">
            Download
          </Link>
          <Link className={a} to="/download#release-notes">
            Release notes
          </Link>
          <a className={a} href={LINKS.source} target="_blank" rel="noreferrer">
            Source code
          </a>
        </div>
        <div className={col}>
          <div className={head}>Help</div>
          <Link className={a} to="/docs">
            Documentation
          </Link>
          <Link className={a} to="/support">
            Support &amp; FAQ
          </Link>
          <a className={a} href={LINKS.issues} target="_blank" rel="noreferrer">
            Report a bug
          </a>
        </div>
        <div className={col}>
          <div className={head}>Support the project</div>
          <a className={a} href={LINKS.kofi} target="_blank" rel="noreferrer">
            Donate on Ko-fi
          </a>
          <a className={a} href={LINKS.repo} target="_blank" rel="noreferrer">
            Star on GitHub
          </a>
        </div>
      </Container>
      <div className="border-t border-seam">
        <Container className="lbl flex flex-wrap items-center justify-between gap-3 py-4 text-[11px] text-faint">
          <span className="flex items-center gap-2.5">
            <Glyph size={3} />
            <span>
              v{LATEST.version} · {LATEST.date}
            </span>
          </span>
          <a href={LINKS.license} target="_blank" rel="noreferrer" className="hover:text-dim">
            MIT License
          </a>
        </Container>
      </div>
    </footer>
  )
}

/** Keys 1–4 switch pages, as 1–9 do in the app. */
function useNumberKeys() {
  const navigate = useNavigate()
  useEffect(() => {
    const onKey = (e: KeyboardEvent) => {
      if (e.metaKey || e.ctrlKey || e.altKey || e.shiftKey) return
      const t = e.target as HTMLElement
      if (t.isContentEditable || /^(INPUT|TEXTAREA|SELECT)$/.test(t.tagName)) return
      const i = Number(e.key) - 1
      if (i >= 0 && i < NAV.length) navigate(NAV[i].to)
    }
    window.addEventListener('keydown', onKey)
    return () => window.removeEventListener('keydown', onKey)
  }, [navigate])
}

/** Scrolls to the top on a new page, or to the #anchor. */
function useScrollRestore() {
  const { pathname, hash } = useLocation()
  useEffect(() => {
    if (hash) {
      document.getElementById(decodeURIComponent(hash.slice(1)))?.scrollIntoView()
    } else {
      window.scrollTo(0, 0)
    }
  }, [pathname, hash])
}

export default function Layout() {
  useNumberKeys()
  useScrollRestore()
  return (
    <div className="flex min-h-screen flex-col overflow-x-clip">
      <DitherBackground />
      <a href="#main" className="lbl sr-only bg-amber px-3 py-2 text-ground focus:not-sr-only focus:fixed focus:top-2 focus:left-2 focus:z-50">
        Skip to content
      </a>
      <Header />
      <main id="main" className="flex-1">
        <Outlet />
      </main>
      <Footer />
    </div>
  )
}
