import { useEffect, useState } from 'react'
import { api, type DeviceRef, type SerialDevice } from '../api'
import { OutputMonitor } from '../components/OutputMonitor'
import { Button, NumberInput, Row, SaveBar, Section, StatusDot, Toggle, useSettings } from '../components/forms'
import type { EngineConnection } from '../useEngine'

function deviceKey(d: DeviceRef | SerialDevice): string {
  return d.serial_number ? `sn:${d.serial_number}` : `port:${d.port ?? ''}`
}

function DevicePicker({ value, devices, onChange }: { value: DeviceRef; devices: SerialDevice[]; onChange: (d: DeviceRef) => void }) {
  const current = deviceKey(value)
  const known = devices.some((d) => deviceKey(d) === current)
  return (
    <select
      className="w-full"
      value={current}
      onChange={(e) => {
        const d = devices.find((x) => deviceKey(x) === e.target.value)
        onChange(
          d
            ? { serial_number: d.serial_number, vid: d.vid, pid: d.pid, description: d.description, port: d.port }
            : {},
        )
      }}
    >
      <option value="port:">— select a USB device —</option>
      {!known && current !== 'port:' && (
        <option value={current}>
          {value.description ?? 'configured device'} {value.serial_number ?? value.port} (not connected)
        </option>
      )}
      {devices.map((d) => (
        <option key={deviceKey(d) + d.port} value={deviceKey(d)}>
          {d.label}
        </option>
      ))}
    </select>
  )
}

export function Output({ engine }: { engine: EngineConnection }) {
  const { settings, update, save, dirty, reload, message } = useSettings()
  const [devices, setDevices] = useState<SerialDevice[]>([])
  const refresh = () => api.get<SerialDevice[]>('/api/devices/serial').then(setDevices)
  useEffect(() => {
    refresh()
  }, [])
  if (!settings) return null
  const o = settings.outputs
  const io = engine.state?.io.outputs

  return (
    <div className="grid gap-3 xl:grid-cols-[minmax(0,40rem)_minmax(0,1fr)]">
      <div className="flex min-w-0 flex-col gap-3">
      <div className="flex justify-between">
        <Button onClick={refresh}>Rescan USB devices</Button>
        <SaveBar dirty={dirty} save={save} reload={reload} message={message} />
      </div>

      <Section title="Enttec DMX USB Pro" right={<StatusDot ok={io?.enttec?.connected ?? null} label={io?.enttec ? (io.enttec.connected ? 'connected' : 'not connected') : 'off'} error={io?.enttec?.error} />}>
        <Row label="Enabled">
          <Toggle checked={o.enttec.enabled} onChange={(v) => update((s) => (s.outputs.enttec.enabled = v))} />
        </Row>
        <Row label="Device">
          <DevicePicker value={o.enttec.device} devices={devices} onChange={(d) => update((s) => (s.outputs.enttec.device = d))} />
        </Row>
        <Row label="Universe">
          <NumberInput value={o.enttec.universe} min={0} onChange={(v) => update((s) => (s.outputs.enttec.universe = v))} />
        </Row>
      </Section>

      <Section title="Art-Net" right={<StatusDot ok={io?.artnet?.connected ?? null} label={io?.artnet ? 'sending' : 'off'} error={io?.artnet?.error} />}>
        <Row label="Enabled">
          <Toggle checked={o.artnet.enabled} onChange={(v) => update((s) => (s.outputs.artnet.enabled = v))} />
        </Row>
        <div className="mt-2 flex flex-col gap-2">
          {o.artnet.targets.map((t, i) => (
            <div key={i} className="flex items-center gap-2 text-sm">
              <span className="text-neutral-400">Universe</span>
              <NumberInput value={t.universe} min={0} className="w-16" onChange={(v) => update((s) => (s.outputs.artnet.targets[i].universe = v))} />
              <span className="text-neutral-400">→ IP</span>
              <input
                type="text"
                className="w-40"
                value={t.ip}
                onChange={(e) => update((s) => (s.outputs.artnet.targets[i].ip = e.target.value))}
              />
              <span className="text-neutral-400">Art-Net universe</span>
              <NumberInput
                value={t.artnet_universe ?? t.universe}
                min={0}
                className="w-16"
                onChange={(v) => update((s) => (s.outputs.artnet.targets[i].artnet_universe = v))}
              />
              <Button onClick={() => update((s) => s.outputs.artnet.targets.splice(i, 1))}>✕</Button>
            </div>
          ))}
          <div>
            <Button onClick={() => update((s) => s.outputs.artnet.targets.push({ universe: 0, ip: '127.255.255.255' }))}>
              Add target
            </Button>
          </div>
        </div>
      </Section>

      <Section
        title="PitchPlease v2 (serial)"
        right={<StatusDot ok={io?.pitchpls_v2?.connected ?? null} label={io?.pitchpls_v2 ? (io.pitchpls_v2.connected ? 'connected' : 'not connected') : 'off'} error={io?.pitchpls_v2?.error} />}
      >
        <Row label="Enabled">
          <Toggle checked={o.pitchpls_v2.enabled} onChange={(v) => update((s) => (s.outputs.pitchpls_v2.enabled = v))} />
        </Row>
        <Row label="Device">
          <DevicePicker value={o.pitchpls_v2.device} devices={devices} onChange={(d) => update((s) => (s.outputs.pitchpls_v2.device = d))} />
        </Row>
        <Row label="Baudrate">
          <select value={o.pitchpls_v2.baudrate} onChange={(e) => update((s) => (s.outputs.pitchpls_v2.baudrate = Number(e.target.value)))}>
            {[57600, 115200, 230400, 460800, 921600].map((b) => (
              <option key={b}>{b}</option>
            ))}
          </select>
        </Row>
        <Row label="Mirror mode byte">
          <NumberInput value={o.pitchpls_v2.mode} min={0} max={254} onChange={(v) => update((s) => (s.outputs.pitchpls_v2.mode = v))} />
        </Row>
      </Section>
      </div>

      <div className="min-w-0">
        <Section title="Live output">
          <OutputMonitor state={engine.state} />
        </Section>
      </div>
    </div>
  )
}
