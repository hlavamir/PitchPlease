import { useState } from 'react'
import { Link } from 'react-router'
import Markdown from '../components/Markdown'
import { Arrow, Container, CupIcon, DownloadIcon, PrimaryButton, SecondaryButton, SectionLabel, usePlatform } from '../components/ui'
import { LATEST, LINKS, PLATFORMS, RELEASES } from '../site'

const NEEDS = [
  { label: 'Computer', text: 'A Mac with Apple Silicon (M1 or later) or a 64-bit Windows PC.' },
  { label: 'Audio', text: 'Any audio input: an interface fed from the mixer, or the built-in microphone to start with.' },
  { label: 'Lights', text: 'An Enttec DMX USB Pro, an Art-Net node, or PitchPlease LED strips over USB serial.' },
  { label: 'Controller', text: 'Optional. A Novation Launch Control XL works out of the box.' },
]

function PageHeader() {
  return (
    <Container className="pt-16 sm:pt-24">
      <div className="lbl text-[12px] text-dim">Download</div>
      <h1 className="mt-5 text-[40px] leading-[1.05] headline text-ink sm:text-[60px]">Download PitchControl!</h1>
      <p className="mt-5 max-w-2xl text-[18px] leading-relaxed text-dim">
        Version {LATEST.version}, released {LATEST.date}. Free and open source. No installer, no account: unpack the zip
        and start it.
      </p>
    </Container>
  )
}

function Platforms({ onDownload }: { onDownload: () => void }) {
  const platform = usePlatform()
  return (
    <Container className="mt-12">
      <div className="grid gap-5 md:grid-cols-2">
        {PLATFORMS.map((p) => {
          const mine = platform === p.id
          return (
            <div
              key={p.id}
              className={`relative flex flex-col border glass p-6 sm:p-8 ${mine ? 'border-amber/70' : 'border-edge'}`}
            >
              {mine && (
                <span className="lbl absolute -top-px right-6 -translate-y-1/2 bg-amber px-2 py-0.5 text-[10px] font-semibold text-ground">
                  Your system
                </span>
              )}
              <div className="flex items-baseline justify-between gap-4">
                <h2 className="text-[28px] headline text-ink">{p.name}</h2>
                <span className="lbl text-[12px] text-dim">{p.detail}</span>
              </div>
              <div className="mt-5 flex flex-wrap items-center gap-x-4 gap-y-1 border-t border-seam pt-4 font-mono text-[13px] text-dim">
                <span className="break-all text-ink">{p.file}</span>
                {p.size && <span>{p.size}</span>}
              </div>
              <div className="mt-8 flex-1" />
              {mine || !platform ? (
                <PrimaryButton href={LINKS.latestRelease} external onClick={onDownload} className="w-full sm:w-auto sm:self-start">
                  <DownloadIcon />
                  Download for {p.name}
                </PrimaryButton>
              ) : (
                <SecondaryButton href={LINKS.latestRelease} external onClick={onDownload} className="w-full sm:w-auto sm:self-start">
                  <DownloadIcon />
                  Download for {p.name}
                </SecondaryButton>
              )}
            </div>
          )
        })}
      </div>
      <p className="mt-5 text-[13px] leading-relaxed text-faint">
        Downloads are hosted on GitHub. The button opens the latest release; pick the zip for your system under
        &ldquo;Assets&rdquo;. Older versions are on the{' '}
        <a href={LINKS.releases} target="_blank" rel="noreferrer" className="text-dim underline decoration-edge underline-offset-4 hover:text-ink">
          releases page
        </a>
        .
      </p>
    </Container>
  )
}

function Donate({ thanks }: { thanks: boolean }) {
  return (
    <Container className="mt-10">
      <div
        className={`flex flex-col gap-6 border glass p-6 transition-[border-color,box-shadow] duration-700 sm:flex-row sm:items-center sm:justify-between sm:p-8 ${
          thanks ? 'border-amber/60 shadow-[0_0_40px_rgb(233_196_106/0.08)]' : 'border-edge'
        }`}
      >
        <div className="max-w-2xl">
          <h2 className="text-[22px] headline text-ink">{thanks ? 'Thanks for downloading!' : 'Keep PitchControl! going'}</h2>
          <p className="mt-2 text-[15px] leading-relaxed text-dim">
            PitchControl! is free and made in spare time. If it runs your shows, consider buying the developer a coffee.
            Every donation goes into new features, fixtures and fixes.
          </p>
        </div>
        <a
          href={LINKS.kofi}
          target="_blank"
          rel="noreferrer"
          className={`lbl inline-flex h-11 flex-none items-center justify-center gap-2.5 px-5 text-[13px] transition-all duration-200 ${
            thanks ? 'glow bg-amber font-semibold text-ground hover:glow-strong' : 'border border-amber/70 text-amber hover:bg-amber hover:text-ground'
          }`}
        >
          <CupIcon />
          Donate on Ko-fi
        </a>
      </div>
    </Container>
  )
}

