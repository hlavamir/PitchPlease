---
date_created: 2026-07-09
date_modified: 2026-07-10
---

# PitchPlease Wiki — Schema

> Note: this file (`wiki/CLAUDE.md`) is the schema root. All wiki activity lives under `wiki/`.

This is the schema file for the PitchPlease project wiki. It defines conventions, structure, and workflows for maintaining this wiki. The LLM reads this file at the start of every session to understand how the wiki works.

## Purpose

The wiki is a persistent, LLM-maintained knowledge base for the PitchPlease project. It captures hardware details, firmware architecture, software patches, design decisions, and open questions. It grows incrementally as the project evolves.

## Directory Structure

```
PitchPlease/
├── wiki/                    ← everything wiki-related lives here
│   ├── CLAUDE.md            ← this file (schema/config)
│   ├── images/              ← screenshots and photos referenced by wiki pages
│   ├── raw/                 ← explicitly ingested source material (immutable)
│   │   └── [docs, chats, articles, data added on request]
│   └── wiki/                ← LLM-generated knowledge pages
│       ├── index.md         ← catalog of all pages with one-line summaries
│       ├── log.md           ← append-only chronological activity log
│       ├── overview.md      ← high-level project description
│       └── [topic pages...]
└── [existing repo code — not touched by wiki operations]
```

**`wiki/images/`** holds screenshots, photos, and diagrams referenced by wiki pages. Reference images from wiki pages using relative paths: `../images/filename.png`.

**`wiki/raw/`** holds only files and content that have been explicitly ingested (by instruction). This includes documents, exported chat transcripts, articles, data files, or any other source material. The LLM reads from here but never modifies these files.

**`wiki/wiki/`** holds all LLM-generated pages. The LLM creates and edits files here freely.

## Page Format

Every wiki page must begin with YAML frontmatter, followed by the page body:

```markdown
---
date_created: YYYY-MM-DD
date_modified: YYYY-MM-DD
---

# Page Title

> One-line summary (used in index.md)

[Body — prose, sections, cross-links]

## Open Questions
- [unanswered questions about this topic]

## See Also
- [[related-page]] — why it's related
```

Use `[[page-name]]` syntax for internal wiki links (Obsidian-compatible). File names are lowercase hyphenated, no spaces.

Files placed in `wiki/raw/` must also carry a frontmatter block with `date_created` and `date_modified`.

## Operations

### Ingest
When new information arrives (code change, conversation, external source):
1. Read the source material
2. Discuss key takeaways if needed
3. Update the relevant wiki page(s) — create new pages if warranted
4. Update `index.md` if a new page was created
5. Append an entry to `log.md`

A single ingest may touch multiple pages.

### Query
When answering a question about the project:
1. Read `index.md` to find relevant pages
2. Read those pages
3. Synthesize an answer with citations to wiki pages
4. If the answer reveals new knowledge worth keeping, file it back into the wiki

### Lint
Periodically check wiki health:
- Broken `[[links]]` (page doesn't exist)
- Orphan pages (nothing links to them)
- Open Questions that could now be answered
- Contradictions between pages
- Important topics mentioned but lacking their own page

## Conventions

- Dates: ISO 8601 (`2026-07-09`)
- Log entries: `## [YYYY-MM-DD] <operation> | <title>` so they're grep-parseable
- Keep pages focused — split if a page exceeds ~200 lines
- Prefer prose over bullet lists for body content
- Always update `index.md` when adding a page
- Always append to `log.md` after any write operation

## Metadata Rule

Every file in `wiki/wiki/` and `wiki/raw/` must have `date_created` and `date_modified` in its YAML frontmatter. When any file is modified, `date_modified` must be updated to today's date. `date_created` is set once at creation and never changed.

## Conflict Resolution Rule

If two records contain conflicting information, the one with the newer `date_modified` takes priority. The older record should be explicitly marked as outdated in the wiki (e.g., with a note in the relevant page body or Open Questions section) rather than silently overwritten, so there is a clear audit trail.

## Ask, Don't Assume Rule

If anything is unclear — about the project, the intended meaning of a source, or what action to take — stop and ask before proceeding. Do not fill in gaps with assumptions. An unanswered question should be recorded in the relevant page's "Open Questions" section and surfaced in the next conversation.

## Grill Me Rule

Don't compliment Miro or soften feedback. If something looks wrong, inconsistent, fragile, or like a questionable decision, say so directly. Criticism is welcome and expected.
