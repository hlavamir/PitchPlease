import { Link, NavLink, useParams } from 'react-router'
import Markdown from '../components/Markdown'
import { Arrow, Container, RowFill } from '../components/ui'
import { DOCS } from '../content'
import NotFound from './NotFound'

const num = (i: number) => String(i + 1).padStart(2, '0')

function Sidebar() {
  return (
    <nav aria-label="Documentation" className="glass border border-seam p-4 lg:sticky lg:top-20">
      <div className="lbl mb-3 text-[12px] text-faint">Documentation</div>
      <ul className="flex flex-col border-l border-seam">
        {DOCS.map((d, i) => (
          <li key={d.slug}>
            <NavLink
              to={`/docs/${d.slug}`}
              className={({ isActive }) =>
                `-ml-px flex items-baseline gap-3 border-l py-1.5 pl-4 text-[14px] transition-colors ${
                  isActive ? 'border-amber text-amber' : 'border-transparent text-dim hover:border-edge hover:text-ink'
                }`
              }
            >
              <span className="font-mono text-[11px] text-faint">{num(i)}</span>
              {d.title}
            </NavLink>
          </li>
        ))}
      </ul>
    </nav>
  )
}

function DocsIndex() {
  return (
    <Container className="pt-16 sm:pt-24">
      <div className="lbl text-[12px] text-dim">Docs</div>
      <h1 className="mt-5 text-[40px] leading-[1.05] headline text-ink sm:text-[60px]">Documentation</h1>
      <p className="mt-5 max-w-2xl text-[18px] leading-relaxed text-dim">
        Everything from the first start to building your own fixture types. New here? Start with{' '}
        <Link to={`/docs/${DOCS[0]?.slug ?? ''}`} className="text-amber underline decoration-amber/40 underline-offset-4 hover:decoration-amber">
          {DOCS[0]?.title ?? 'Getting started'}
        </Link>
        .
      </p>
      <div className="tiles mt-12 sm:grid-cols-2 lg:grid-cols-3">
        {DOCS.map((d, i) => (
          <Link key={d.slug} to={`/docs/${d.slug}`} className="group flex flex-col p-6 transition-colors hover:bg-panel-2/80">
            <span className="font-mono text-[12px] text-faint">{num(i)}</span>
            <h2 className="lbl mt-4 text-[14px] font-medium text-ink group-hover:text-amber">{d.title}</h2>
            <p className="mt-2.5 flex-1 text-[15px] leading-relaxed text-dim">{d.description}</p>
            <Arrow className="mt-5 text-faint transition-transform group-hover:translate-x-1 group-hover:text-amber" />
          </Link>
        ))}
        <RowFill count={DOCS.length} cols={{ base: 1, sm: 2, lg: 3 }} />
      </div>
    </Container>
  )
}

function DocPage({ slug }: { slug: string }) {
  const i = DOCS.findIndex((d) => d.slug === slug)
  if (i < 0) return <NotFound />
  const doc = DOCS[i]
  const prev = DOCS[i - 1]
  const next = DOCS[i + 1]
  return (
    <Container className="pt-12 sm:pt-16">
      <div className="grid gap-12 lg:grid-cols-[220px_minmax(0,1fr)] xl:grid-cols-[220px_minmax(0,1fr)_200px]">
        <aside className="hidden lg:block">
          <Sidebar />
        </aside>

        <article className="min-w-0 glass border border-seam px-5 py-8 sm:px-10 sm:py-12">
          <div className="lbl text-[12px] text-dim">
            <Link to="/docs" className="hover:text-ink">
              Docs
            </Link>
            <span className="mx-2 text-faint">/</span>
            <span className="font-mono text-faint">{num(i)}</span>
          </div>
          <h1 className="mt-4 text-[34px] leading-tight headline text-ink sm:text-[44px]">{doc.title}</h1>
          {doc.description && <p className="mt-3 text-[18px] leading-relaxed text-dim">{doc.description}</p>}
          <Markdown html={doc.html} className="mt-10" />

          <nav className="mt-16 tiles sm:grid-cols-2" aria-label="Previous and next page">
            {prev ? (
              <Link to={`/docs/${prev.slug}`} className="group p-5 hover:bg-panel-2/80">
                <div className="lbl text-[11px] text-faint">Previous</div>
                <div className="mt-1 text-[15px] text-ink group-hover:text-amber">{prev.title}</div>
              </Link>
            ) : (
              <div className="hatch hidden sm:block" />
            )}
            {next ? (
              <Link to={`/docs/${next.slug}`} className="group p-5 text-right hover:bg-panel-2/80">
                <div className="lbl text-[11px] text-faint">Next</div>
                <div className="mt-1 text-[15px] text-ink group-hover:text-amber">{next.title}</div>
              </Link>
            ) : (
              <div className="hatch hidden sm:block" />
            )}
          </nav>
        </article>

        {doc.headings.length > 1 && (
          <aside className="hidden xl:block">
            <div className="glass sticky top-20 border border-seam p-4">
              <div className="lbl mb-3 text-[12px] text-faint">On this page</div>
              <ul className="flex flex-col gap-2 text-[13px]">
                {doc.headings.map((h) => (
                  <li key={h.id}>
                    <a href={`#${h.id}`} className="text-dim transition-colors hover:text-ink">
                      {h.text}
                    </a>
                  </li>
                ))}
              </ul>
            </div>
          </aside>
        )}
      </div>

      {/* the page list, for small screens */}
      <div className="mt-12 lg:hidden">
        <Sidebar />
      </div>
    </Container>
  )
}

export default function Docs() {
  const { slug } = useParams()
  return slug ? <DocPage slug={slug} /> : <DocsIndex />
}
