import { Link } from 'react-router'
import Markdown from '../components/Markdown'
import { Arrow, Container, CupIcon, SectionLabel } from '../components/ui'
import { FAQ } from '../content'
import { LINKS } from '../site'

const CHANNELS = [
  {
    title: 'Read the docs',
    text: 'Setup, every page of the app, fixtures, MIDI and outputs, explained step by step.',
    action: 'Documentation',
    to: '/docs',
  },
  {
    title: 'Report a bug',
    text: 'Something broken or behaving oddly? Open an issue on GitHub, with the log file attached.',
    action: 'Open an issue',
    href: LINKS.newIssue,
  },
  {
    title: 'Ideas and requests',
    text: 'Missing a fixture, an output or a controller? Suggest it on GitHub, other users can chime in.',
    action: 'Browse issues',
    href: LINKS.issues,
  },
]

function Channel({ c }: { c: (typeof CHANNELS)[number] }) {
  const inner = (
    <>
      <h2 className="lbl text-[14px] font-medium text-ink group-hover:text-amber">{c.title}</h2>
      <p className="mt-2.5 flex-1 text-[15px] leading-relaxed text-dim">{c.text}</p>
      <span className="lbl mt-6 inline-flex items-center gap-2 text-[12px] text-amber">
        {c.action}
        <Arrow className="transition-transform group-hover:translate-x-1" />
      </span>
    </>
  )
  const cls = 'group flex flex-col p-6 transition-colors hover:bg-panel-2/80'
  return 'to' in c && c.to ? (
    <Link to={c.to} className={cls}>
      {inner}
    </Link>
  ) : (
    <a href={c.href} target="_blank" rel="noreferrer" className={cls}>
      {inner}
    </a>
  )
}

export default function Support() {
  return (
    <>
      <Container className="pt-16 sm:pt-24">
        <div className="lbl text-[12px] text-dim">Support</div>
        <h1 className="mt-5 text-[40px] leading-[1.05] headline text-ink sm:text-[60px]">How can we help?</h1>
        <p className="mt-5 max-w-2xl text-[18px] leading-relaxed text-dim">
          {FAQ.description || 'Answers to common questions, and where to go when something doesn’t work.'}
        </p>
        <div className="mt-12 tiles md:grid-cols-3">
          {CHANNELS.map((c) => (
            <Channel key={c.title} c={c} />
          ))}
        </div>
      </Container>

      {FAQ.items.length > 0 && (
        <section className="mt-28">
          <Container>
            <SectionLabel index="01" right={`${FAQ.items.length} questions`}>
              Frequently asked
            </SectionLabel>
            {FAQ.intro && <Markdown html={FAQ.intro} className="mt-6 max-w-3xl" />}
            <div className="mt-6 glass border border-seam px-5 sm:px-8">
              {FAQ.items.map((item) => (
                <details key={item.id} id={item.id} className="group border-b border-seam last:border-b-0">
                  <summary className="flex cursor-pointer list-none items-center justify-between gap-6 py-5 text-[17px] text-ink transition-colors hover:text-amber [&::-webkit-details-marker]:hidden">
                    {item.title}
                    <span aria-hidden className="relative size-3 flex-none">
                      <span className="absolute inset-x-0 top-1/2 h-px bg-current" />
                      <span className="absolute inset-y-0 left-1/2 w-px bg-current transition-transform group-open:scale-y-0" />
                    </span>
                  </summary>
                  <div className="max-w-3xl pb-7">
                    <Markdown html={item.html} />
                  </div>
                </details>
              ))}
            </div>
          </Container>
        </section>
      )}

      <section className="mt-28">
        <Container>
          <div className="flex flex-col gap-6 border border-edge glass p-6 sm:flex-row sm:items-center sm:justify-between sm:p-8">
            <div className="max-w-2xl">
              <h2 className="text-[22px] headline text-ink">PitchControl! helped your show?</h2>
              <p className="mt-2 text-[15px] leading-relaxed text-dim">
                It&rsquo;s free and made in spare time. A donation on Ko-fi says thanks and keeps the updates coming.
              </p>
            </div>
            <a
              href={LINKS.kofi}
              target="_blank"
              rel="noreferrer"
              className="lbl inline-flex h-11 flex-none items-center justify-center gap-2.5 border border-amber/70 px-5 text-[13px] text-amber transition-colors hover:bg-amber hover:text-ground"
            >
              <CupIcon />
              Donate on Ko-fi
            </a>
          </div>
        </Container>
      </section>
    </>
  )
}
