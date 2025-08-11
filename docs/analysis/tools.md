# Tool Versions

## cscope
cscope: version 15.9

## ctags
Universal Ctags 5.9.0, Copyright (C) 2015 Universal Ctags Team
Universal Ctags is derived from Exuberant Ctags.

## lizard
1.17.31

## cppcheck
Cppcheck 2.13.0

## cflow
cflow (GNU cflow) 1.7

## doxygen
1.9.8

## sparse
0.6.4

## Commands
- `lizard include/fiwix/sem.h kernel/syscalls/semop.c kernel/syscalls/ipc.c`
- `lizard -C 1 -L 1 include/fiwix/sem.h kernel/syscalls/semop.c kernel/syscalls/ipc.c`
- `cscope -bq -i cscope.files`
- `cscope -q -L -0 sys_semop`
- `cscope -q -L -0 sys_ipc`
- `ctags -x include/fiwix/sem.h kernel/syscalls/semop.c kernel/syscalls/ipc.c`
- `cppcheck --enable=all --inconclusive --library=posix include/fiwix/sem.h kernel/syscalls/semop.c kernel/syscalls/ipc.c`
- `cflow -m sys_semop kernel/syscalls/semop.c kernel/syscalls/ipc.c`
- `doxygen docs/analysis/Doxyfile`
- `sparse -Wbitwise -Wno-decl -Iinclude kernel/syscalls/semop.c kernel/syscalls/ipc.c`
