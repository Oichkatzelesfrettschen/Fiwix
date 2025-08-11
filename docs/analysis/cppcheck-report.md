include/fiwix/sem.h:10:0: information: Include file: <fiwix/types.h> not found. Please note: Cppcheck does not need standard library headers to get proper results. [missingIncludeSystem]
#include <fiwix/types.h>
^
include/fiwix/sem.h:11:0: information: Include file: <fiwix/ipc.h> not found. Please note: Cppcheck does not need standard library headers to get proper results. [missingIncludeSystem]
#include <fiwix/ipc.h>
^
kernel/syscalls/semop.c:8:0: information: Include file: <fiwix/config.h> not found. Please note: Cppcheck does not need standard library headers to get proper results. [missingIncludeSystem]
#include <fiwix/config.h>
^
kernel/syscalls/semop.c:9:0: information: Include file: <fiwix/kernel.h> not found. Please note: Cppcheck does not need standard library headers to get proper results. [missingIncludeSystem]
#include <fiwix/kernel.h>
^
kernel/syscalls/semop.c:10:0: information: Include file: <fiwix/types.h> not found. Please note: Cppcheck does not need standard library headers to get proper results. [missingIncludeSystem]
#include <fiwix/types.h>
^
kernel/syscalls/semop.c:11:0: information: Include file: <fiwix/string.h> not found. Please note: Cppcheck does not need standard library headers to get proper results. [missingIncludeSystem]
#include <fiwix/string.h>
^
kernel/syscalls/semop.c:12:0: information: Include file: <fiwix/process.h> not found. Please note: Cppcheck does not need standard library headers to get proper results. [missingIncludeSystem]
#include <fiwix/process.h>
^
kernel/syscalls/semop.c:13:0: information: Include file: <fiwix/sleep.h> not found. Please note: Cppcheck does not need standard library headers to get proper results. [missingIncludeSystem]
#include <fiwix/sleep.h>
^
kernel/syscalls/semop.c:14:0: information: Include file: <fiwix/sched.h> not found. Please note: Cppcheck does not need standard library headers to get proper results. [missingIncludeSystem]
#include <fiwix/sched.h>
^
kernel/syscalls/semop.c:15:0: information: Include file: <fiwix/errno.h> not found. Please note: Cppcheck does not need standard library headers to get proper results. [missingIncludeSystem]
#include <fiwix/errno.h>
^
kernel/syscalls/semop.c:16:0: information: Include file: <fiwix/ipc.h> not found. Please note: Cppcheck does not need standard library headers to get proper results. [missingIncludeSystem]
#include <fiwix/ipc.h>
^
kernel/syscalls/semop.c:17:0: information: Include file: <fiwix/sem.h> not found. Please note: Cppcheck does not need standard library headers to get proper results. [missingIncludeSystem]
#include <fiwix/sem.h>
^
kernel/syscalls/semop.c:26:14: style: The scope of the variable 's' can be reduced. [variableScope]
 struct sem *s;
             ^
kernel/syscalls/semop.c:24:42: style: Parameter 'ss' can be declared as pointer to const [constParameterPointer]
static void semundo_ops(struct semid_ds *ss, struct sembuf *sops, int max)
                                         ^
kernel/syscalls/semop.c:20:0: information: Include file: <fiwix/stdio.h> not found. Please note: Cppcheck does not need standard library headers to get proper results. [missingIncludeSystem]
#include <fiwix/stdio.h>
^
kernel/syscalls/ipc.c:8:0: information: Include file: <fiwix/config.h> not found. Please note: Cppcheck does not need standard library headers to get proper results. [missingIncludeSystem]
#include <fiwix/config.h>
^
kernel/syscalls/ipc.c:9:0: information: Include file: <fiwix/types.h> not found. Please note: Cppcheck does not need standard library headers to get proper results. [missingIncludeSystem]
#include <fiwix/types.h>
^
kernel/syscalls/ipc.c:10:0: information: Include file: <fiwix/errno.h> not found. Please note: Cppcheck does not need standard library headers to get proper results. [missingIncludeSystem]
#include <fiwix/errno.h>
^
kernel/syscalls/ipc.c:11:0: information: Include file: <fiwix/process.h> not found. Please note: Cppcheck does not need standard library headers to get proper results. [missingIncludeSystem]
#include <fiwix/process.h>
^
kernel/syscalls/ipc.c:12:0: information: Include file: <fiwix/string.h> not found. Please note: Cppcheck does not need standard library headers to get proper results. [missingIncludeSystem]
#include <fiwix/string.h>
^
kernel/syscalls/ipc.c:13:0: information: Include file: <fiwix/ipc.h> not found. Please note: Cppcheck does not need standard library headers to get proper results. [missingIncludeSystem]
#include <fiwix/ipc.h>
^
kernel/syscalls/ipc.c:14:0: information: Include file: <fiwix/sem.h> not found. Please note: Cppcheck does not need standard library headers to get proper results. [missingIncludeSystem]
#include <fiwix/sem.h>
^
kernel/syscalls/ipc.c:15:0: information: Include file: <fiwix/msg.h> not found. Please note: Cppcheck does not need standard library headers to get proper results. [missingIncludeSystem]
#include <fiwix/msg.h>
^
kernel/syscalls/ipc.c:16:0: information: Include file: <fiwix/shm.h> not found. Please note: Cppcheck does not need standard library headers to get proper results. [missingIncludeSystem]
#include <fiwix/shm.h>
^
kernel/syscalls/ipc.c:32:36: style: Parameter 'perm' can be declared as pointer to const [constParameterPointer]
int ipc_has_perms(struct ipc_perm *perm, int mode)
                                   ^
kernel/syscalls/ipc.c:102:15: style: Variable 'arg' can be declared as pointer to const [constVariablePointer]
 union semun *arg;
              ^
kernel/syscalls/ipc.c:19:0: information: Include file: <fiwix/stdio.h> not found. Please note: Cppcheck does not need standard library headers to get proper results. [missingIncludeSystem]
#include <fiwix/stdio.h>
^
kernel/syscalls/ipc.c:25:0: style: The function 'ipc_init' is never used. [unusedFunction]
void ipc_init(void)
^
kernel/syscalls/ipc.c:94:0: style: The function 'sys_ipc' is never used. [unusedFunction]
int sys_ipc(unsigned int call, int first, int second, int third, void *ptr, long fifth)
^
kernel/syscalls/semop.c:35:0: style: The function 'semexit' is never used. [unusedFunction]
void semexit(void)
^
nofile:0:0: information: Active checkers: 143/592 (use --checkers-report=<filename> to see details) [checkersReport]

