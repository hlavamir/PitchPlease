// Vite plugin: `import doc from './page.md'` gives the page already rendered to HTML at build time,
// so the browser needs no Markdown parser. GitHub-flavoured Markdown, raw HTML (<kbd>), heading ids.
//
// Images with a bare file name (`![…](general.png)`) are looked up next to the .md file, then in
// `assetDirs` (the app's screenshots), and bundled like any imported asset.

import { existsSync, readFileSync } from 'node:fs'
import { dirname, resolve } from 'node:path'
import type { Element, ElementContent, Root, RootContent } from 'hast'
import rehypeRaw from 'rehype-raw'
import rehypeSlug from 'rehype-slug'
import rehypeStringify from 'rehype-stringify'
import remarkGfm from 'remark-gfm'
import remarkParse from 'remark-parse'
import remarkRehype from 'remark-rehype'
import { unified } from 'unified'
import { visit } from 'unist-util-visit'
import type { Plugin } from 'vite'

function frontmatter(raw: string): { meta: Record<string, string>; body: string } {
  const m = raw.replace(/\r\n/g, '\n').match(/^---\n([\s\S]*?)\n---\n?([\s\S]*)$/)
  if (!m) return { meta: {}, body: raw }
  const meta: Record<string, string> = {}
  for (const line of m[1].split('\n')) {
    const i = line.indexOf(':')
    if (i > 0) meta[line.slice(0, i).trim()] = line.slice(i + 1).trim().replace(/^["']|["']$/g, '')
  }
  return { meta, body: m[2] }
}

function text(node: RootContent | ElementContent): string {
  if (node.type === 'text') return node.value
  if ('children' in node) return (node.children as ElementContent[]).map(text).join('')
  return ''
}

const isH2 = (n: RootContent): n is Element => n.type === 'element' && n.tagName === 'h2'

interface Options {
  assetDirs?: string[]
  /** The URL a .md file is shown at, to turn its relative links (`audio-and-midi`, `../support`) into absolute ones. */
  urlOf?: (file: string) => string
}

export function markdown({ assetDirs = [], urlOf = () => '/' }: Options = {}): Plugin {
  const toHast = unified().use(remarkParse).use(remarkGfm).use(remarkRehype, { allowDangerousHtml: true }).use(rehypeRaw).use(rehypeSlug)
  const toHtml = unified().use(rehypeStringify)
  const stringify = (children: RootContent[]) => toHtml.stringify({ type: 'root', children } as Root)

  return {
    name: 'markdown-html',
    enforce: 'pre',
    async load(id) {
      const [file, query] = id.split('?')
      if (!file.endsWith('.md') || query) return null // `?raw` and friends stay with Vite
      const { meta, body } = frontmatter(readFileSync(file, 'utf8'))
      const tree = (await toHast.run(toHast.parse(body))) as Root

      // bundle the images, make site links absolute, open other sites in a new tab
      const imports: string[] = []
      visit(tree, 'element', (el: Element) => {
        if (el.tagName === 'img') {
          const src = String(el.properties.src ?? '')
          if (!/^(https?:|\/|data:)/.test(src)) {
            const found = [dirname(file), ...assetDirs].map((d) => resolve(d, src)).find((p) => existsSync(p))
            if (found) {
              el.properties.src = `\u0000${imports.length}\u0000`
              imports.push(found.replace(/\\/g, '/'))
            } else this.warn(`${file}: image not found: ${src}`)
          }
          el.properties.loading = 'lazy'
          el.properties.decoding = 'async'
        }
        if (el.tagName === 'a') {
          const href = String(el.properties.href ?? '')
          if (/^[a-z]+:/i.test(href)) {
            el.properties.target = '_blank'
            el.properties.rel = ['noreferrer']
          } else if (href && !href.startsWith('/') && !href.startsWith('#')) {
            const url = new URL(href, 'https://site' + urlOf(file.replace(/\\/g, '/')))
            el.properties.href = url.pathname + url.hash
          }
        }
      })

      // split at the ## headings: docs list them under "On this page", the FAQ shows one per question
      const intro: RootContent[] = []
      const sections: { title: string; id: string; nodes: RootContent[] }[] = []
      for (const node of tree.children) {
        if (isH2(node)) sections.push({ title: text(node).trim(), id: String(node.properties.id ?? ''), nodes: [] })
        else (sections.at(-1)?.nodes ?? intro).push(node)
      }

      // HTML as a JS expression, with the bundled image URLs spliced in
      const js = (html: string) =>
        html
          .split(/\u0000(\d+)\u0000/)
          .map((part, i) => (i % 2 ? `__img${part}` : JSON.stringify(part)))
          .join(' + ')

      return [
        ...imports.map((p, i) => `import __img${i} from ${JSON.stringify(p)}`),
        `export const meta = ${JSON.stringify(meta)}`,
        `export const html = ${js(toHtml.stringify(tree))}`,
        `export const intro = ${js(stringify(intro))}`,
        `export const sections = [${sections
          .map((s) => `{ title: ${JSON.stringify(s.title)}, id: ${JSON.stringify(s.id)}, html: ${js(stringify(s.nodes))} }`)
          .join(', ')}]`,
        `export default { meta, html, intro, sections }`,
      ].join('\n')
    },
  }
}
