// The Markdown content in src/content (docs pages and the support FAQ), rendered at build time.

import type { MarkdownModule } from './markdown-types'

export interface Doc {
  slug: string
  title: string
  description: string
  order: number
  html: string
  headings: { id: string; text: string }[] // the ## headings, for "On this page"
}

const docFiles = import.meta.glob<MarkdownModule>('./content/docs/*.md', { import: 'default', eager: true })

export const DOCS: Doc[] = Object.entries(docFiles)
  .map(([path, md]) => ({
    slug: path.split('/').pop()!.replace(/\.md$/, ''),
    title: md.meta.title ?? '',
    description: md.meta.description ?? '',
    order: Number(md.meta.order ?? 99),
    html: md.html,
    headings: md.sections.map((s) => ({ id: s.id, text: s.title })),
  }))
  .sort((a, b) => a.order - b.order)

const supportFiles = import.meta.glob<MarkdownModule>('./content/support.md', { import: 'default', eager: true })
const support = Object.values(supportFiles)[0]

/** The support page: each ## heading of support.md is one question. */
export const FAQ = {
  description: support?.meta.description ?? '',
  intro: support?.intro ?? '',
  items: support?.sections ?? [],
}

// The app screenshots, straight from the app's folder.
const shots = import.meta.glob<string>('../../pitch_control/screenshots/*.png', { query: '?url', import: 'default', eager: true })
export const SCREENSHOTS: Record<string, string> = Object.fromEntries(
  Object.entries(shots).map(([path, url]) => [path.split('/').pop()!.replace(/\.png$/, ''), url]),
)
