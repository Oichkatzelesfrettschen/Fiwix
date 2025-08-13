# jscpd

## Installation
```bash
npm install -g jscpd
```

## Configuration and Usage
Duplicate code is detected across supported languages with a minimum clone size of 20 lines:
```bash
jscpd --min-lines 20 --reporters console .
```

## Sample Output
```
Found 68 clones.
Detection time:: 4.055s
```
