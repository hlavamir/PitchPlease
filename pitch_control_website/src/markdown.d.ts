// Markdown files, rendered at build time by plugins/markdown.ts.
declare module '*.md' {
  const doc: import('./markdown-types').MarkdownModule
  export default doc
}
