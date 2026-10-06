import { createContext, useCallback, useContext, useEffect, useRef, useState } from 'react'

/**
 * Keyboard navigation over a page's controls, like a hardware device: one item is always selected.
 *   W / S   move up / down a row        A / D   move left / right
 *   ↑ / ↓   change the selected value (Shift = fine)
 *   ⏎       press (Shift+⏎ = alternate, e.g. save a scene)       Esc   cancel (pending colour)
 */
export interface NavItem {
  id: string
  label: string
  value?: string // shown in the footer
  adjust?: (direction: 1 | -1, fine: boolean) => void
  press?: (down: boolean, shift: boolean) => void
  cancel?: () => void
}

export type NavGrid = (NavItem | null)[][]

/** Something is being typed: keys belong to the field, not to navigation. */
export function isTyping(e: KeyboardEvent): boolean {
  const t = e.target as HTMLElement | null
  if (!t) return false
  const tag = t.tagName
  return tag === 'INPUT' || tag === 'SELECT' || tag === 'TEXTAREA' || t.isContentEditable
}

// remember the selection per page while switching pages
const remembered = new Map<string, { r: number; c: number }>()

export function useGridNav(page: string, grid: NavGrid) {
  const [pos, setPos] = useState(() => remembered.get(page) ?? { r: 0, c: 0 })
  const gridRef = useRef(grid)
  gridRef.current = grid
  const posRef = useRef(pos)
  posRef.current = pos

  useEffect(() => {
    remembered.set(page, pos)
  }, [page, pos])

  const at = (g: NavGrid, r: number, c: number) => g[r]?.[c] ?? null

  // nearest item in a row to a column (rows can have empty slots)
  const nearestInRow = (g: NavGrid, r: number, c: number) => {
    const row = g[r] ?? []
    for (let d = 0; d < row.length; d++) {
      if (row[c - d]) return c - d
      if (row[c + d]) return c + d
    }
    return -1
  }

  useEffect(() => {
    const down = (e: KeyboardEvent) => {
      if (isTyping(e) || e.metaKey || e.ctrlKey || e.altKey) return
      const g = gridRef.current
      const { r, c } = posRef.current
      const item = at(g, r, c)
      const key = e.key.length === 1 ? e.key.toLowerCase() : e.key
      const move = (nr: number, nc: number) => {
        e.preventDefault()
        setPos({ r: nr, c: nc })
      }
      if (key === 'w' || key === 's') {
        const step = key === 'w' ? -1 : 1
        for (let nr = r + step; nr >= 0 && nr < g.length; nr += step) {
          const nc = nearestInRow(g, nr, c)
          if (nc >= 0) return move(nr, nc)
        }
        return
      }
      if (key === 'a' || key === 'd') {
        const step = key === 'a' ? -1 : 1
        for (let nc = c + step; nc >= 0 && nc < (g[r]?.length ?? 0); nc += step) {
          if (at(g, r, nc)) return move(r, nc)
        }
        return
      }
      if ((key === 'ArrowUp' || key === 'ArrowDown') && item?.adjust) {
        e.preventDefault()
        item.adjust(key === 'ArrowUp' ? 1 : -1, e.shiftKey)
        return
      }
      if (key === 'Enter' && item?.press) {
        e.preventDefault()
        if (!e.repeat) item.press(true, e.shiftKey)
        return
      }
      if (key === 'Escape' && item?.cancel) {
        e.preventDefault()
        item.cancel()
      }
    }
    const up = (e: KeyboardEvent) => {
      if (e.key !== 'Enter' || isTyping(e)) return
      const { r, c } = posRef.current
      at(gridRef.current, r, c)?.press?.(false, e.shiftKey)
    }
    window.addEventListener('keydown', down)
    window.addEventListener('keyup', up)
    return () => {
      window.removeEventListener('keydown', down)
      window.removeEventListener('keyup', up)
    }
  }, [])

  // keep the selection on an existing item when the grid changes
  let { r, c } = pos
  if (!at(grid, r, c)) {
    r = Math.min(r, Math.max(0, grid.length - 1))
    const nc = nearestInRow(grid, r, c)
    c = nc >= 0 ? nc : 0
  }
  const selected = at(grid, r, c)

  const select = useCallback((id: string) => {
    const g = gridRef.current
    for (let rr = 0; rr < g.length; rr++) {
      const cc = g[rr].findIndex((it) => it?.id === id)
      if (cc >= 0) return setPos({ r: rr, c: cc })
    }
  }, [])

  // report the selection to the footer
  const setFooter = useContext(SelectionContext)
  useEffect(() => {
    setFooter(selected ? { label: selected.label, value: selected.value } : null)
  }, [selected?.label, selected?.value, setFooter])
  useEffect(() => () => setFooter(null), [setFooter])

  return { selectedId: selected?.id ?? null, select }
}

export interface FooterSelection {
  label: string
  value?: string
}

export const SelectionContext = createContext<(sel: FooterSelection | null) => void>(() => undefined)
