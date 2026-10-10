import type { MouseEvent } from 'react'
import { useNavigate } from 'react-router'

/**
 * Shows content Markdown that plugins/markdown.ts rendered to HTML at build time. Links within the
 * site (`/support`, or relative ones like `audio-and-midi`) navigate without reloading the page.
 */
export default function Markdown({ html, className = '' }: { html: string; className?: string }) {
  const navigate = useNavigate()
  const onClick = (e: MouseEvent) => {
    const a = (e.target as HTMLElement).closest('a')
    if (!a || a.target || e.defaultPrevented || e.button !== 0 || e.metaKey || e.ctrlKey || e.shiftKey || e.altKey) return
    const url = new URL(a.href) // resolved against the current page
    if (url.origin !== window.location.origin) return
    e.preventDefault()
    navigate(url.pathname + url.hash)
  }
  return <div className={`prose ${className}`} onClick={onClick} dangerouslySetInnerHTML={{ __html: html }} />
}
