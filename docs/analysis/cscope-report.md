# Cscope Symbol Report

```
include/fiwix/sem.h <global> 106 int sys_semop(int , struct sembuf *, int );
kernel/syscalls/ipc.c sys_ipc 177 return sys_semop(args->arg1, args->ptr, args->arg2);
kernel/syscalls/semop.c sys_semop 73 int sys_semop(int semid, struct sembuf *sops, int nsops)
kernel/syscalls.c <global> 315 sys_ipc,
include/fiwix/syscalls.h unknown 145 int sys_ipc(unsigned int , struct sysvipc_args *);
kernel/syscalls/ipc.c sys_ipc 94 int sys_ipc(unsigned int call, int first, int second, int third, void *ptr, long fifth)
kernel/syscalls/ipc.c sys_ipc 162 int sys_ipc(unsigned int call, struct sysvipc_args *args)

```
