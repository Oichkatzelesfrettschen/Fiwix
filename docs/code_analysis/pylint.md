# pylint

## Installation
```bash
pip install pylint
```

## Configuration and Usage
Python helper scripts are statically analyzed for style and potential errors:
```bash
pylint tools/trace_inventory.py tools/trace_report.py
```

## Sample Output
```
************* Module trace_report
tools/trace_report.py:88:0: C0116: Missing function or method docstring (missing-function-docstring)

-----------------------------------
Your code has been rated at 9.87/10
```
