import { useLayoutEffect, useRef, useState } from 'react'

/**
 * Width of an element in CSS px (scaled px under the UI scale). Used instead of container queries,
 * which WebKit evaluates in unscaled px and Chromium in scaled px when CSS zoom is set.
 */
export function useElementWidth<T extends HTMLElement>() {
  const ref = useRef<T>(null)
  const [width, setWidth] = useState(0)
  useLayoutEffect(() => {
    const el = ref.current
    if (!el) return
    const measure = () => setWidth(el.offsetWidth)
    const ro = new ResizeObserver(measure)
    ro.observe(el)
    measure()
    return () => ro.disconnect()
  }, [])
  return [ref, width] as const
}
