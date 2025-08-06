#!/usr/bin/env python3
"""Produce a PGFPlots PDF summary of trace occurrences.

This helper script invokes ``trace_inventory.py`` to collect all matches of
tracing-related tokens within the repository.  It then aggregates the number of
matches per top-level directory and renders a small bar chart using
``pgfplots``/``tikz``.  The resulting ``.tex`` file is compiled to PDF via
``pdflatex``.

Requirements
-----------
- Python 3
- ``pdflatex`` with the ``pgfplots`` package (typically provided by
  ``texlive-latex-base`` and ``texlive-pictures``)

Example
-------
```
python3 tools/trace_report.py --root kernel --output /tmp/trace_report.tex
```
This command creates ``/tmp/trace_report.pdf`` showing the distribution of
trace references across top-level directories under ``kernel``.
"""

from __future__ import annotations

import argparse
import csv
import subprocess
from collections import Counter
from pathlib import Path
from typing import Iterable, Mapping


def collect(root: Path) -> Mapping[str, int]:
    """Return a count of trace matches per top-level directory."""
    script = Path(__file__).with_name("trace_inventory.py")
    cmd = ["python3", str(script), "--format", "csv", "--root", str(root)]
    proc = subprocess.run(cmd, capture_output=True, text=True, check=True)
    reader = csv.reader(proc.stdout.splitlines())
    counts: Counter[str] = Counter()
    for row in reader:
        if not row:
            continue
        path = Path(row[0])
        top = path.parts[0] if path.parts else ""
        counts[top] += 1
    return counts


def render(counts: Mapping[str, int]) -> str:
    """Return a LaTeX document embedding a PGFPlots bar chart."""
    coords = " ".join(f"({k},{v})" for k, v in counts.items())
    xcoords = ",".join(counts.keys())
    return f"""
\\documentclass{{standalone}}
\\usepackage{{pgfplots}}
\\pgfplotsset{{compat=1.17}}
\\begin{{document}}
\\begin{{tikzpicture}}
\\begin{{axis}}[
    ybar,
    xlabel={{Directory}},
    ylabel={{Trace occurrences}},
    symbolic x coords={{ {xcoords} }},
    xtick=data,
    nodes near coords,
    ymin=0,
]
\\addplot coordinates {{ {coords} }};
\\end{{axis}}
\\end{{tikzpicture}}
\\end{{document}}
"""


def compile_tex(tex_path: Path) -> None:
    """Invoke pdflatex on ``tex_path`` in its directory."""
    subprocess.run(
        ["pdflatex", "-interaction=nonstopmode", tex_path.name],
        cwd=tex_path.parent,
        check=True,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )


def main(argv: Iterable[str] | None = None) -> None:
    parser = argparse.ArgumentParser(description="Build PGFPlots PDF report")
    parser.add_argument(
        "--root",
        type=Path,
        default=Path("."),
        help="Directory to scan for trace tokens",
    )
    parser.add_argument(
        "--output",
        type=Path,
        default=Path("trace_report.tex"),
        help="Destination .tex file (PDF written alongside)",
    )
    args = parser.parse_args(list(argv) if argv is not None else None)

    counts = collect(args.root)
    tex = render(counts)
    args.output.write_text(tex)
    compile_tex(args.output)


if __name__ == "__main__":
    main()