function Install() {
  const steps = [
    {
      title: 'Unpack',
      body: (
        <>
          Unzip the download and move <span className="font-mono text-ink">PitchControl</span> wherever you like, for
          example to Applications on a Mac.
        </>
      ),
    },
    {
      title: 'First launch',
      body: (
        <>
          The app isn&rsquo;t signed yet, so your system asks once.
          <span className="mt-3 block">
            <span className="text-ink">macOS:</span> open the app; when macOS refuses, go to System Settings → Privacy &amp;
            Security and click <span className="text-ink">Open Anyway</span>. Allow microphone access when asked.
          </span>
          <span className="mt-2 block">
            <span className="text-ink">Windows:</span> in the SmartScreen dialog, click <span className="text-ink">More info</span>{' '}
            → <span className="text-ink">Run anyway</span>.
          </span>
        </>
      ),
    },
    {
      title: 'Set up and play',
      body: (
        <>
          On first start, PitchControl! creates <span className="font-mono text-ink">Documents/PitchControl</span> with a
          default rig. Pick your audio input and outputs, and you&rsquo;re ready.{' '}
          <Link to="/docs/getting-started" className="text-amber underline decoration-amber/40 underline-offset-4 hover:decoration-amber">
            Getting started
          </Link>
        </>
      ),
    },
  ]
  return (
    <section className="mt-28">
      <Container>
        <SectionLabel index="01">Install</SectionLabel>
        <ol className="mt-8 tiles md:grid-cols-3">
          {steps.map((s, i) => (
            <li key={s.title} className="p-6">
              <span className="font-mono text-[12px] text-faint">0{i + 1}</span>
              <h3 className="lbl mt-4 text-[14px] font-medium text-ink">{s.title}</h3>
              <p className="mt-2.5 text-[15px] leading-relaxed text-dim">{s.body}</p>
            </li>
          ))}
        </ol>
      </Container>
    </section>
  )
}

function Needs() {
  return (
    <section className="mt-28">
      <Container>
        <SectionLabel index="02">What you need</SectionLabel>
        <dl className="mt-4">
          {NEEDS.map((n) => (
            <div key={n.label} className="grid gap-1 border-b border-seam py-4 sm:grid-cols-[200px_1fr] sm:gap-6">
              <dt className="lbl text-[13px] text-ink">{n.label}</dt>
              <dd className="text-[15px] text-dim">{n.text}</dd>
            </div>
          ))}
        </dl>
        <p className="mt-6 text-[14px] leading-relaxed text-dim">
          On an Intel Mac or Linux? PitchControl! also runs from source with Python and Node.{' '}
          <a href={LINKS.source} target="_blank" rel="noreferrer" className="inline-flex items-center gap-1.5 text-amber hover:underline">
            Source on GitHub <Arrow />
          </a>
        </p>
      </Container>
    </section>
  )
}

function ReleaseNotes() {
  return (
    <section className="mt-28" id="release-notes">
      <Container>
        <SectionLabel index="03" right={<a href={LINKS.releases} target="_blank" rel="noreferrer" className="hover:text-ink">All releases on GitHub</a>}>
          Release notes
        </SectionLabel>
        <div className="mt-6 glass border border-seam px-5 sm:px-8">
          {RELEASES.map((r) => (
            <article key={r.version} className="grid gap-4 border-b border-seam py-10 last:border-b-0 lg:grid-cols-[240px_1fr] lg:gap-10">
              <header>
                <h3 className="font-mono text-[24px] text-ink">{r.version}</h3>
                <div className="lbl mt-1 text-[12px] text-dim">{r.date}</div>
                {r === LATEST && (
                  <span className="lbl mt-3 inline-block border border-amber/60 px-2 py-0.5 text-[10px] text-amber">Latest</span>
                )}
              </header>
              <Markdown html={r.html} />
            </article>
          ))}
        </div>
      </Container>
    </section>
  )
}

export default function Download() {
  const [thanks, setThanks] = useState(false)
  return (
    <>
      <PageHeader />
      <Platforms onDownload={() => setThanks(true)} />
      <Donate thanks={thanks} />
      <Install />
      <Needs />
      <ReleaseNotes />
    </>
  )
}
