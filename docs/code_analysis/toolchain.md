# LLVM Toolchain Configuration

## Installation

```bash
sudo apt install ninja-build clang lld
```

## Version Check

```bash
clang --version
ld.lld --version
ninja --version
```

## Sample Build Invocation

```bash
CC=clang LD=ld.lld ninja -n
```

## Output

```text
[1/1] make all
```
