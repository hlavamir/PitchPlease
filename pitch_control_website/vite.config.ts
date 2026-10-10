import { fileURLToPath } from 'node:url'
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import tailwindcss from '@tailwindcss/vite'
import { markdown } from './plugins/markdown.ts'

const screenshots = fileURLToPath(new URL('../pitch_control/screenshots', import.meta.url))

export default defineConfig({
  plugins: [
    markdown({
      assetDirs: [screenshots],
      // docs pages live at /docs/<file name>, everything else (support.md) at the root
      urlOf: (file) => (file.includes('/src/content/docs/') ? '/docs/' : '/'),
    }),
    react(),
    tailwindcss(),
  ],
  // the screenshots and the changelog are read straight from the app's folder (../pitch_control)
  server: { fs: { allow: ['..'] } },
})
