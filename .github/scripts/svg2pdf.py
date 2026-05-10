#!/usr/bin/env python3
import cairosvg
import os
import sys
from pathlib import Path

svg_dir = Path('illustrations')
if not svg_dir.exists():
    print(f'Directory not found: {svg_dir}')
    sys.exit(1)

svg_files = sorted(svg_dir.glob('*.svg'))
if not svg_files:
    print('No SVG files found')
    sys.exit(1)

print(f'Found {len(svg_files)} SVG files to convert')
success = 0
for svg_path in svg_files:
    pdf_path = svg_path.with_suffix('.pdf')
    if not pdf_path.exists() or svg_path.stat().st_mtime > pdf_path.stat().st_mtime:
        try:
            cairosvg.svg2pdf(url=str(svg_path), write_to=str(pdf_path))
            size = os.path.getsize(pdf_path)
            print(f'Converted {svg_path} -> {pdf_path} ({size} bytes)')
            success += 1
        except Exception as e:
            print(f'Error converting {svg_path}: {e}', file=sys.stderr)
    else:
        print(f'Skipping up-to-date: {svg_path}')

print(f'\nConverted {success}/{len(svg_files)} files')
