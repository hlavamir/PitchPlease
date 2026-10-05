import tailwindcss from '@tailwindcss/vite'
import react from '@vitejs/plugin-react'
import { defineConfig } from 'vite'

// The dev server proxies the API to the Python backend (default port 8420).
export default defineConfig({
  plugins: [react(), tailwindcss()],
  server: {
    proxy: {
      '/api': 'http://127.0.0.1:8420',
      '/ws': { target: 'ws://127.0.0.1:8420', ws: true },
    },
  },
})
