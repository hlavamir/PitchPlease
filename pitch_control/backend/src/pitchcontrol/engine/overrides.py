"""Manual DMX channel overrides (Control Desk page).

An override replaces one output channel of one universe with a fixed value, after fixtures and fog
have written the frame. Overrides are saved to ``state/overrides.json`` and restored on start, so a
manual fix survives a restart; the UI shows how many are active.
"""

from __future__ import annotations

import json
import logging
import threading
from pathlib import Path

log = logging.getLogger(__name__)


class Overrides:
    def __init__(self) -> None:
        self._values: dict[tuple[int, int], int] = {}  # (universe, channel 1–512) → 0–255
        self._lock = threading.Lock()
        self.version = 0  # bumped on every change (autosave)

    def set(self, universe: int, channel: int, value: int | None) -> None:
        """Override a channel (1–512) with ``value`` (0–255); ``None`` releases it."""
        if not (0 <= universe and 1 <= channel <= 512):
            raise ValueError(f"no DMX channel {universe}:{channel}")
        with self._lock:
            if value is None:
                self._values.pop((universe, channel), None)
            else:
                self._values[(universe, channel)] = max(0, min(255, int(round(value))))
            self.version += 1

    def clear(self) -> int:
        with self._lock:
            n = len(self._values)
            self._values.clear()
            self.version += 1
        return n

    def apply(self, universes: dict[int, bytearray]) -> None:
        with self._lock:
            items = list(self._values.items())
        for (u, ch), v in items:
            universes.setdefault(u, bytearray(512))[ch - 1] = v

    def snapshot(self) -> dict[str, dict[str, int]]:
        """``{"0": {"12": 255}}``: universe → channel → value (JSON keys are strings)."""
        out: dict[str, dict[str, int]] = {}
        with self._lock:
            for (u, ch), v in sorted(self._values.items()):
                out.setdefault(str(u), {})[str(ch)] = v
        return out

    def __len__(self) -> int:
        return len(self._values)

    # -- persistence
    def load(self, path: Path) -> None:
        if not path.exists():
            return
        try:
            data = json.loads(path.read_text(encoding="utf-8"))
            for u, chans in data.items():
                for ch, v in chans.items():
                    self.set(int(u), int(ch), int(v))
        except (OSError, ValueError, AttributeError) as exc:
            log.error("%s: cannot restore DMX overrides: %s", path, exc)
            return
        if self._values:
            log.warning("restored %d DMX channel override(s) from %s", len(self._values), path)

    def save(self, path: Path) -> None:
        path.parent.mkdir(parents=True, exist_ok=True)
        tmp = path.with_suffix(".json.tmp")
        tmp.write_text(json.dumps(self.snapshot(), indent=2) + "\n", encoding="utf-8")
        tmp.replace(path)
