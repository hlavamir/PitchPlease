import { useRef, useState, type KeyboardEvent } from 'react'
import { Link } from 'react-router'
import MaskPreview, { PRESETS } from '../components/MaskPreview'
import { Arrow, Container, DonateButton, DownloadIcon, Framed, platformName, PrimaryButton, RowFill, SecondaryButton, SectionLabel, usePlatform } from '../components/ui'
import { SCREENSHOTS } from '../content'
import { LATEST } from '../site'

const FLOW = [
  { label: 'Audio in', text: 'Your audio interface, a mixer feed or simply a microphone.' },
  { label: 'Analysis', text: '32 frequency bands. An octave-weighted trigger finds the peaks.' },
  { label: 'Strobo / idle', text: 'Every peak fires the strobo. In between, the lights fade back to their idle colours.' },
  { label: 'Mask', text: 'A moving mask spreads the light across the room.' },
  { label: 'Output', text: 'DMX over USB, Art-Net or serial, 40 frames per second.' },
]

const FEATURES = [
  {
    title: 'Strobo on the peaks',
    text: 'The audio analysis listens for peaks and fires the strobo with them. Decay, attack and reactivity are on faders, so you can go from a gentle glow to full-on flashes.',
  },
  {
    title: 'Two colour groups',
    text: 'Split the rig into groups A and B, each with its own hue and saturation. Let Auto Color pick from a palette, or swap the two with one button.',
  },
  {
    title: 'Eight scenes',
    text: 'Store all 16 macros in a scene and recall it with one key. Build the looks before the night, switch between them as the set evolves.',
  },
  {
    title: 'MIDI controller ready',
    text: 'Plug in a Novation Launch Control XL and play: faders, knobs and buttons are mapped out of the box. Other controllers are a small JSON file away.',
  },
  {
    title: 'DMX and Art-Net',
    text: 'Send to an Enttec DMX USB Pro, to Art-Net nodes on your network and to PitchPlease serial strips, all at once and across up to four universes.',
  },
  {
    title: 'Fixtures and rigs',
    text: 'Describe a fixture model once, channel by channel, then place as many as you need in a rig. Keep one rig per venue and load it in a second.',
  },
  {
    title: 'Control Desk',
    text: 'Every DMX channel as a fader. Take over any channel by hand, for a house light or a stubborn fixture, without leaving the show.',
  },
  {
    title: 'Fog on a timer',
    text: 'Run fog machines on a schedule, “every 60 seconds for 4”, or fire them by hand from the General page or your controller.',
  },
  {
    title: 'Made for the booth',
    text: 'A calm monochrome UI that dims down in a dark room. Everything works from the keyboard, and nothing needs an internet connection.',
  },
]

const TOUR = [
  { shot: 'general', name: 'General', text: 'Play the show: macros, functions, mask presets, scenes, a live preview of every fixture and the audio analysis.' },
  { shot: 'dimmers', name: 'Dimmers', text: 'Sixteen named dimmer faders, one per group of lights.' },
  { shot: 'fixtures', name: 'Fixtures', text: 'The fixture type editor: the channel layout in DMX order and the resulting channel map.' },
  { shot: 'rig', name: 'Rig', text: 'The fixtures of one event: addresses, groups, placement in the room and per-fixture overrides.' },
  { shot: 'inputs', name: 'Inputs', text: 'Audio device and gain with the band meter, the MIDI controller and a monitor of incoming messages.' },
  { shot: 'outputs', name: 'Outputs', text: 'Enttec, Art-Net and serial outputs, with a live view of what every fixture sends.' },
  { shot: 'fog', name: 'Fog', text: 'One panel per fog machine, with its timer and manual trigger.' },
  { shot: 'settings', name: 'Settings', text: 'Ink colour, glow, brightness and scale, plus the full keyboard reference.' },
  { shot: 'control-desk', name: 'Control Desk', text: 'Every DMX channel as a fader, with manual overrides that survive a restart.' },
]

