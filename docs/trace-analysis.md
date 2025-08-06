# Trace Analysis

This document provides a lightweight method to explore trace-related code in
Fiwix.  Trace hooks such as `stack_backtrace` or (disabled) `ptrace`
implementations can be located with the accompanying utility script.

## Trace inventory script

`tools/trace_inventory.py` scans the source tree for a substring (default:
`trace`) and prints each matching file, line number, and line content.  The
utility is intentionally simple to facilitate further processing with tools
such as `grep`, `awk`, or Python libraries.

The script now supports optional context output and CSV formatting to ease
downstream analysis or spreadsheet ingestion.

### Usage

```bash
python3 tools/trace_inventory.py
```

Optional arguments:

- `--token` – search for a different substring (e.g., `--token ptrace`).
- `--root` – change the base directory scanned.
- `--context` – include ``N`` lines of context around each match.
- `--format` – choose between ``plain`` and ``csv`` output.

The resulting output assists in cross-referencing all trace-related artifacts
throughout the repository, allowing recursive exploration of stack backtraces,
`ptrace` stubs, and any future tracing infrastructure.

## Installed tooling

The following utilities have been installed and verified in this environment:

- **ripgrep 14.1.0** – high-performance recursive search
- **universal-ctags 5.9.0** – symbol indexer for cross-referencing
- **cloc 1.98** – line and comment counting
- **lizard 1.17.31** – complexity metrics via Python
- **tree-sitter 0.25.8** – language-aware parsing framework
- **doxygen 1.9.8** – documentation generator
- **graphviz 2.43.0** – graph rendering toolkit
- **sphinx 8.2.3** – reStructuredText documentation engine
- **texlive-latex-base 2023.20240207** – provides the `pdflatex` engine
- **texlive-pictures 2023.20240207** – supplies TikZ/PGFPlots for LaTeX graphics

These tools underpin deeper analysis and documentation workflows.

## Toward deeper analysis

For comprehensive observability studies—spanning static, dynamic, and semantic
dimensions—the following toolchain can be layered on top of the inventory data:

- **ripgrep** (`rg`): fast recursive search beyond the default token.
- **universal-ctags** and **cscope/gtags**: construct call graphs and symbol
  cross-references.
- **tree-sitter**: perform language-aware AST extraction for structural
  insights.
- **cloc** and **lizard**: quantify code volume and complexity per file or
  function.
- **Graphviz** or **networkx**: visualize relationships among probes, functions
  and modules.

Combining these utilities facilitates a multi-layered map of trace hooks and
their interactions.  The inventory script provides the seed set of locations,
from which additional scripts or Jupyter notebooks can build richer models of
Fiwix's tracing landscape.

## PDF reporting with PGFPlots

`tools/trace_report.py` demonstrates cross-package orchestration between
Python, LaTeX and the `pgfplots` graphics library.  The helper script invokes
`trace_inventory.py`, aggregates the number of matches per top-level directory
and emits a LaTeX document containing a bar chart.  Compilation is delegated to
`pdflatex`, so the `texlive-latex-base` and `texlive-pictures` packages must be
present.

```bash
python3 tools/trace_report.py --root kernel --output /tmp/trace_report.tex
```

The resulting `/tmp/trace_report.pdf` provides a quick visual overview of where
tracing hooks reside within the chosen subtree, enabling polished reports via
PGFPlots/TikZ.

## Current progress

The following milestones have been achieved to bootstrap systematic tracing
research within the Fiwix codebase:

- **Trace inventory utility** – recursively enumerates files containing
  tracing‑related substrings with optional context and CSV emission.
- **Documentation** – this guide details the script's usage and sketches an
  expanded toolchain for deeper analysis.
- **Validation** – the script executes successfully under Python 3, and its
  output has been inspected with and without contextual lines and in plain or
  CSV formats, demonstrating reproducible results suitable for downstream
  processing.

These steps lay the groundwork for subsequent iterations that will integrate
call‑graph extraction, dynamic tracing, and graph‑based visualisation.

For a reproducible log of commands and sample outputs used during the initial
survey, see the accompanying [`ANALYZE.md`](../ANALYZE.md) in the repository
root.
