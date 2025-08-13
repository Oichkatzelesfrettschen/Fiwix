# nyc

## Installation
```bash
npm install -g nyc
```

## Configuration and Usage
`nyc` instruments Node.js programs to collect coverage data. A trivial script demonstrates invocation:
```bash
nyc node -e "console.log('hi')"
```

## Sample Output
```
17.1.0
hi
----------|---------|----------|---------|---------|-------------------
File      | % Stmts | % Branch | % Funcs | % Lines | Uncovered Line #s
----------|---------|----------|---------|---------|-------------------
All files |       0 |        0 |       0 |       0 |
``` 