function Hero() {
  const platform = usePlatform()
  const name = platformName(platform)
  const other = platform === 'windows' ? 'macOS' : 'Windows'
  return (
    <section className="relative">
      <Container className="pt-16 sm:pt-24">
        <div className="lbl flex flex-wrap items-center gap-x-3 gap-y-2 text-[12px] text-dim">
          <span className="inline-flex items-center gap-2 border border-edge px-2 py-0.5 font-mono tracking-normal text-ink normal-case">
            <span className="size-1.5 bg-amber shadow-[0_0_6px_rgb(233_196_106/0.8)]" />v{LATEST.version}
          </span>
          <span>macOS · Windows</span>
          <span className="hidden text-faint sm:inline">/</span>
          <span>Free &amp; open source</span>
        </div>

        <h1 className="mt-7 max-w-4xl text-[44px] leading-[1.02] headline text-ink sm:text-[72px] lg:text-[84px]">
          Your lights,
          <br />
          <span className="text-amber text-glow">on the beat.</span>
        </h1>

        <p className="mt-7 max-w-2xl text-[18px] leading-relaxed text-dim sm:text-[20px]">
          PitchControl! listens to the music and plays your lights with it. Peaks fire the strobo, the room glows in
          between, and a moving mask spreads it all across your rig. Run it from the keyboard or a MIDI controller, send
          it over DMX or Art-Net.
        </p>

        <div className="mt-9 flex flex-wrap items-center gap-3">
          <PrimaryButton href="/download">
            <DownloadIcon />
            {name ? `Download for ${name}` : 'Download'}
          </PrimaryButton>
          <SecondaryButton href="/docs">
            Read the docs
            <Arrow />
          </SecondaryButton>
        </div>
        <p className="mt-4 text-[13px] text-faint">
          {name ? `Also for ${other}. ` : 'For macOS (Apple Silicon) and Windows. '}
          Version {LATEST.version}, released {LATEST.date}.{' '}
          <Link to="/download#release-notes" className="text-dim underline decoration-edge underline-offset-4 hover:text-ink">
            What&rsquo;s new
          </Link>
        </p>
      </Container>

      <Container className="mt-16 sm:mt-20">
        <div className="relative">
          {/* a faint amber haze behind the screenshot */}
          <div
            aria-hidden
            className="pointer-events-none absolute -inset-x-10 -inset-y-16 opacity-60"
            style={{ background: 'radial-gradient(60% 55% at 50% 45%, rgb(233 196 106 / 0.09), transparent 70%)' }}
          />
          <Framed className="relative">
            <img
              src={SCREENSHOTS.general}
              alt="The General page of PitchControl: 16 macro faders, function buttons, scenes, a scene preview and the audio analysis."
              width={3024}
              height={1830}
              className="block w-full"
              fetchPriority="high"
            />
          </Framed>
        </div>
      </Container>
    </section>
  )
}

function Flow() {
  return (
    <section className="mt-32">
      <Container>
        <SectionLabel index="01" right="40 frames per second">
          How it works
        </SectionLabel>
        <ol className="mt-8 tiles md:grid-cols-5">
          {FLOW.map((step, i) => (
            <li key={step.label} className="relative p-5">
              <div className="flex items-center justify-between">
                <span className="font-mono text-[12px] text-faint">0{i + 1}</span>
                {i < FLOW.length - 1 && <Arrow className="hidden text-faint md:block" />}
              </div>
              <h3 className="lbl mt-6 text-[14px] font-medium text-ink">{step.label}</h3>
              <p className="mt-2 text-[14px] leading-relaxed text-dim">{step.text}</p>
            </li>
          ))}
        </ol>
      </Container>
    </section>
  )
}

function Masks() {
  return (
    <section className="mt-32">
      <Container>
        <SectionLabel index="02" right="Live preview">
          Mask presets
        </SectionLabel>
        <div className="mt-8">
          <div className="grid gap-4 lg:grid-cols-2 lg:gap-16">
            <h3 className="text-[28px] leading-tight headline text-ink">Four ways to move light through a room.</h3>
            <p className="text-[16px] leading-relaxed text-dim">
              Every fixture has a place in the room, and the mask decides how bright each pixel is. Change the speed and
              shape from the faders, mirror it with symmetry, and switch presets with a smooth crossfade.
            </p>
          </div>
          <div className="tiles mt-10 grid-cols-2 lg:grid-cols-4">
            {PRESETS.map((p, i) => (
              <figure key={p.name} className="p-3">
                <MaskPreview preset={i} />
                <figcaption className="mt-3 flex items-baseline justify-between gap-3">
                  <span className="lbl text-[13px] text-ink">{p.name}</span>
                  <span className="font-mono text-[12px] text-faint">{p.key}</span>
                </figcaption>
                <p className="mt-1 text-[13px] leading-snug text-dim">{p.text}</p>
              </figure>
            ))}
          </div>
        </div>
      </Container>
    </section>
  )
}

