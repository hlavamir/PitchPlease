// Renders every page to static HTML: dist/index.html, dist/download/index.html, … and dist/404.html.
// Runs after the client build (dist/) and the server build (dist-ssr/).

import { mkdir, readFile, rm, writeFile } from 'node:fs/promises'
import { dirname, join } from 'node:path'
import { fileURLToPath, pathToFileURL } from 'node:url'

const root = join(dirname(fileURLToPath(import.meta.url)), '..')
const dist = join(root, 'dist')
const ssr = join(root, 'dist-ssr')

const template = await readFile(join(dist, 'index.html'), 'utf8')
const { render, PATHS } = await import(pathToFileURL(join(ssr, 'entry-server.js')).href)

for (const path of PATHS) {
  const { html, head } = render(path)
  const page = template.replace('<!--app-head-->', head).replace('<!--app-html-->', html)
  const file = path === '/' ? join(dist, 'index.html') : path === '/404' ? join(dist, '404.html') : join(dist, path, 'index.html')
  await mkdir(dirname(file), { recursive: true })
  await writeFile(file, page)
  console.log('prerendered', path)
}

await rm(ssr, { recursive: true, force: true })
