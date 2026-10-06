import { useEffect, useState } from 'react'
import { api, rgbCss, type MacroDef } from '../api'
import { BandMeter } from '../components/BandMeter'
import { MacroControl, colorTrackFor } from '../components/MacroControl'
import { Preview } from '../components/Preview'
import { Button, Section } from '../components/forms'
import type { EngineConnection } from '../useEngine'

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
const BUTTONS = ['Manual Strobo', 'Fog Machine', 'Invert Discoball', 'Vertical Symmetry', 'Auto Color Change', 'Swap Colors']
const PRESETS: [string, string][] = [
  ['Preset A', 'Gradient'],
  ['Preset B', 'Back & Forth'],
  ['Preset C', 'Rotating Line'],
  ['Preset D', 'Noise'],
]

function emptySlots(n: number) {
  return Array.from({ length: n }, (_, i) => <div key={`empty-${i}`} className="h-11 rounded border border-dashed border-edge" />)
}

interface SceneInfo {
  index: number
  name: string | null
  exists: boolean
}

export function General({ engine, defs }: { engine: EngineConnection; defs: Record<string, MacroDef> }) {
  const { state, preview, setMacro, toggleMacro } = engine
  const macros = state?.macros ?? {}
  const pending = state?.pending ?? {}
  const shown = { ...macros, ...pending } // MIDI knobs still moving: show where they are heading
  const [scenes, setScenes] = useState<SceneInfo[]>([])
  const [saveMode, setSaveMode] = useState(false)

  const loadScenes = () => api.get<SceneInfo[]>('/api/scenes').then(setScenes)
  useEffect(() => {
    loadScenes()
  }, [])

  const sceneClick = async (i: number) => {
    if (saveMode) {
      await api.post(`/api/scenes/${i}/save`)
      setSaveMode(false)
      loadScenes()
    } else {
      await api.post(`/api/scenes/${i}/load`).catch(() => undefined)
    }
  }

  const control = (name: string) =>
    defs[name] ? (
      <MacroControl
        key={name}
        def={defs[name]}
        value={shown[name] ?? 0}
        setMacro={setMacro}
        toggleMacro={toggleMacro}
        colorTrack={colorTrackFor(name, shown, defs)}
        pending={name in pending}
        className="h-full"
      />
    ) : null

  return (
    <div className="grid gap-3 xl:h-full xl:grid-cols-[minmax(0,1fr)_26rem]">
      <div className="flex min-h-0 min-w-0 flex-col gap-3">
        <Section title="Macros" className="min-h-[24rem] flex-1">
          <div className="grid h-full grid-cols-8 grid-rows-2 gap-2">{FADERS.map(control)}</div>
        </Section>
        <Section title="Functions · shader preset">
          {/* 8 columns like the LCXL3 button rows; empty slots keep the grid aligned */}
          <div className="grid grid-cols-8 gap-2">
            {BUTTONS.map(control)}
            {emptySlots(8 - BUTTONS.length)}
          </div>
          <div className="mt-2 grid grid-cols-8 gap-2">
            {PRESETS.map(([name, label]) =>
              defs[name] ? (
                <MacroControl
                  key={name}
                  def={{ ...defs[name], label }}
                  value={macros[name] ?? 0}
                  setMacro={setMacro}
                  toggleMacro={toggleMacro}
                />
              ) : null,
            )}
            {emptySlots(8 - PRESETS.length)}
          </div>
        </Section>
        <Section
          title="Scenes"
          right={
            <Button onClick={() => setSaveMode(!saveMode)} primary={saveMode}>
              {saveMode ? 'Click a scene to save…' : 'Save mode'}
            </Button>
          }
        >
          <div className="grid grid-cols-8 gap-2">
            {scenes.map((s) => (
              <button
                key={s.index}
                onClick={() => sceneClick(s.index)}
                className={`h-11 rounded text-sm leading-tight ${
                  saveMode ? 'bg-red-900/60 hover:bg-red-800' : s.exists ? 'bg-panel-2 hover:bg-edge' : 'bg-panel-2 text-neutral-600'
                }`}
              >
                <div className="font-medium">{s.index + 1}</div>
                <div className="truncate px-1 text-xs text-neutral-400">{s.name ?? 'empty'}</div>
              </button>
            ))}
          </div>
        </Section>
      </div>

      <div className="flex min-w-0 flex-col gap-3">
        <Section title="Scene" right={<span className="text-xs text-neutral-400">{state?.preset}</span>}>
          <Preview preview={preview} state={state} />
          <div className="mt-3 flex items-center gap-3 text-xs text-neutral-400">
            <span>Phase</span>
            <div className="h-2 flex-1 rounded bg-panel-2">
              <div className="h-2 rounded bg-accent" style={{ width: `${(state?.phase ?? 0) * 100}%` }} />
            </div>
            <span className="font-mono">{state?.peaks_total ?? 0} peaks</span>
          </div>
          <div className="mt-3 flex gap-3">
            {(['A', 'B'] as const).map((g) => (
              <div key={g} className="flex flex-1 items-center gap-2 rounded bg-panel-2 p-2 text-sm">
                <span
                  className="size-6 rounded"
                  style={{ background: state ? rgbCss(state.colors[g], 1) : '#000' }}
                />
                Group {g}
              </div>
            ))}
          </div>
        </Section>
        <Section title="Audio" right={<span className="font-mono text-xs text-neutral-400">trigger {(state?.trigger ?? 0).toFixed(2)}</span>}>
          <BandMeter bands={state?.bands ?? []} peaks={state?.band_peaks} />
          <div className="mt-2 text-xs text-neutral-500">Peaks map (what the mask brightness looks up)</div>
          <BandMeter bands={state?.peaks_map ?? []} height={40} />
        </Section>
      </div>
    </div>
  )
}
