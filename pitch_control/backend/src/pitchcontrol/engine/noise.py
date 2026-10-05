"""Vectorised numpy port of ``vl/shaders/GeneratorNoise_TextureFX.sdsl``.

3D simplex noise by Yuwen Wu (MIT, based on stegu's webgl-noise) with the
pcg3d16 hash, so the CPU result matches the original shader.
"""

from __future__ import annotations

import numpy as np

_U = np.uint32


def _pcg3d16(p: np.ndarray) -> np.ndarray:
    """``p``: (..., 3) uint32 → (...) uint32."""
    with np.errstate(over="ignore"):
        v = p * _U(1664525) + _U(1013904223)
        x, y, z = v[..., 0].copy(), v[..., 1].copy(), v[..., 2].copy()
        x += y * z
        y += z * x
        z += x * y
        x += y * z
    return x


def _gradient3d(h: np.ndarray) -> np.ndarray:
    masks = np.array([0x80000, 0x40000, 0x20000], dtype=np.uint32)
    scale = np.array([1.0 / 0x40000, 1.0 / 0x20000, 1.0 / 0x10000], dtype=np.float64)
    g = (h[..., None] & masks).astype(np.float64)
    return g * scale - 1.0


def simplex3d(p: np.ndarray) -> np.ndarray:
    """``p``: (..., 3) float, roughly in [-32768, 32767] → noise in about [-1, 1]."""
    p = np.asarray(p, dtype=np.float64)
    c_x, c_y = 1.0 / 6.0, 1.0 / 3.0

    i = np.floor(p + p.sum(axis=-1, keepdims=True) * c_y)
    x0 = p - i + i.sum(axis=-1, keepdims=True) * c_x

    x0_yzx = x0[..., [1, 2, 0]]
    g = (x0 >= x0_yzx).astype(np.float64)  # step(x0.yzx, x0.xyz)
    l = 1.0 - g
    l_zxy = l[..., [2, 0, 1]]
    i1 = np.minimum(g, l_zxy)
    i2 = np.maximum(g, l_zxy)

    x1 = x0 - i1 + c_x
    x2 = x0 - i2 + c_y
    x3 = x0 - 0.5

    i = i + 32768.5
    as_u = lambda a: a.astype(np.int64).astype(np.uint32)  # (uint3) cast truncates
    h0 = _pcg3d16(as_u(i))
    h1 = _pcg3d16(as_u(i + i1))
    h2 = _pcg3d16(as_u(i + i2))
    h3 = _pcg3d16(as_u(i + 1.0))

    xs = (x0, x1, x2, x3)
    gs = (_gradient3d(h0), _gradient3d(h1), _gradient3d(h2), _gradient3d(h3))
    total = np.zeros(p.shape[:-1])
    for x, grad in zip(xs, gs):
        m = np.clip(0.5 - (x * x).sum(axis=-1), 0.0, 1.0)
        m2 = m * m
        total += m2 * m2 * (x * grad).sum(axis=-1)
    return 62.6 * total


def noise_mask(
    u: np.ndarray,
    v: np.ndarray,
    time: float,
    scale: float = 0.666,
    offset: float = 0.0,
    brightness: float = -0.15,
    contrast: float = 0.333,
) -> np.ndarray:
    """``GeneratorNoise_TextureFX.Shading`` for arrays of UV coordinates → 0..1."""
    pos = np.stack([u * scale, (v + offset) * scale, np.full_like(u, time, dtype=np.float64)], axis=-1)
    n = (simplex3d(pos) + 1.0) * 0.5
    remap_min = 0.5 * contrast
    remap_max = 1.0 - remap_min
    return np.clip((n + brightness - remap_min) / (remap_max - remap_min), 0.0, 1.0)
