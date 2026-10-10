# PitchControl! website

The product site for PitchControl: Home, Download, Docs and Support. Vite + React + TypeScript +
Tailwind, prerendered to static HTML, so any static host works (no server code).

```bash
npm install
npm run dev       # http://localhost:5173
npm run build     # → dist/, one index.html per page plus 404.html
npm run preview   # serves dist/
```

## Where things come from

| What | Source |
|---|---|
| Version, date and release notes (Download page, footer) | `../pitch_control/CHANGELOG.md`, read at build time. "Unreleased" and versions marked "(not released)" are left out. |
| Screenshots | `../pitch_control/screenshots/*.png`, bundled at build time. Retake them in the app and rebuild. |
| Docs pages | `src/content/docs/*.md`: one page per file, the file name is the URL (`/docs/<name>`). |
| Support FAQ | `src/content/support.md`: every `##` heading is one question. |
| Links (GitHub, Ko-fi) | `src/site.ts` |

The Download buttons open the latest GitHub release (`/releases/latest`), so a new release needs no
change here; rebuilding picks up the new version from the changelog.

## Writing docs

Each Markdown file starts with frontmatter:

```markdown
---
title: Getting started
description: One sentence, shown under the title and as the meta description.
order: 1
---
```

- No `#` heading (the title comes from the frontmatter); `##` sections show in "On this page".
- `![General page](general.png)`: a bare file name is looked up next to the file, then in the app's
  screenshots folder.
- Links: other docs by file name (`(audio-and-midi)`), the support page as `../support`. They are made
  absolute at build time.
- Keys as `<kbd>Shift</kbd>`, notes as a blockquote starting with `**Note:**` or `**Tip:**`.

Markdown is rendered to HTML at build time (`plugins/markdown.ts`), so the browser doesn't load a Markdown parser.

## Design

The app's theme, made quieter: the same ground and panel colours, Chakra Petch and Share Tech Mono,
uppercase labels and numbered section headers (`01 / How it works`). Text is grey; amber is used for
actions, the active page and the screenshots, so the screenshots stand out.

- `src/components/DitherBackground.tsx`: the page background, the app's Noise preset (3D simplex
  noise) drawn at 1/3 resolution as a two-tone 8 × 8 ordered dither. 30 FPS, follows the scroll
  slightly, pauses in hidden tabs, a still frame with "reduce motion".
- `src/components/MaskPreview.tsx`: the four mask presets live on a pixel grid, with the maths from
  the engine's `masks.py` and a steady 124 BPM pulse standing in for the music.

Keys 1–4 switch pages, as 1–9 do in the app.
