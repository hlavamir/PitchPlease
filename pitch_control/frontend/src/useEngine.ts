import { useCallback, useEffect, useRef, useState } from 'react'
import type { EngineState } from './api'

export const PREVIEW_SIZE = 256

export interface EngineConnection {
  state: EngineState | null
  preview: Uint8Array | null
  connected: boolean
  setMacro: (name: string, value: number) => void
  toggleMacro: (name: string) => void
}

/** Live connection to the engine: JSON state + binary 256×256 preview, reconnecting automatically. */
export function useEngine(): EngineConnection {
  const [state, setState] = useState<EngineState | null>(null)
  const [preview, setPreview] = useState<Uint8Array | null>(null)
  const [connected, setConnected] = useState(false)
  const socketRef = useRef<WebSocket | null>(null)

  useEffect(() => {
    let closed = false
    let retry: number | undefined

    const connect = () => {
      const proto = location.protocol === 'https:' ? 'wss' : 'ws'
      const ws = new WebSocket(`${proto}://${location.host}/ws`)
      ws.binaryType = 'arraybuffer'
      socketRef.current = ws
      ws.onopen = () => setConnected(true)
      ws.onmessage = (ev) => {
        if (typeof ev.data === 'string') setState(JSON.parse(ev.data))
        else setPreview(new Uint8Array(ev.data))
      }
      ws.onclose = () => {
        setConnected(false)
        if (!closed) retry = window.setTimeout(connect, 1000)
      }
    }
    connect()
    return () => {
      closed = true
      window.clearTimeout(retry)
      socketRef.current?.close()
    }
  }, [])

  const send = useCallback((msg: object) => {
    const ws = socketRef.current
    if (ws && ws.readyState === WebSocket.OPEN) ws.send(JSON.stringify(msg))
  }, [])

  const setMacro = useCallback((name: string, value: number) => send({ type: 'macro', name, value }), [send])
  const toggleMacro = useCallback((name: string) => send({ type: 'toggle', name }), [send])

  return { state, preview, connected, setMacro, toggleMacro }
}
