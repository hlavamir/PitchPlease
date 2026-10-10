import { useEffect, useState, type ReactNode } from 'react'
import { Link } from 'react-router'
import { LINKS, type PlatformId } from '../site'

/** The app's 3 × 3 checker glyph. */
export function Glyph({ size = 4 }: { size?: number }) {
  return (
    <span className="grid flex-none grid-cols-3" style={{ gap: 1 }} aria-hidden>
      {[1, 0, 1, 0, 1, 0, 1, 0, 1].map((on, i) => (
        <span key={i} style={{ width: size, height: size }} className={on ? 'bg-amber' : ''} />
      ))}
    </span>
  )
}

export function Wordmark({ className = '' }: { className?: string }) {
  return (
    <span className={`flex items-center gap-2.5 ${className}`}>
      <Glyph />
      <span className="lbl text-[15px] font-semibold tracking-[0.14em] text-ink">PitchControl!</span>
    </span>
  )
}

export function Container({ children, className = '' }: { children: ReactNode; className?: string }) {
  return <div className={`mx-auto w-full max-w-[1240px] px-4 sm:px-6 ${className}`}>{children}</div>
}

/** "01 / Macros" — the numbered panel header of the app. */
export function SectionLabel({ index, children, right }: { index: string; children: ReactNode; right?: ReactNode }) {
  return (
    <div className="flex items-baseline justify-between gap-4 border-b border-seam pb-3">
      <h2 className="lbl text-[13px] text-ink">
        <span className="font-mono text-faint">{index}</span>
        <span className="mx-2 text-faint">/</span>
        {children}
      </h2>
      {right && <div className="lbl hidden text-right text-[12px] text-dim sm:block">{right}</div>}
    </div>
  )
}

type ButtonProps = { href: string; children: ReactNode; className?: string; external?: boolean; onClick?: () => void }

/** Stays in the site for "/…" paths; other sites open in a new tab when `external`. */
function Anchor({ href, external, className, onClick, children }: ButtonProps) {
  if (href.startsWith('/'))
    return (
      <Link to={href} onClick={onClick} className={className}>
        {children}
      </Link>
    )
  return (
    <a href={href} onClick={onClick} className={className} {...(external ? { target: '_blank', rel: 'noreferrer' } : {})}>
      {children}
    </a>
  )
}

/** Filled amber: the one thing to do on a page. */
export function PrimaryButton({ className = '', ...props }: ButtonProps) {
  return (
    <Anchor
      {...props}
      className={`lbl inline-flex h-11 items-center justify-center gap-2.5 bg-amber px-5 text-[13px] font-semibold text-ground glow transition-shadow duration-200 hover:glow-strong ${className}`}
    />
  )
}

/** Outlined: everything else. */
export function SecondaryButton({ className = '', ...props }: ButtonProps) {
  return (
    <Anchor
      {...props}
      className={`lbl inline-flex h-11 items-center justify-center gap-2.5 border border-edge bg-ground/60 px-5 text-[13px] text-ink transition-colors duration-200 hover:border-ink ${className}`}
    />
  )
}

export function Arrow({ className = '' }: { className?: string }) {
  return (
    <svg viewBox="0 0 12 12" className={`size-3 ${className}`} fill="none" stroke="currentColor" strokeWidth="1.5" aria-hidden>
      <path d="M2 6h8M6.5 2.5 10 6l-3.5 3.5" />
    </svg>
  )
}

export function DownloadIcon({ className = '' }: { className?: string }) {
  return (
    <svg viewBox="0 0 12 12" className={`size-3 ${className}`} fill="none" stroke="currentColor" strokeWidth="1.5" aria-hidden>
      <path d="M6 1.5v7M2.8 5.5 6 8.7l3.2-3.2M1.5 10.5h9" />
    </svg>
  )
}

export function CupIcon({ className = '' }: { className?: string }) {
  return (
    <svg viewBox="0 0 14 12" className={`h-3 w-3.5 ${className}`} fill="none" stroke="currentColor" strokeWidth="1.4" aria-hidden>
      <path d="M1.5 2.5h8.5v4a3.5 3.5 0 0 1-3.5 3.5h-1.5a3.5 3.5 0 0 1-3.5-3.5z" />
      <path d="M10 3.5h1a1.75 1.75 0 0 1 0 3.5h-1" />
    </svg>
  )
}

/** `primary`: filled amber (the header); otherwise outlined. */
export function DonateButton({ className = '', compact = false, primary = false }: { className?: string; compact?: boolean; primary?: boolean }) {
  return (
    <a
      href={LINKS.kofi}
      target="_blank"
      rel="noreferrer"
      className={`lbl inline-flex items-center justify-center gap-2 transition-[color,border-color,box-shadow] duration-200 ${
        primary ? 'glow bg-amber font-semibold text-ground hover:glow-strong' : 'border border-edge text-ink hover:border-amber hover:text-amber'
      } ${compact ? 'h-8 px-3 text-[12px]' : 'h-11 px-5 text-[13px]'} ${className}`}
    >
      <CupIcon />
      Donate
    </a>
  )
}

// where each breakpoint's filler is shown: from that breakpoint up to the next one that has columns
const SHOW: Record<string, string> = {
  'base-sm': 'sm:hidden',
  'base-md': 'md:hidden',
  'base-lg': 'lg:hidden',
  'base-': '',
  'sm-md': 'hidden sm:block md:hidden',
  'sm-lg': 'hidden sm:block lg:hidden',
  'sm-': 'hidden sm:block',
  'md-lg': 'hidden md:block lg:hidden',
  'md-': 'hidden md:block',
  'lg-': 'hidden lg:block',
}

/**
 * Empty tiles that complete the last row of a `.tiles` grid, so it never ends in a gap.
 * `cols` gives the column count per breakpoint, as in the grid's own classes.
 */
export function RowFill({ count, cols }: { count: number; cols: Partial<Record<'base' | 'sm' | 'md' | 'lg', number>> }) {
  const bps = (['base', 'sm', 'md', 'lg'] as const).filter((b) => cols[b])
  return bps.flatMap((bp, i) => {
    const n = cols[bp]!
    const missing = (n - (count % n)) % n
    const cls = SHOW[`${bp}-${bps[i + 1] ?? ''}`]
    return Array.from({ length: missing }, (_, k) => <div key={`${bp}${k}`} aria-hidden className={cls} />)
  })
}

/**
 * A screenshot as an abstract laptop screen: a softly rounded outer frame, a frosted bezel and a
 * square 1 px border around the image itself.
 */
export function Framed({ children, className = '' }: { children: ReactNode; className?: string }) {
  return (
    <div className={`glass rounded-[5px] border border-edge p-1.5 sm:rounded-[7px] sm:p-2.5 lg:rounded-[9px] lg:p-3 ${className}`}>
      <div className="border border-edge">{children}</div>
    </div>
  )
}

const PLATFORM_NAMES: Record<PlatformId, string> = { macos: 'macOS', windows: 'Windows' }

/** The visitor's OS, after hydration (null on the server and for other systems). */
export function usePlatform(): PlatformId | null {
  const [p, setP] = useState<PlatformId | null>(null)
  useEffect(() => {
    const nav = navigator as Navigator & { userAgentData?: { platform?: string } }
    const s = `${nav.userAgentData?.platform ?? ''} ${navigator.userAgent}`
    if (/iPhone|iPad|Android/i.test(s)) return
    if (/Win/i.test(s)) setP('windows')
    else if (/Mac/i.test(s)) setP('macos')
  }, [])
  return p
}

export function platformName(p: PlatformId | null) {
  return p ? PLATFORM_NAMES[p] : null
}
