"""Logging: one file per backend start in ``logs/YYMMDD_hhmmss.log``, plus the console."""

from __future__ import annotations

import logging
from datetime import datetime
from pathlib import Path

FORMAT = "%(asctime)s %(levelname)-7s %(name)s: %(message)s"


def setup_logging(log_dir: Path, level: int = logging.INFO) -> Path:
    log_dir.mkdir(parents=True, exist_ok=True)
    path = log_dir / f"{datetime.now():%y%m%d_%H%M%S}.log"

    root = logging.getLogger()
    root.setLevel(level)
    for handler in list(root.handlers):
        root.removeHandler(handler)

    file_handler = logging.FileHandler(path, encoding="utf-8")
    file_handler.setFormatter(logging.Formatter(FORMAT))
    root.addHandler(file_handler)

    console = logging.StreamHandler()
    console.setFormatter(logging.Formatter(FORMAT, datefmt="%H:%M:%S"))
    root.addHandler(console)

    logging.getLogger(__name__).info("logging to %s", path)
    return path
