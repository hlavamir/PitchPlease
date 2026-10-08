import { useEffect, useState } from 'react'
import { api, rgbCss, type MacroDef } from '../api'
import { BandMeter, SegmentBar } from '../components/BandMeter'
import { MacroControl, colorTrackFor } from '../components/MacroControl'
import { Preview } from '../components/Preview'
import { Section } from '../components/forms'
import { useMacroNav } from '../macroNav'
import type { EngineConnection } from '../useEngine'
import { useGridNav, type NavGrid, type NavItem } from '../useGridNav'

// same order as the LCXL3: knob row 3, then the faders
const FADERS = [
  'Strobo Decay',
  'Idle Attack',
  'Shader Speed',
  'Shader Param',
  'Hue A',
  'Saturation A',
  'Hue B',
  'Saturation B',
  'Audio Reactivity',
  'Strobo',
  'Strobo Brightness',
  'Idle Brightness',
  'Strobo Bright. A',
  'Idle Bright. A',
  'Strobo Bright. B',
  'Idle Bright. B',
]
// short labels keep the 8-column grid readable on a 14" screen
const SHORT: Record<string, string> = {
  'Audio Reactivity': 'Audio react.',
  'Strobo Brightness': 'Strobo br.',
  'Idle Brightness': 'Idle br.',
  'Strobo Bright. A': 'Strobo br. A',
  'Idle Bright. A': 'Idle br. A',
  'Strobo Bright. B': 'Strobo br. B',
  'Idle Bright. B': 'Idle br. B',
  'Saturation A': 'Sat. A',
  'Saturation B': 'Sat. B',
}
const BUTTONS: [string, string, string][] = [
  ['Manual Strobo', 'HOLD', 'Man. strobo'],
  ['Fog Machine', 'HOLD', 'Fog'],
  ['Invert Discoball', 'TGL', 'Invert disco'],
  ['Vertical Symmetry', 'TGL', 'V. symmetry'],
  ['Auto Color Change', 'TGL', 'Auto color'],
  ['Swap Colors', 'TGL', 'Swap colors'],
]
const PRESETS: [string, string, string][] = [
  ['Preset A', 'Gradient', 'A'],
  ['Preset B', 'Back & Forth', 'B'],
  ['Preset C', 'Rotating Line', 'C'],
  ['Preset D', 'Noise', 'D'],
]

const pad8 = <T,>(items: T[]): (T | null)[] => [...items, ...Array<null>(Math.max(0, 8 - items.length)).fill(null)]

interface SceneInfo {
  index: number
  name: string | null
  exists: boolean
}

/** Output colour as shown next to the group swatch: hue in degrees (−180…180), saturation in %. */
function hsText(hsb: number[] | undefined): string {
  if (!hsb) return ''
  const deg = Math.round(((((hsb[0] + 0.5) % 1) + 1) % 1 - 0.5) * 360)
  return `H ${deg > 0 ? '+' : ''}${deg}°  S ${Math.round(hsb[1] * 100)}%`
}

