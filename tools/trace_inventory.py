#!/usr/bin/env python3
"""Trace inventory utility for Fiwix.

This script recursively scans the source tree for occurrences of a given
substring (default: ``"trace"``) and reports every file and line in which it
appears.  It is intended to help developers understand existing backtrace,
ptrace, or other tracing-related hooks within the kernel and associated tools.

Example
-------
$ python3 tools/trace_inventory.py
./kernel/traps.c:272:void stack_backtrace(void)
... (more lines)

The tool accepts optional arguments to specify a different search token or a
custom starting directory.
"""

from __future__ import annotations

import argparse
import csv
import sys
from pathlib import Path
from typing import Generator, Iterable, Sequence, Tuple


def scan(
    root: Path, token: str, context: int
) -> Generator[Tuple[Path, int, Sequence[str]], None, None]:
    """Yield ``(path, line_number, snippet)`` for each match.

    ``snippet`` is a list of lines surrounding the match with the matched line
    centered, providing contextual information similar to ``grep -C``.

    Parameters
    ----------
    root:
        Directory to traverse recursively.
    token:
        Substring to search for in each line.
    context:
        Number of context lines to include before and after each match.
    """
    for path in root.rglob("*"):
        if ".git" in path.parts or not path.is_file():
            continue
        try:
            lines = path.read_text(errors="ignore").splitlines()
        except (OSError, UnicodeDecodeError):
            # Skip files that cannot be opened or decoded.
            continue
        for lineno, text in enumerate(lines, start=1):
            if token in text:
                start = max(0, lineno - 1 - context)
                end = lineno + context
                yield path, lineno, lines[start:end]


def main(argv: Iterable[str] | None = None) -> None:
    """CLI entry point."""
    parser = argparse.ArgumentParser(
        description="Enumerate tracing references in the repository."  # noqa: E501
    )
    parser.add_argument(
        "--root",
        type=Path,
        default=Path("."),
        help="Base directory to scan (default: current directory).",
    )
    parser.add_argument(
        "--token",
        default="trace",
        help="Substring to look for (default: 'trace').",
    )
    parser.add_argument(
        "--context",
        type=int,
        default=0,
        help="Number of context lines to display around each match.",
    )
    parser.add_argument(
        "--format",
        choices={"plain", "csv"},
        default="plain",
        help="Output format (default: plain).",
    )
    args = parser.parse_args(list(argv) if argv is not None else None)

    matches = scan(args.root, args.token, args.context)
    if args.format == "csv":
        writer = csv.writer(sys.stdout)
        for path, lineno, snippet in matches:
            writer.writerow([path, lineno, "\n".join(snippet)])
    else:
        for path, lineno, snippet in matches:
            start_line = lineno - args.context
            for offset, line in enumerate(snippet, start=start_line):
                prefix = ":" if offset == lineno else "-" if offset < lineno else "+"
                print(f"{path}:{offset}{prefix} {line}")


if __name__ == "__main__":
    main()
