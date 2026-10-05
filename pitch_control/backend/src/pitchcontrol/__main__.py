"""Entry point: ``pitchcontrol`` or ``python -m pitchcontrol``."""

from __future__ import annotations

import argparse
import logging
from pathlib import Path

import uvicorn

from .config.loader import ConfigStore
from .engine.engine import Engine
from .logsetup import setup_logging
from .server.app import create_app

PROJECT_ROOT = Path(__file__).resolve().parents[3]  # .../pitch_control


def main() -> None:
    parser = argparse.ArgumentParser(description="PitchControl light engine + web UI")
    parser.add_argument("--config", type=Path, default=PROJECT_ROOT / "config", help="configuration folder")
    parser.add_argument("--logs", type=Path, default=PROJECT_ROOT / "logs", help="log folder")
    parser.add_argument("--host", default="127.0.0.1", help="use 0.0.0.0 to allow other devices (phone) on the LAN")
    parser.add_argument("--port", type=int, default=8420)
    parser.add_argument("--no-hardware", action="store_true", help="run without audio, MIDI and outputs")
    args = parser.parse_args()

    setup_logging(args.logs)
    log = logging.getLogger("pitchcontrol")
    log.info("PitchControl starting, config: %s", args.config)

    store = ConfigStore(args.config)
    store.load_all()
    engine = Engine(store, enable_hardware=not args.no_hardware)
    engine.start()

    app = create_app(engine, static_dir=PROJECT_ROOT / "frontend" / "dist")
    try:
        uvicorn.run(app, host=args.host, port=args.port, log_level="warning")
    finally:
        engine.stop()
        log.info("PitchControl stopped")


if __name__ == "__main__":
    main()