export function General({ engine, defs }: { engine: EngineConnection; defs: Record<string, MacroDef> }) {
  const { state, preview, setMacro, toggleMacro } = engine
  const macros = state?.macros ?? {}
  const pending = state?.pending ?? {}
  const shown = { ...macros, ...pending } // hue/sat still moving: show where they are heading
  const [scenes, setScenes] = useState<SceneInfo[]>([])
  const [saveMode, setSaveMode] = useState(false)
  const [lastScene, setLastScene] = useState<number | null>(null)
  const { item } = useMacroNav(engine, defs)

  const loadScenes = () => api.get<SceneInfo[]>('/api/scenes').then(setScenes)
  useEffect(() => {
    loadScenes()
  }, [])

  const sceneAction = async (i: number, save: boolean) => {
    if (save) {
      await api.post(`/api/scenes/${i}/save`)
      setSaveMode(false)
      loadScenes()
    } else if (await api.post(`/api/scenes/${i}/load`).then(() => true, () => false)) {
      setLastScene(i)
    }
  }

  const sceneItems: NavItem[] = scenes.map((s) => ({
    id: `scene-${s.index}`,
    label: `Scene ${s.index + 1}`,
    value: s.name ?? 'empty',
    hint: 'scene',
    tip: s.exists ? `Scene ${s.index + 1}: ${s.name ?? ''}` : `Scene ${s.index + 1} is empty: Shift + ⏎ saves the current macros into it`,
    press: (down, shift) => down && sceneAction(s.index, shift || saveMode),
  }))

  const grid: NavGrid = [
    FADERS.slice(0, 8).map((n) => item(n)),
    FADERS.slice(8).map((n) => item(n)),
    pad8(BUTTONS.map(([n, , label]) => item(n, label))),
    pad8(PRESETS.map(([n, label]) => item(n, label))),
    pad8(sceneItems),
  ]
  const { selectedId, select } = useGridNav('General', grid)

  const fader = (name: string, i: number) =>
    defs[name] ? (
      <MacroControl
        key={name}
        def={{ ...defs[name], label: SHORT[name] ?? defs[name].label }}
        value={shown[name] ?? 0}
        applied={macros[name] ?? 0}
        setMacro={setMacro}
        toggleMacro={toggleMacro}
        colorTrack={colorTrackFor(name, shown, defs)}
        pending={name in pending}
        selected={selectedId === name}
        onSelect={() => select(name)}
        index={i + 1}
        className="h-full"
      />
    ) : null

  const empty = (n: number) => Array.from({ length: n }, (_, i) => <div key={`empty-${i}`} className="hatch h-10" />)

  // phase 0…0.5 = strobo decaying after a peak, 0.5…1 = idle fading in
  const inStrobo = (state?.phase ?? 1) < 0.5
  const phaseBar = inStrobo ? (state?.strobo ?? 0) : (state?.idle ?? 1)

  return (
    <div className="grid gap-1.5 wide:h-full wide:grid-cols-[minmax(0,1fr)_404px]">
      <div className="flex min-h-0 min-w-0 flex-col gap-1.5">
        <Section index="01" title="Macros" right="knob row 3 · faders — LCXL3" className="min-h-[24rem] flex-1" bodyClassName="p-0">
          <div className="grid h-full grid-cols-8 grid-rows-2 gap-px bg-edge">{FADERS.map(fader)}</div>
        </Section>

        <Section index="02" title="Functions · shader preset" right="button rows — LCXL3" bodyClassName="p-0">
          <div className="grid grid-cols-8 gap-px border-b border-edge bg-edge">
            {BUTTONS.map(([name, tag, label]) =>
              defs[name] ? (
                <MacroControl
                  key={name}
                  def={{ ...defs[name], label }}
                  value={macros[name] ?? 0}
                  setMacro={setMacro}
                  toggleMacro={toggleMacro}
                  tag={tag}
                  selected={selectedId === name}
                  onSelect={() => select(name)}
                />
              ) : null,
            )}
            {empty(8 - BUTTONS.length)}
          </div>
          <div className="grid grid-cols-8 gap-px bg-edge">
            {PRESETS.map(([name, label, tag]) =>
              defs[name] ? (
                <MacroControl
                  key={name}
                  def={{ ...defs[name], label }}
                  value={macros[name] ?? 0}
                  setMacro={setMacro}
                  toggleMacro={toggleMacro}
                  tag={tag}
                  selected={selectedId === name}
                  onSelect={() => select(name)}
                />
              ) : null,
            )}
            {empty(8 - PRESETS.length)}
          </div>
        </Section>

        <Section
          index="03"
          title="Scenes"
          bodyClassName="p-0"
          right={
            <>
              <span>{saveMode ? 'click a scene to save' : '⏎ load · shift + ⏎ save'}</span>
              <button className={`lbl h-[18px] px-2 text-[10px] ${saveMode ? 'glow-on bg-ink text-ground' : 'border border-edge text-ink'}`} onClick={() => setSaveMode(!saveMode)}>
                Save mode
              </button>
            </>
          }
        >
          <div className="grid grid-cols-8 gap-px bg-edge">
            {scenes.map((s) => {
              const id = `scene-${s.index}`
              return (
                <button
                  key={s.index}
                  data-hint="scene"
                  data-tip={s.exists ? `Scene ${s.index + 1}: ${s.name ?? ''}` : `Scene ${s.index + 1} is empty: Shift + ⏎ saves the current macros into it`}
                  onClick={() => {
                    select(id)
                    sceneAction(s.index, saveMode)
                  }}
                  className={`flex h-12 flex-col justify-center gap-0.5 px-2.5 text-left ${
                    saveMode ? 'glow-hover bg-panel-2' : 'glow-hover bg-panel'
                  } ${lastScene === s.index ? 'shadow-[inset_0_-2px_0_var(--color-ink)]' : ''} ${selectedId === id ? 'glow-sel' : ''} ${
                    s.exists ? 'text-ink' : 'text-dim'
                  }`}
                >
                  <span className="font-mono text-[18px] leading-none">{String(s.index + 1).padStart(2, '0')}</span>
                  <span className="lbl truncate text-[10px] opacity-70">{s.name ?? 'empty'}</span>
                </button>
              )
            })}
          </div>
        </Section>
      </div>

      {/* right column; in the single-column layout scene and audio share one row */}
      <div className="grid min-w-0 grid-cols-2 gap-1.5 wide:flex wide:min-h-0 wide:flex-col">
        <Section index="04" title="Scene" right={<span className="text-ink">{state?.preset}</span>} bodyClassName="p-2.5">
          <Preview preview={preview} state={state} />
          {/* one bar for both phases: strobo drains it from 1 to 0 after a peak, idle fills it back to 1 */}
          <div className="mt-2.5 flex items-center gap-2.5 text-[11px]">
            <span className={`lbl w-14 ${inStrobo ? 'text-glow' : 'text-dim'}`}>{inStrobo ? 'Strobo' : 'Idle'}</span>
            <SegmentBar value={phaseBar} />
            <span className="font-mono text-[13px]">{phaseBar.toFixed(2)}</span>
          </div>
          <div className="mt-2.5 grid grid-cols-2 gap-2.5">
            {(['A', 'B'] as const).map((g) => (
              <div key={g} className="flex items-center gap-2.5 border border-edge px-2 py-1.5">
                <span
                  className="size-[30px] flex-none"
                  style={{
                    background: state ? rgbCss(state.colors[g], 1) : '#000',
                    boxShadow: state ? `0 0 14px ${rgbCss(state.colors[g], 1)}` : undefined,
                  }}
                />
                <span className="flex flex-col gap-0.5">
                  <span className="lbl text-[11px]">
                    Group {g} <span className="text-dim">· out</span>
                  </span>
                  <span className="font-mono text-[12px] whitespace-pre text-dim">{hsText(state?.colors_hsb?.[g])}</span>
                </span>
              </div>
            ))}
          </div>
        </Section>

        <Section
          index="05"
          title="Audio"
          className="min-h-0 flex-1"
          bodyClassName="p-2.5 gap-2"
          right={
            <span className="font-mono text-[12px] text-ink">
              TRIG {(state?.trigger ?? 0).toFixed(2)} · {state?.peaks_total ?? 0} PEAKS
            </span>
          }
        >
          <div className="min-h-16 flex-1">
            <BandMeter bands={state?.bands ?? []} peaks={state?.band_peaks} height="100%" />
          </div>
          <div className="lbl flex justify-between font-mono text-[10px] text-dim">
            <span>35 Hz</span>
            <span>peaks map</span>
            <span>10 kHz</span>
          </div>
          <BandMeter bands={state?.peaks_map ?? []} rows={4} height={22} />
        </Section>
      </div>
    </div>
  )
}
