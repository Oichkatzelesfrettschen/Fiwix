# flake8

## Installation
```bash
pip install flake8
```

## Configuration and Usage
`flake8` enforces PEP 8 style conventions. The project’s Python utilities are checked:
```bash
flake8 tools/trace_inventory.py tools/trace_report.py
```

## Sample Output
```
tools/trace_inventory.py:99:80: E501 line too long (85 > 79 characters)
```
