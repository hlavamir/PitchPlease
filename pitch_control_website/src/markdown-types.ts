// What a Markdown import gives (plugins/markdown.ts).

export interface MarkdownSection {
  title: string // the ## heading, as text
  id: string // its anchor id
  html: string // everything up to the next ## heading
}

export interface MarkdownModule {
  meta: Record<string, string> // the frontmatter
  html: string // the whole page
  intro: string // everything before the first ## heading
  sections: MarkdownSection[]
}
