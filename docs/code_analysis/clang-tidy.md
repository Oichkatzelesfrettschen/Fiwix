# clang-tidy Usage and Output

## Installation

```bash
sudo apt install clang-tidy
```

## Command

```bash
clang-tidy kernel/main.c -- -Iinclude | head -n 20
```

## Output

```text
5 warnings and 2 errors generated.
Error while processing /workspace/Fiwix/kernel/main.c.
/workspace/Fiwix/kernel/main.c:132:25: warning: cast to smaller integer type 'unsigned int' from 'unsigned int *' [clang-diagnostic-pointer-to-int-cast]
include/fiwix/net.h:47:19: error: expected ';' at end of declaration list [clang-diagnostic-error]
include/fiwix/net.h:47:20: error: expected member name or ';' after declaration specifiers [clang-diagnostic-error]
```
