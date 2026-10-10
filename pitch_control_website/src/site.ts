// Links and release info shared by every page.

import changelog from '../../pitch_control/CHANGELOG.md'

export const LINKS = {
  repo: 'https://github.com/hlavamir/PitchPlease',
  releases: 'https://github.com/hlavamir/PitchPlease/releases',
  latestRelease: 'https://github.com/hlavamir/PitchPlease/releases/latest',
  issues: 'https://github.com/hlavamir/PitchPlease/issues',
  newIssue: 'https://github.com/hlavamir/PitchPlease/issues/new',
  source: 'https://github.com/hlavamir/PitchPlease/tree/master/pitch_control',
  license: 'https://github.com/hlavamir/PitchPlease/blob/master/LICENSE',
  kofi: 'https://ko-fi.com/zeys_hlvmr',
}

export interface Release {
  version: string
  date: string
  html: string // the release notes
}

// The released versions in the app's CHANGELOG.md ("## 1.1.0 — 2026-10-08"), newest first.
// "Unreleased" and versions marked "(not released)" never had a download.
export const RELEASES: Release[] = changelog.sections.flatMap((s) => {
  const m = s.title.match(/^(\d+\.\d+\.\d+)\s*[—–-]\s*(.+)$/)
  if (!m || /\(not released\)/i.test(s.html)) return []
  return [{ version: m[1], date: m[2].trim(), html: s.html }]
})
export const LATEST = RELEASES[0]

export const PLATFORMS = [
  {
    id: 'macos',
    name: 'macOS',
    detail: 'Apple Silicon (M1 and later)',
    file: `PitchControl-${LATEST.version}-macos-arm64.zip`,
    size: '≈ 22 MB',
  },
  {
    id: 'windows',
    name: 'Windows',
    detail: '64-bit Windows',
    file: `PitchControl-${LATEST.version}-windows-x64.zip`,
    size: '',
  },
] as const

export type PlatformId = (typeof PLATFORMS)[number]['id']