function Features() {
  return (
    <section className="mt-32">
      <Container>
        <SectionLabel index="03">Features</SectionLabel>
        <div className="mt-8 tiles sm:grid-cols-2 lg:grid-cols-3">
          {FEATURES.map((f, i) => (
            <div key={f.title} className="p-6">
              <span className="font-mono text-[12px] text-faint">{String(i + 1).padStart(2, '0')}</span>
              <h3 className="lbl mt-4 text-[14px] font-medium text-ink">{f.title}</h3>
              <p className="mt-2.5 text-[15px] leading-relaxed text-dim">{f.text}</p>
            </div>
          ))}
          <RowFill count={FEATURES.length} cols={{ base: 1, sm: 2, lg: 3 }} />
        </div>
      </Container>
    </section>
  )
}

function Tour() {
  // the hero already shows General; open on another page
  const [sel, setSel] = useState(3)
  const tabs = useRef<(HTMLButtonElement | null)[]>([])
  const page = TOUR[sel]

  // arrow keys move the selection and the focus together (roving tabindex)
  const onKeyDown = (e: KeyboardEvent<HTMLDivElement>) => {
    const step = ({ ArrowRight: 1, ArrowLeft: -1 } as Record<string, number>)[e.key]
    let next = step === undefined ? -1 : (sel + step + TOUR.length) % TOUR.length
    if (e.key === 'Home') next = 0
    if (e.key === 'End') next = TOUR.length - 1
    if (next < 0) return
    e.preventDefault()
    setSel(next)
    tabs.current[next]?.focus()
  }

  return (
    <section className="mt-32">
      <Container>
        <SectionLabel index="04" right="Nine pages, keys 1–9">
          A look around
        </SectionLabel>
        {/* the app's page tabs: a framed row, the tabs from the left, the rest of the row empty.
            No transitions: the highlight switches in one frame, as in the app. */}
        <div role="tablist" aria-label="App pages" onKeyDown={onKeyDown} className="glass mt-8 flex flex-wrap border border-edge">
          {TOUR.map((t, i) => {
            const on = i === sel
            return (
              <button
                key={t.shot}
                ref={(el) => {
                  tabs.current[i] = el
                }}
                id={`tour-tab-${t.shot}`}
                role="tab"
                aria-selected={on}
                aria-controls="tour-panel"
                tabIndex={on ? 0 : -1}
                onClick={() => setSel(i)}
                className={`lbl -mb-px flex flex-none items-center gap-2 border-r border-b px-4 py-3 text-[12px] whitespace-nowrap ${
                  on ? 'glow-soft relative z-10 border-amber bg-amber text-ground' : 'border-edge text-dim hover:text-ink'
                }`}
              >
                <span className={`font-mono text-[10px] ${on ? 'text-ground/60' : 'text-faint'}`}>{i + 1}</span>
                {t.name}
              </button>
            )
          })}
        </div>
        <div id="tour-panel" role="tabpanel" aria-labelledby={`tour-tab-${page.shot}`} className="mt-6">
          <p className="max-w-3xl text-[16px] leading-relaxed text-dim">
            <span className="lbl mr-2 text-ink">{page.name}</span>
            {page.text}
          </p>
          <Framed className="mt-8">
            {/* all nine stacked in one cell and loaded up front, so switching never shows an empty frame */}
            <div className="grid">
              {TOUR.map((t, i) => (
                <img
                  key={t.shot}
                  src={SCREENSHOTS[t.shot]}
                  alt={i === sel ? `The ${t.name} page` : ''}
                  aria-hidden={i !== sel}
                  width={3024}
                  height={1830}
                  loading="lazy"
                  className={`col-start-1 row-start-1 block w-full ${i === sel ? '' : 'invisible'}`}
                />
              ))}
            </div>
          </Framed>
        </div>
      </Container>
    </section>
  )
}

function Closing() {
  return (
    <section className="mt-32">
      <Container>
        <div className="relative overflow-hidden glass border border-edge px-6 py-14 sm:px-12">
          <div aria-hidden className="hatch pointer-events-none absolute inset-y-0 right-0 hidden w-1/3 opacity-60 lg:block" />
          <div className="relative max-w-2xl">
            <h2 className="text-[32px] leading-tight headline text-ink sm:text-[40px]">Free, open source, ready for tonight.</h2>
            <p className="mt-4 text-[16px] leading-relaxed text-dim">
              PitchControl! is MIT licensed and costs nothing. Download it, plug in your lights and play. If it ends up
              running your shows, a small donation keeps it going.
            </p>
            <div className="mt-8 flex flex-wrap gap-3">
              <PrimaryButton href="/download">
                <DownloadIcon />
                Download
              </PrimaryButton>
              <DonateButton />
            </div>
          </div>
        </div>
      </Container>
    </section>
  )
}

export default function Home() {
  return (
    <>
      <Hero />
      <Flow />
      <Masks />
      <Features />
      <Tour />
      <Closing />
    </>
  )
}
