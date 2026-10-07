import { useEffect, useState } from 'react'
import { api, type AudioDevice } from '../api'
import { BandMeter } from '../components/BandMeter'
import { Button, NumberInput, Row, SaveBar, Section, StatusDot, useSettings } from '../components/forms'
import type { EngineConnection } from '../useEngine'

interface BandInfo {
  edges: number[]
  centres: number[]
  trigger_weights: number[]
}

export function Inputs({ engine }: { engine: EngineConnection }) {
  const { settings, update, save, dirty, reload, message } = useSettings()
  const [audioDevices, setAudioDevices] = useState<AudioDevice[]>([])
  const [midiPorts, setMidiPorts] = useState<string[]>([])
  const [controllers, setControllers] = useState<string[]>([])
  const [bands, setBands] = useState<BandInfo | null>(null)

  const refresh = () => {
    api.get<AudioDevice[]>('/api/devices/audio').then(setAudioDevices)
    api.get<string[]>('/api/devices/midi').then(setMidiPorts)
    api.get<{ available: string[] }>('/api/controllers').then((c) => setControllers(c.available))
    api.get<BandInfo>('/api/audio/bands').then(setBands)
  }
  useEffect(refresh, [])
  if (!settings) return null
  const a = settings.audio
  const io = engine.state?.io
  const selected = audioDevices.find((d) => a.device && d.label.toLowerCase().includes(a.device.toLowerCase()))

  return (
    <div className="flex max-w-4xl flex-col gap-1.5">
      <div className="flex justify-between">
        <Button onClick={refresh}>Rescan devices</Button>
        <SaveBar dirty={dirty} save={save} reload={reload} message={message} />
      </div>

      <Section
        index="01"
        title="Audio input"
        right={<StatusDot ok={io?.audio ? io.audio.running : null} label={io?.audio?.running ? 'running' : 'stopped'} error={io?.audio?.error} />}
      >
        <Row label="Device">
          <select className="w-full" value={selected?.label ?? a.device ?? ''} onChange={(e) => update((s) => (s.audio.device = e.target.value || null))}>
            <option value="">System default</option>
            {a.device && !selected && <option value={a.device}>{a.device} (not found)</option>}
            {audioDevices.map((d) => (
              <option key={d.index} value={d.label}>
                {d.label} — {d.channels} in
              </option>
            ))}
          </select>
        </Row>
        <Row label="Input channels" hint="1-based; selected channels are summed to mono">
          <input
            type="text"
            className="w-32"
            value={a.channels.join(', ')}
            onChange={(e) =>
              update(
                (s) =>
                  (s.audio.channels = e.target.value
                    .split(',')
                    .map((x) => parseInt(x.trim(), 10))
                    .filter((x) => x > 0)),
              )
            }
          />
          {selected && <span className="text-[11px] text-dim">device has {selected.channels} inputs</span>}
        </Row>
        <Row label="Gain">
          <NumberInput value={a.gain} min={0} onChange={(v) => update((s) => (s.audio.gain = v))} />
          <div className="h-2 w-40 bg-panel-2">
            <div className="h-2 dot-on" style={{ width: `${Math.min(1, io?.audio?.level ?? 0) * 100}%` }} />
          </div>
        </Row>
        <div className="mt-3">
          <div className="mb-1 flex justify-between text-[11px] text-dim">
            <span>{bands ? `${bands.edges[0]} Hz` : ''}</span>
            <span>32 bands · blue line = strobo trigger weight</span>
            <span>{bands ? `${bands.edges[bands.edges.length - 1]} Hz` : ''}</span>
          </div>
          <BandMeter bands={engine.state?.bands ?? []} peaks={engine.state?.band_peaks} weights={bands?.trigger_weights} height={100} />
        </div>
      </Section>

      <Section
        index="02"
        title="MIDI controller"
        right={<StatusDot ok={io?.midi ? Boolean(io.midi.port) : null} label={io?.midi?.port ?? 'not connected'} error={io?.midi?.error} />}
      >
        <Row label="Controller mapping" hint="controllers/*.json">
          <select value={settings.active_controller ?? ''} onChange={(e) => update((s) => (s.active_controller = e.target.value || null))}>
            <option value="">none</option>
            {controllers.map((c) => (
              <option key={c}>{c}</option>
            ))}
          </select>
        </Row>
        <Row label="MIDI port" hint="Empty = use the port name from the controller file">
          <select value={settings.midi_input ?? ''} onChange={(e) => update((s) => (s.midi_input = e.target.value || null))}>
            <option value="">from controller file</option>
            {midiPorts.map((p) => (
              <option key={p}>{p}</option>
            ))}
          </select>
        </Row>
        <div className="mt-3">
          <div className="mb-1 flex justify-between text-[11px] text-dim">
            <span>MIDI monitor — last messages (newest first)</span>
            <span>
              {io?.midi?.received ?? 0} received · mapping on channel {io?.midi?.channel ?? '–'}
            </span>
          </div>
          <div className="max-h-64 overflow-auto bg-panel-2 p-2 font-mono text-[11px]">
            {(io?.midi?.recent ?? []).length === 0 && (
              <div className="text-dim">Nothing received yet — move a fader or knob on the controller.</div>
            )}
            {(io?.midi?.recent ?? []).map((m, i) => (
              <div key={`${m.t}-${i}`} className="flex gap-3">
                <span className="flex-1 truncate text-ink">{m.text}</span>
                {m.macro ? <span className="text-ink">→ {m.macro}</span> : <span className="text-ink">{m.note}</span>}
              </div>
            ))}
          </div>
        </div>
      </Section>
    </div>
  )
}
