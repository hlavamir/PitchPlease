import { useState } from 'react'
import type { EngineState, FixtureState } from '../api'
import { useElementWidth } from '../useElementWidth'
import { Toggle } from './forms'

function channelRange(fx: FixtureState): string {
  if (fx.transport === 'pitchpls_v2') return 'v2 serial'
  const end = fx.address + Math.max(fx.output.length, 1) - 1
  return `U${fx.universe} · ${fx.address}–${end}`
}

/** Live view of what every fixture outputs: pixel colours and (optionally) the raw DMX / serial bytes. */
export function OutputMonitor({ state, only }: { state: EngineState | null; only?: string | string[] | null }) {
  const [showBytes, setShowBytes] = useState(false)
  const [ref, width] = useElementWidth<HTMLDivElement>()
  const row = width >= 648 // one line per fixture
  const fixtures = (state?.fixtures ?? []).filter((f) => !only || (Array.isArray(only) ? only.includes(f.name) : f.name === only))
  return (
    <div ref={ref} className="flex flex-col gap-2">
      <label className="flex cursor-pointer items-center gap-2 self-end text-[11px] text-dim">
        <Toggle checked={showBytes} onChange={setShowBytes} />
        show channel values
      </label>
      {fixtures.map((fx) => (
        <div key={fx.name} className="bg-panel-2 px-2 py-1.5">
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
                  title={`pixel ${i + 1}: ${r} ${g} ${b}`}
                />
              ))}
            </div>
          </div>
          {showBytes && (
            <div className="mt-1 font-mono text-[11px] leading-snug break-all text-dim">{fx.output.join(' ')}</div>
          )}
        </div>
      ))}
      {fixtures.length === 0 && <div className="text-[13px] text-dim">No enabled fixtures.</div>}
    </div>
  )
}
