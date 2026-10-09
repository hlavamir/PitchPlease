const SEAM = 'inset 0 1px 0 rgba(15,16,17,.6)'

interface Props {
  bands: number[]
  peaks?: number[]
  weights?: number[] // strobo trigger weight per band, drawn as a dotted mark
  rows?: number
  height?: number | string
  tip?: string
}

/**
 * Segmented meter of the audio bands: cells without gaps that fade in with the level; the top cell
 * of a peaking band is bright and glows.
 */
export function BandMeter({ bands, peaks, weights, rows = 12, height = 80, tip }: Props) {
  return (
    <div className="grid w-full gap-px" data-hint="info" data-tip={tip} style={{ height, gridTemplateColumns: `repeat(${bands.length || 1}, minmax(0, 1fr))` }}>
      {bands.map((v, i) => {
        const level = Math.max(0, Math.min(1, v)) * rows
        const top = Math.ceil(level) - 1
        const peak = Boolean(peaks?.[i])
        const weightRow = weights ? Math.round(weights[i] * (rows - 1)) : -1
        return (
          <div key={i} className="flex flex-col-reverse">
            {Array.from({ length: rows }, (_, c) => {
              const fill = Math.max(0, Math.min(1, level - c))
              const bright = peak && c === top
              const alpha = bright ? 0.06 + 0.94 * fill : 0.06 + 0.55 * fill
              return (
                <div
                  key={c}
                  className="relative flex-1"
                  style={{
                    background: `rgb(var(--ink-rgb) / ${alpha.toFixed(3)})`,
                    boxShadow: SEAM + (bright ? ', 0 0 calc(8px * var(--glow)) rgb(var(--ink-rgb) / calc(0.45 * var(--glow)))' : ''),
                    zIndex: bright ? 1 : undefined,
                    borderTop: fill === 0 && c === weightRow ? '1px dotted var(--color-dim)' : undefined,
                    transition: 'background-color 80ms linear',
                  }}
                />
              )
            })}
          </div>
        )
      })}
    </div>
  )
}

/** One-row segmented bar (phase, settings sliders): cells fade in with the value. */
export function SegmentBar({ value, cells = 32, height = 8, gap = 2, tip }: { value: number; cells?: number; height?: number; gap?: number; tip?: string }) {
  const level = Math.max(0, Math.min(1, value)) * cells
  return (
    <div className="grid flex-1" data-hint="info" data-tip={tip} style={{ gridTemplateColumns: `repeat(${cells}, minmax(0, 1fr))`, gap, height }}>
      {Array.from({ length: cells }, (_, i) => {
        const fill = Math.max(0, Math.min(1, level - i))
        return <div key={i} style={{ background: `rgb(var(--ink-rgb) / ${(0.06 + 0.94 * fill).toFixed(3)})` }} />
      })}
    </div>
  )
}
