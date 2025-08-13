# Valgrind Usage and Output

## Installation

```bash
sudo apt install valgrind
```

## Command

```bash
valgrind true
```

## Output

```text
==5570== Memcheck, a memory error detector
==5570== Copyright (C) 2002-2022, and GNU GPL'd, by Julian Seward et al.
==5570== Command: true
==5570==
==5570== HEAP SUMMARY:
==5570==     in use at exit: 0 bytes in 0 blocks
==5570==   total heap usage: 0 allocs, 0 frees, 0 bytes allocated
==5570==
==5570== All heap blocks were freed -- no leaks are possible
==5570== ERROR SUMMARY: 0 errors from 0 contexts (suppressed: 0 from 0)
```
