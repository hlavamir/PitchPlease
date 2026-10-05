interface Props {
  bands: number[]
  peaks?: number[]
  weights?: number[]
  height?: number
}

/** Bar meter of the 32 audio bands; peaking bands are highlighted, trigger weights drawn as a line. */
export function BandMeter({ bands, peaks, weights, height = 80 }: Props) {
  const n = bands.length || 1
  return (
    <svg viewBox={`0 0 ${n * 10} ${height}`} className="w-full rounded bg-panel-2" style={{ height }} preserveAspectRatio="none">
      {bands.map((v, i) => {
        const h = Math.max(0, Math.min(1, v)) * (height - 4)
        return (
          <rect
            key={i}
            x={i * 10 + 1}
            y={height - h}
            width={8}
            height={h}
            fill={peaks?.[i] ? 'var(--color-accent)' : '#5b5f6b'}
          />
        )
      })}
      {weights && (
        <polyline
          fill="none"
          stroke="#7dd3fc"
          strokeWidth={1.5}
          vectorEffect="non-scaling-stroke"
          points={weights.map((w, i) => `${i * 10 + 5},${height - w * (height - 4)}`).join(' ')}
        />
      )}
    </svg>
  )
}
