// Server entry used only at build time: renders one page to HTML (see scripts/prerender.mjs).

import { StrictMode } from 'react'
import { renderToString } from 'react-dom/server'
import { StaticRouter } from 'react-router'
import App, { metaFor, PATHS } from './App'

export { PATHS }

const escape = (s: string) => s.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/"/g, '&quot;')

export function render(url: string): { html: string; head: string } {
  const html = renderToString(
    <StrictMode>
      <StaticRouter location={url}>
        <App />
      </StaticRouter>
    </StrictMode>,
  )
  const m = metaFor(url)
  const head = [
    `<title>${escape(m.title)}</title>`,
    `<meta name="description" content="${escape(m.description)}" />`,
    `<meta property="og:title" content="${escape(m.title)}" />`,
    `<meta property="og:description" content="${escape(m.description)}" />`,
    `<meta property="og:type" content="website" />`,
    `<meta name="twitter:card" content="summary_large_image" />`,
  ].join('\n    ')
  return { html, head }
}
