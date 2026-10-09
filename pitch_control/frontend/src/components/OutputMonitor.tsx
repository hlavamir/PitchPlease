import { useState } from 'react'
import type { EngineState, FixtureState } from '../api'
import { useElementWidth } from '../useElementWidth'
import { Toggle } from './forms'

function channelRange(fx: FixtureState): string {
  if (fx.transport === 'pitchpls_v2') return 'v2 serial'
  const end = fx.address + Math.max(fx.output.length, 1) - 1
  return `U${fx.universe} · ${fx.address}–${end}`
}

const pad3 = (n: number) => String(n).padStart(3, '0')

/**
 * The channels one fixture writes: DMX channel number over its value, both 3 digits so nothing
 * shifts while values change, and a level bar under each cell. v2 serial strips have no DMX
 * channels: their cells are numbered by byte position.
 */
function ChannelTable({ fx }: { fx: FixtureState }) {
  const serial = fx.transport === 'pitchpls_v2'
  return (
    <div className="mt-1.5 grid grid-cols-[repeat(auto-fill,minmax(2.25rem,1fr))] gap-px border border-edge bg-edge">
      {fx.output.map((v, i) => (
        <div
          key={i}
          className="flex flex-col items-center bg-panel pt-0.5 pb-1 font-mono leading-tight"
          style={{ boxShadow: `inset 0 -2px 0 rgb(var(--ink-rgb) / ${(v / 255).toFixed(3)})` }}
          data-hint="info"
          data-tip={serial ? `Serial byte ${i + 1}: ${v}` : `Universe ${fx.universe}, DMX channel ${fx.address + i} (fixture channel ${i + 1}): value ${v}`}
        >
          <span className="text-[9px] text-dim">{pad3(serial ? i + 1 : fx.address + i)}</span>
          <span className={`text-[11px] ${v ? 'text-ink' : 'text-dim'}`}>{pad3(v)}</span>
        </div>
      ))}
    </div>
  )
}

/** Live view of what every fixture outputs: pixel colours and (optionally) the raw DMX / serial bytes. */
export function OutputMonitor({ state, only }: { state: EngineState | null; only?: string | string[] | null }) {
  const [showBytes, setShowBytes] = useState(false)
  const [ref, width] = useElementWidth<HTMLDivElement>()
  const row = width >= 648 // one line per fixture
  const fixtures = (state?.fixtures ?? []).filter((f) => !only || (Array.isArray(only) ? only.includes(f.name) : f.name === only))
  return (
    <div ref={ref} className="flex flex-col gap-2" data-tip="What every fixture sends right now, after the gamma: pixel colours; switch on 'show channel values' for the DMX numbers">
      <label className="flex cursor-pointer items-center gap-2 self-end text-[11px] text-dim" data-tip="Also show the raw channel values (DMX channel number over its value) of every fixture">
        <Toggle checked={showBytes} onChange={setShowBytes} />
        show channel values
      </label>
      {fixtures.map((fx) => (
        <div key={fx.name} className="bg-panel-2 px-2 py-1.5" data-hint="info" data-tip={`${fx.name}: ${channelRange(fx)}; group ${fx.group}`}>
          <div className={`flex flex-wrap items-center gap-x-3 gap-y-1 text-[13px] ${row ? 'flex-nowrap' : ''}`}>
            <span className="flex-none border border-edge px-1 font-mono text-[10px] leading-[14px] text-dim">{fx.group}</span>
            <span className={`min-w-0 truncate ${row ? 'w-40 flex-none' : 'flex-1'}`}>{fx.name}</span>
            <span className={`shrink-0 font-mono text-[11px] text-dim ${row ? 'w-32' : ''}`}>{channelRange(fx)}</span>
            <div className={`flex min-w-0 gap-px ${row ? 'flex-1' : 'basis-full'}`}>
              {fx.rgb.map(([r, g, b], i) => (
                <span
                  key={i}
                  className={`h-4 min-w-1 flex-1 ${i === 0 && fx.rgb.length > 1 ? 'ring-1 ring-white/70' : ''}`}
                  style={{ background: `rgb(${r},${g},${b})`, maxWidth: '1.5rem' }}
                  data-hint="info"
                  data-tip={`Pixel ${i + 1} of ${fx.name}: R ${r} G ${g} B ${b}${i === 0 ? ' (the first pixel, outlined)' : ''}`}
                />
              ))}
            </div>
          </div>
          {showBytes && <ChannelTable fx={fx} />}
        </div>
      ))}
      {fixtures.length === 0 && <div className="text-[13px] text-dim">No enabled fixtures.</div>}
    </div>
  )
}
