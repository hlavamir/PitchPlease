import { useEffect, useRef } from 'react'
import type { EngineState } from '../api'
import { PREVIEW_SIZE } from '../useEngine'

interface Props {
  preview: Uint8Array | null
  state: EngineState | null
  showFixtures?: boolean
  highlight?: string | null
  className?: string
}

/** The square 2D scene (grayscale mask) with every fixture pixel drawn in its output colour. */
export function Preview({ preview, state, showFixtures = true, highlight, className }: Props) {
  const canvasRef = useRef<HTMLCanvasElement>(null)
  const offscreen = useRef<HTMLCanvasElement | null>(null)

  useEffect(() => {
    const canvas = canvasRef.current
    if (!canvas) return
    const ctx = canvas.getContext('2d')
    if (!ctx) return
    const size = canvas.width

    ctx.fillStyle = '#000'
    ctx.fillRect(0, 0, size, size)
    if (preview && preview.length === PREVIEW_SIZE * PREVIEW_SIZE) {
      if (!offscreen.current) {
        offscreen.current = document.createElement('canvas')
        offscreen.current.width = PREVIEW_SIZE
        offscreen.current.height = PREVIEW_SIZE
      }
      const octx = offscreen.current.getContext('2d')!
      const img = octx.createImageData(PREVIEW_SIZE, PREVIEW_SIZE)
      for (let i = 0; i < preview.length; i++) {
        const v = preview[i]
        img.data[i * 4] = v
        img.data[i * 4 + 1] = v
        img.data[i * 4 + 2] = v
        img.data[i * 4 + 3] = 255
      }
      octx.putImageData(img, 0, 0)
      ctx.imageSmoothingEnabled = true
      ctx.globalAlpha = 0.55
      ctx.drawImage(offscreen.current, 0, 0, size, size)
      ctx.globalAlpha = 1
    }

    if (showFixtures && state) {
      for (const fx of state.fixtures) {
        const focused = highlight === fx.name
        fx.uv.forEach(([u, v], i) => {
          const [r, g, b] = fx.rgb[i] ?? [0, 0, 0]
          const x = u * size
          const y = v * size
          const multi = fx.uv.length > 1
          const first = multi && i === 0 // the first pixel shows the direction of the fixture
          const radius = multi ? (first ? 5.5 : 4) : 7
          ctx.beginPath()
          ctx.arc(x, y, radius, 0, Math.PI * 2)
          ctx.fillStyle = `rgb(${r},${g},${b})`
          ctx.fill()
          ctx.lineWidth = (focused ? 2.5 : 1) * (first ? 2.5 : 1)
          ctx.strokeStyle = focused ? '#fff' : fx.group === 'A' ? '#f08c2e' : '#9b6cf0'
          ctx.stroke()
        })
      }
    }
  }, [preview, state, showFixtures, highlight])

  return (
    <canvas
      ref={canvasRef}
      width={512}
      height={512}
      className={`aspect-square w-full rounded border border-edge bg-black ${className ?? ''}`}
    />
  )
}
