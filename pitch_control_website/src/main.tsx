import { StrictMode } from 'react'
import { createRoot, hydrateRoot } from 'react-dom/client'
import { BrowserRouter } from 'react-router'
import App from './App'
import './index.css'

const root = document.getElementById('root')!
const app = (
  <StrictMode>
    <BrowserRouter>
      <App />
    </BrowserRouter>
  </StrictMode>
)

// the built pages are prerendered (scripts/prerender.mjs); the dev server serves an empty root
if (root.firstElementChild) hydrateRoot(root, app)
else createRoot(root).render(app)
