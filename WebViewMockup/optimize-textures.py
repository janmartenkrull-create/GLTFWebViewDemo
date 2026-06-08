#!/usr/bin/env python3
"""Downscale and recompress PNG/JPEG/WebP textures for the WebViewMockup package."""

from __future__ import annotations

import sys
from pathlib import Path

from PIL import Image

IMAGE_EXTENSIONS = {".png", ".jpg", ".jpeg", ".webp"}
DEFAULT_MAX_SIZE = 1024


def prepare_image(image: Image.Image) -> Image.Image:
    if image.mode == "P":
        return image.convert("RGBA" if "transparency" in image.info else "RGB")
    if image.mode in ("RGBA", "RGB", "L", "LA"):
        return image
    return image.convert("RGBA")


def resize_if_needed(image: Image.Image, max_size: int) -> Image.Image:
    width, height = image.size
    longest = max(width, height)
    if longest <= max_size:
        return image

    scale = max_size / longest
    new_width = max(1, round(width * scale))
    new_height = max(1, round(height * scale))
    return image.resize((new_width, new_height), Image.Resampling.LANCZOS)


def save_image(image: Image.Image, path: Path) -> None:
    suffix = path.suffix.lower()
    if suffix == ".png":
        if image.mode not in ("RGB", "RGBA"):
            image = image.convert("RGBA")
        image.save(path, format="PNG", optimize=True, compress_level=9)
        return

    if suffix in (".jpg", ".jpeg"):
        if image.mode == "RGBA":
            background = Image.new("RGB", image.size, (255, 255, 255))
            background.paste(image, mask=image.split()[3])
            image = background
        elif image.mode != "RGB":
            image = image.convert("RGB")
        image.save(path, format="JPEG", quality=82, optimize=True, progressive=True)
        return

    if suffix == ".webp":
        image.save(path, format="WEBP", quality=82, method=6)


def optimize_file(path: Path, max_size: int) -> tuple[int, int, int, int]:
    original_bytes = path.stat().st_size

    with Image.open(path) as source:
        original_size = source.size
        image = resize_if_needed(prepare_image(source), max_size)
        save_image(image, path)

    new_bytes = path.stat().st_size
    return original_size[0], original_size[1], original_bytes, new_bytes


def optimize_tree(root: Path, max_size: int) -> int:
    if not root.exists():
        raise SystemExit(f"Texture root not found: {root}")

    files = sorted(
        path
        for path in root.rglob("*")
        if path.is_file() and path.suffix.lower() in IMAGE_EXTENSIONS
    )

    if not files:
        print(f"No textures found under {root}")
        return 0

    before_total = 0
    after_total = 0
    resized_count = 0
    saved_total = 0

    for index, path in enumerate(files, start=1):
        width, height, before_bytes, after_bytes = optimize_file(path, max_size)
        before_total += before_bytes
        after_total += after_bytes
        saved = before_bytes - after_bytes
        if saved > 0:
            saved_total += saved
        if max(width, height) > max_size:
            resized_count += 1

        if index % 25 == 0 or index == len(files):
            print(f"  {index}/{len(files)} textures processed...", flush=True)

    print("")
    print(
        f"Optimized {len(files)} textures "
        f"({resized_count} downscaled above {max_size}px)."
    )
    print(f"Before: {before_total / 1024 / 1024:.1f} MB")
    print(f"After:  {after_total / 1024 / 1024:.1f} MB")
    print(f"Saved:  {saved_total / 1024 / 1024:.1f} MB")
    return 0


def main() -> int:
    script_dir = Path(__file__).resolve().parent
    default_root = (
        script_dir / "PackageSources" / "SimObjects" / "Airplanes" / "FSS_Tecnam_P2012"
    )

    root = Path(sys.argv[1]).resolve() if len(sys.argv) > 1 else default_root
    max_size = int(sys.argv[2]) if len(sys.argv) > 2 else DEFAULT_MAX_SIZE

    print(f"Optimizing textures under: {root}")
    print(f"Max edge length: {max_size}px")
    print("")
    return optimize_tree(root, max_size)


if __name__ == "__main__":
    raise SystemExit(main())
