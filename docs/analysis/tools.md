# Analysis Tools

This document centralizes static-analysis tooling usage.

## Version Retrieval

Use the following snippet to record the versions of installed tools:

```sh
lizard --version
cscope --version
ctags --version
cppcheck --version
cflow --version
doxygen --version
sparse --version
```

## Commands

Run these commands to analyze the SysV semaphore implementation:

```sh
lizard include/fiwix/sem.h kernel/syscalls/semop.c kernel/syscalls/ipc.c
lizard -C 1 -L 1 include/fiwix/sem.h kernel/syscalls/semop.c kernel/syscalls/ipc.c
cscope -bq -i cscope.files
cscope -q -L -0 sys_semop
cscope -q -L -0 sys_ipc
ctags -x include/fiwix/sem.h kernel/syscalls/semop.c kernel/syscalls/ipc.c
cppcheck --enable=all --inconclusive --library=posix include/fiwix/sem.h kernel/syscalls/semop.c kernel/syscalls/ipc.c
cflow -m sys_semop kernel/syscalls/semop.c kernel/syscalls/ipc.c
# generate a temporary Doxygen config and run
doxygen -g /tmp/Doxyfile && doxygen /tmp/Doxyfile
sparse -Wbitwise -Wno-decl -Iinclude kernel/syscalls/semop.c kernel/syscalls/ipc.c
```

The detailed reports produced by these commands should be published as CI artifacts or kept in a separate archive to avoid cluttering the repository.
