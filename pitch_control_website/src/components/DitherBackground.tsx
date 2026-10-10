import { useEffect, useRef } from 'react'
import { createShader, PRECISION, prefersReducedMotion, SIMPLEX3D } from '../gl/gl'

// Size of one dither dot in CSS px: the canvas renders at 1/PX resolution and is scaled up without
// smoothing, so the ordered dither reads as a coarse, printed texture.
const PX = 3
const FPS = 30
// how much of the page scroll the noise follows (parallax)
const PARALLAX = 0.25
// the page content column (Container), under which the pattern stays calm so text reads well
const CONTENT_WIDTH = 1240

const FRAGMENT = `${PRECISION}
uniform vec2 uRes;
uniform float uTime;
uniform float uScroll;
uniform float uHalf;   // half the content column width, in canvas px
${SIMPLEX3D}
float bayer2(vec2 a) { a = floor(a); return fract(a.x / 2.0 + a.y * a.y * 0.75); }
float bayer4(vec2 a) { return bayer2(0.5 * a) * 0.25 + bayer2(a); }
float bayer8(vec2 a) { return bayer4(0.5 * a) * 0.25 + bayer2(a); }

void main() {
  vec2 px = gl_FragCoord.xy;
  vec2 uv = vec2(px.x, px.y - uScroll) / uRes.y;
  float n = snoise(vec3(uv * 1.1, uTime * 0.035));
  n += 0.45 * snoise(vec3(uv * 2.6 + 11.3, uTime * 0.055));
  n = n / 1.45 * 0.5 + 0.5;
  // remap like the app's noise preset (brightness / contrast), so there are calm, empty areas
  n = clamp((n - 0.36) / 0.5, 0.0, 1.0);
  // brighter towards the top of the window, where the hero sits
  float top = gl_FragCoord.y / uRes.y;
  // calm under the content column, full strength in the margins beside it
  float side = smoothstep(uHalf - 8.0, uHalf + 40.0, abs(px.x - uRes.x * 0.5));
  float level = n * mix(0.4, 0.8, top) * mix(0.18, 1.0, side);
  float on = step(bayer8(px), level);
  vec3 dark = vec3(15.0, 16.0, 17.0) / 255.0;
  vec3 light = vec3(33.0, 34.0, 38.0) / 255.0;
  gl_FragColor = vec4(mix(dark, light, on), 1.0);
}
`

/** The page background: the noise preset as a slow, two-tone ordered dither. */
export default function DitherBackground() {
  const ref = useRef<HTMLCanvasElement>(null)

  useEffect(() => {
    const canvas = ref.current
    if (!canvas) return
    const shader = createShader(canvas, FRAGMENT)
    if (!shader) return
    const { gl, uniform, draw } = shader
    const reduced = prefersReducedMotion()
    const t0 = performance.now() - 40_000 * Math.random()

    const resize = () => {
      canvas.width = Math.ceil(window.innerWidth / PX)
      canvas.height = Math.ceil(window.innerHeight / PX)
      gl.uniform2f(uniform('uRes'), canvas.width, canvas.height)
      gl.uniform1f(uniform('uHalf'), Math.min(window.innerWidth, CONTENT_WIDTH) / 2 / PX)
    }
    const frame = (now: number) => {
      gl.uniform1f(uniform('uTime'), reduced ? 0 : (now - t0) / 1000)
      gl.uniform1f(uniform('uScroll'), reduced ? 0 : (window.scrollY * PARALLAX) / PX)
      draw()
    }

    let raf = 0
    let last = 0
    const loop = (now: number) => {
      raf = requestAnimationFrame(loop)
      if (now - last < 1000 / FPS - 2) return
      last = now
      frame(now)
    }
    const start = () => {
      cancelAnimationFrame(raf)
      if (reduced) frame(performance.now())
      else raf = requestAnimationFrame(loop)
    }
    const onVisibility = () => (document.hidden ? cancelAnimationFrame(raf) : start())
    const onResize = () => {
      resize()
      frame(performance.now())
    }

    resize()
    start()
    canvas.style.opacity = '1'
    window.addEventListener('resize', onResize)
    document.addEventListener('visibilitychange', onVisibility)
    return () => {
      cancelAnimationFrame(raf)
      window.removeEventListener('resize', onResize)
      document.removeEventListener('visibilitychange', onVisibility)
      shader.dispose()
    }
  }, [])

  return (
    <canvas
      ref={ref}
      aria-hidden
      className="pointer-events-none fixed inset-0 -z-10 h-full w-full opacity-0 transition-opacity duration-1000"
      style={{ imageRendering: 'pixelated' }}
    />
  )
}
