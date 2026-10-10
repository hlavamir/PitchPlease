import { useEffect, useRef } from 'react'
import { createShader, PRECISION, prefersReducedMotion, SIMPLEX3D } from '../gl/gl'

// The app's four mask presets on a grid of pixels, as on the General page's scene preview. The maths
// follows the engine (engine/masks.py); a steady beat stands in for the music.

export const PRESETS = [
  { key: 'A', name: 'Gradient', text: 'A soft fade across the room, vertical or horizontal.' },
  { key: 'B', name: 'Back & Forth', text: 'A wide band that sweeps from side to side.' },
  { key: 'C', name: 'Rotating Line', text: 'A line turning around the centre of the rig.' },
  { key: 'D', name: 'Noise', text: 'Drifting clouds that jump to a new place on every peak.' },
] as const

const COLS = 24
const ROWS = 15
const BPM = 124

const FRAGMENT = `${PRECISION}
uniform vec2 uRes;
uniform float uTime;
uniform float uBeat;   // 0 on the beat → 1 just before the next one
uniform float uJump;   // noise time offset, changes on every 4th beat
uniform int uPreset;
${SIMPLEX3D}
const float PI = 3.14159265;

float band(vec2 uv, float turns, float offset, float halfWidth, float falloff) {
  float a = turns * 2.0 * PI;
  vec2 n = vec2(-sin(a), cos(a));
  float d = dot(uv - 0.5, n) - offset;
  return 1.0 - smoothstep(0.0, 1.0, (abs(d) - halfWidth) / falloff);
}

float mask(vec2 uv) {
  float t = uTime;
  if (uPreset == 0) return uv.y;
  if (uPreset == 1) return band(uv, 0.25, 0.25 * sin(2.0 * PI * (0.1 * t + 0.75)), 1.0 / 6.0, 0.12);
  if (uPreset == 2) return band(uv, 0.1 * t + 0.25, 0.0, 0.25, 0.12);
  float n = (snoise(vec3(uv * 1.6, (t + uJump) * 0.2)) + 1.0) * 0.5;
  return clamp((n - 0.15 - 0.1665) / 0.667, 0.0, 1.0);
}

void main() {
  vec2 p = gl_FragCoord.xy / uRes;
  p.y = 1.0 - p.y;                       // v down, as in the engine
  vec2 grid = vec2(${COLS}.0, ${ROWS}.0);
  vec2 cell = floor(p * grid);
  vec2 f = fract(p * grid);
  vec2 uv = (cell + 0.5) / grid;
  float m = mask(uv);
  // idle level that the beat pushes up and that decays again (the app's phase, simplified)
  float level = 0.45 + 0.4 * exp(-uBeat * 4.0);
  vec2 e = min(f, 1.0 - f) * vec2(uRes / grid);   // distance to the cell edge in px
  float led = step(1.0, min(e.x, e.y));
  vec3 amber = vec3(233.0, 196.0, 106.0) / 255.0;
  vec3 off = vec3(24.0, 25.0, 27.0) / 255.0;
  vec3 ground = vec3(15.0, 16.0, 17.0) / 255.0;
  vec3 c = mix(off, amber, m * level);
  gl_FragColor = vec4(mix(ground, c, led), 1.0);
}
`

export default function MaskPreview({ preset }: { preset: number }) {
  const ref = useRef<HTMLCanvasElement>(null)

  useEffect(() => {
    const canvas = ref.current
    if (!canvas) return
    const shader = createShader(canvas, FRAGMENT)
    if (!shader) return
    const { gl, uniform, draw } = shader
    const reduced = prefersReducedMotion()
    gl.uniform1i(uniform('uPreset'), preset)

    const resize = () => {
      const dpr = Math.min(window.devicePixelRatio || 1, 2)
      canvas.width = Math.round(canvas.clientWidth * dpr)
      canvas.height = Math.round(canvas.clientHeight * dpr)
      gl.uniform2f(uniform('uRes'), canvas.width, canvas.height)
    }
    const frame = (now: number) => {
      const s = reduced ? 6 : now / 1000
      const beats = (s * BPM) / 60
      gl.uniform1f(uniform('uTime'), s * 2)
      gl.uniform1f(uniform('uBeat'), reduced ? 1 : beats % 1)
      gl.uniform1f(uniform('uJump'), (Math.floor(beats / 4) * 17.31) % 64)
      draw()
    }

    let raf = 0
    let visible = false
    const loop = (now: number) => {
      frame(now)
      raf = requestAnimationFrame(loop)
    }
    const update = () => {
      cancelAnimationFrame(raf)
      if (reduced) frame(0)
      else if (visible && !document.hidden) raf = requestAnimationFrame(loop)
    }
    const io = new IntersectionObserver(([entry]) => {
      visible = entry.isIntersecting
      update()
    })
    const ro = new ResizeObserver(() => {
      resize()
      frame(performance.now())
    })
    resize()
    frame(performance.now())
    io.observe(canvas)
    ro.observe(canvas)
    document.addEventListener('visibilitychange', update)
    return () => {
      cancelAnimationFrame(raf)
      io.disconnect()
      ro.disconnect()
      document.removeEventListener('visibilitychange', update)
      shader.dispose()
    }
  }, [preset])

  return <canvas ref={ref} aria-hidden className="block aspect-[24/15] w-full bg-ground" />
}
