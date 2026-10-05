"""Generate the app icon (icon.png, icon.icns, icon.ico): a pitch fader on a dark tile."""

from pathlib import Path

from PIL import Image, ImageDraw

HERE = Path(__file__).resolve().parent
S = 1024


def draw() -> Image.Image:
    img = Image.new("RGBA", (S, S), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    m = 90  # margin, as in macOS icon templates
    d.rounded_rectangle([m, m, S - m, S - m], radius=190, fill=(18, 19, 24, 255))
    # fader slot and scale ticks
    cx = S // 2
    d.rounded_rectangle([cx - 22, 230, cx + 22, S - 230], radius=22, fill=(52, 55, 64, 255))
    for i in range(9):
        y = 250 + i * (S - 500) / 8
        w = 120 if i % 4 == 0 else 70
        d.line([cx - 90 - w, y, cx - 90, y], fill=(90, 94, 106, 255), width=14)
        d.line([cx + 90, y, cx + 90 + w, y], fill=(90, 94, 106, 255), width=14)
    # fader knob (accent orange) with a centre line
    ky = 420
    d.rounded_rectangle([cx - 150, ky - 70, cx + 150, ky + 70], radius=36, fill=(245, 165, 36, 255))
    d.line([cx - 110, ky, cx + 110, ky], fill=(18, 19, 24, 255), width=16)
    return img


def main() -> None:
    img = draw()
    img.save(HERE / "icon.png")
    img.save(HERE / "icon.ico", sizes=[(16, 16), (24, 24), (32, 32), (48, 48), (64, 64), (128, 128), (256, 256)])
    img.save(HERE / "icon.icns")
    print("icons written to", HERE)


if __name__ == "__main__":
    main()
