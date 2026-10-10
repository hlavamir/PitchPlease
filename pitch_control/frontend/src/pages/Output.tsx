import { useEffect, useState } from 'react'
import { api, type DeviceRef, type SerialDevice } from '../api'
import { OutputMonitor } from '../components/OutputMonitor'
import { ARTNET_UNIVERSES, Button, NumberInput, Row, SaveBar, Section, StatusDot, Toggle, UniverseSelect, useSettings } from '../components/forms'
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
      data-tip="USB device of this output; chosen by serial number, so it survives a different USB port"
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

const MAX_ENTTEC = 4 // as in the backend (config/models.py)

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
  // two interfaces on one device would garble both streams: the backend starts only the first
  const used = new Map<string, number>()
  const sameAs = o.enttec.map((e, i) => {
    const key = deviceKey(e.device)
    if (!e.enabled || key === 'port:') return null
    const first = used.get(key)
    if (first === undefined) used.set(key, i)
    return first ?? null
  })

  return (
    // settings and live output take half the page width each, or the full width under each other
    <div className="grid gap-1.5 wide:grid-cols-2">
      <div className="flex min-w-0 flex-col gap-1.5">
      <div className="flex justify-between">
        <Button onClick={refresh} tip="Look for newly plugged-in USB devices; unplugged ones stay selected and show as not connected">
          Rescan USB devices
        </Button>
        <SaveBar dirty={dirty} save={save} reload={reload} message={message} />
      </div>

      <Section
        index="01"
        title="Enttec DMX USB Pro"
        tip="DMX over USB with Enttec DMX USB Pro interfaces: each sends one universe to the lights on its cable"
        right={
          <>
            <span>
              {o.enttec.length} / {MAX_ENTTEC} interfaces
            </span>
            <button
              disabled={o.enttec.length >= MAX_ENTTEC}
              data-tip={o.enttec.length >= MAX_ENTTEC ? `Maximum of ${MAX_ENTTEC} interfaces reached` : 'Add another Enttec DMX USB Pro, with its own device and universe (up to 4)'}
              className="lbl h-[18px] border border-edge px-2 text-[10px] text-ink disabled:opacity-40"
              onClick={() =>
                update((s) =>
                  s.outputs.enttec.push({ enabled: true, device: {}, universe: s.outputs.enttec.reduce((n, x) => Math.max(n, x.universe + 1), 0) }),
                )
              }
            >
              Add interface
            </button>
          </>
        }
      >
        <div className="flex flex-col gap-2.5">
          {o.enttec.length === 0 && <p className="text-[13px] text-dim">No USB DMX interface. Add one for each Enttec you plug in; each sends its own universe.</p>}
          {o.enttec.map((e, i) => {
            const st = io?.enttec?.[i]
            return (
              <div key={i} className="flex flex-col gap-1.5 border border-edge p-2">
                <div className="flex items-center justify-between gap-2">
                  <span className="flex items-center gap-2.5">
                    <Toggle checked={e.enabled} tip="Switch on to send this interface's universe; off keeps the settings but sends nothing" onChange={(v) => update((s) => (s.outputs.enttec[i].enabled = v))} />
                    <span className="lbl text-[12px]" data-tip="Switch on to send this interface's universe; off keeps the settings but sends nothing">
                      Interface {i + 1}
                    </span>
                  </span>
                  <span className="flex items-center gap-3">
                    <StatusDot ok={st ? st.connected : null} label={st ? (st.connected ? 'connected' : 'not connected') : 'off'} error={st?.error} tip="Whether this interface is open and receiving frames (after Save)" />
                    <Button onClick={() => update((s) => s.outputs.enttec.splice(i, 1))} tip="Remove this interface; the ones below move up (written with Save)">
                      Remove
                    </Button>
                  </span>
                </div>
                <div className="flex items-center gap-2 text-[13px]">
                  <span className="text-dim">Device</span>
                  <div className="min-w-0 flex-1">
                    <DevicePicker value={e.device} devices={devices} onChange={(d) => update((s) => (s.outputs.enttec[i].device = d))} />
                  </div>
                  <span className="text-dim">Universe</span>
                  <UniverseSelect value={e.universe} tip="The universe this interface sends: fixtures with this universe on the Rig page are on its cable" onChange={(v) => update((s) => (s.outputs.enttec[i].universe = v))} />
                </div>
                {sameAs[i] !== null && <p className="text-[12px] text-glow">Same device as interface {sameAs[i]! + 1}: this one is not started.</p>}
              </div>
            )
          })}
        </div>
      </Section>

      <Section
        index="02"
        title="Art-Net"
        right={<StatusDot ok={io?.artnet?.connected ?? null} label={io?.artnet ? 'sending' : 'off'} error={io?.artnet?.error} tip="Whether Art-Net packets are being sent" />}
        tip="DMX over the network (Art-Net): each target sends one universe to one node, or to a broadcast address"
      >
        <Row label="Enabled" hint="Send Art-Net to the targets below; off keeps them but sends nothing">
          <Toggle checked={o.artnet.enabled} onChange={(v) => update((s) => (s.outputs.artnet.enabled = v))} />
        </Row>
        <div className="mt-2 flex flex-col gap-2">
          {o.artnet.targets.map((t, i) => (
            <div key={i} className="flex items-center gap-2 text-[13px]">
              <span className="text-dim">Universe</span>
              <UniverseSelect value={t.universe} tip="Universe of this app (as on the Rig page) to send to this target" onChange={(v) => update((s) => (s.outputs.artnet.targets[i].universe = v))} />
              <span className="text-dim">→ IP</span>
              <input
                type="text"
                className="w-40"
                data-tip="IP address of the Art-Net node; 255 in the last numbers (e.g. 2.255.255.255) broadcasts to a whole network"
                value={t.ip}
                onChange={(e) => update((s) => (s.outputs.artnet.targets[i].ip = e.target.value))}
              />
              <span className="text-dim">Art-Net universe</span>
              <UniverseSelect
                value={t.artnet_universe ?? t.universe}
                options={ARTNET_UNIVERSES}
                tip="Art-Net universe on the wire (what the node listens to), 0–15; by default the same number as the universe"
                onChange={(v) => update((s) => (s.outputs.artnet.targets[i].artnet_universe = v))}
              />
              <Button onClick={() => update((s) => s.outputs.artnet.targets.splice(i, 1))} tip="Remove this Art-Net target (written with Save)">
                ✕
              </Button>
            </div>
          ))}
          <div>
            <Button
              onClick={() => update((s) => s.outputs.artnet.targets.push({ universe: 0, ip: '127.255.255.255' }))}
              tip="Add a target: one universe sent to one IP address"
            >
              Add target
            </Button>
          </div>
        </div>
      </Section>

      <Section
        index="03"
        title="PitchPlease v2 (serial)"
        tip="The PitchPlease v2 strips take RGB bytes over a USB serial line instead of DMX (fixture type output: v2 serial)"
        right={<StatusDot ok={io?.pitchpls_v2?.connected ?? null} label={io?.pitchpls_v2 ? (io.pitchpls_v2.connected ? 'connected' : 'not connected') : 'off'} error={io?.pitchpls_v2?.error} />}
      >
        <Row label="Enabled" hint="Send to the v2 strips; off keeps the settings but sends nothing">
          <Toggle checked={o.pitchpls_v2.enabled} onChange={(v) => update((s) => (s.outputs.pitchpls_v2.enabled = v))} />
        </Row>
        <Row label="Device" hint="USB serial device of the v2 controller board">
          <DevicePicker value={o.pitchpls_v2.device} devices={devices} onChange={(d) => update((s) => (s.outputs.pitchpls_v2.device = d))} />
        </Row>
        <Row label="Baudrate" hint="Serial speed; must match the v2 firmware (921600 by default)">
          <select value={o.pitchpls_v2.baudrate} onChange={(e) => update((s) => (s.outputs.pitchpls_v2.baudrate = Number(e.target.value)))}>
            {[57600, 115200, 230400, 460800, 921600].map((b) => (
              <option key={b}>{b}</option>
            ))}
          </select>
        </Row>
        <Row label="Mirror mode byte" hint="Mode byte sent after the pixels: how the firmware mirrors the 19 pixels onto its 38 LEDs (0–254)">
          <NumberInput value={o.pitchpls_v2.mode} integer min={0} max={254} onChange={(v) => update((s) => (s.outputs.pitchpls_v2.mode = v))} />
        </Row>
      </Section>
      </div>

      <div className="min-w-0">
        <Section index="04" title="Live output" tip="What the fixtures send right now, after gamma: the DMX and serial data that leaves this app">
          <OutputMonitor state={engine.state} />
        </Section>
      </div>
    </div>
  )
}
