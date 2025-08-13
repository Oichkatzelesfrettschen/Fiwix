# Ctags Cross-Reference

```
GETALL           macro        18 include/fiwix/sem.h #define GETALL 13 /* get all semval's */
GETNCNT          macro        19 include/fiwix/sem.h #define GETNCNT 14 /* get semncnt */
GETPID           macro        16 include/fiwix/sem.h #define GETPID 11 /* get sempid */
GETVAL           macro        17 include/fiwix/sem.h #define GETVAL 12 /* get semval */
GETZCNT          macro        20 include/fiwix/sem.h #define GETZCNT 15 /* get semzcnt */
SEMMNI           macro        25 include/fiwix/sem.h #define SEMMNI 128 /* number of semaphores sets */
SEMMNS           macro        27 include/fiwix/sem.h #define SEMMNS (SEMMNI*SEMMSL) /* max. number of messages in system */
SEMMSL           macro        26 include/fiwix/sem.h #define SEMMSL 32 /* max. number of semaphores per id */
SEMOPM           macro        28 include/fiwix/sem.h #define SEMOPM 32 /* max. number of ops. per semop() */
SEMVMX           macro        29 include/fiwix/sem.h #define SEMVMX 32767 /* semaphore maximum value */
SEM_INFO         macro        32 include/fiwix/sem.h #define SEM_INFO 19
SEM_STAT         macro        31 include/fiwix/sem.h #define SEM_STAT 18
SEM_UNDO         macro        13 include/fiwix/sem.h #define SEM_UNDO 0x1000 /* undo the operation on exit */
SETALL           macro        22 include/fiwix/sem.h #define SETALL 17 /* set all semval's */
SETVAL           macro        21 include/fiwix/sem.h #define SETVAL 16 /* set semval */
_FIWIX_SEM_H     macro         8 include/fiwix/sem.h #define _FIWIX_SEM_H
__buf            member       57 include/fiwix/sem.h struct seminfo *__buf; /* buffer for IPC_INFO */
array            member       56 include/fiwix/sem.h unsigned short int *array; /* array for GETALL & SETALL */
buf              member       55 include/fiwix/sem.h struct semid_ds *buf; /* buffer for IPC_STAT & IPC_SET */
id_next          member       85 include/fiwix/sem.h struct sem_undo *id_next; /* next entry on this semaphore set */
ipc_has_perms    function     32 kernel/syscalls/ipc.c int ipc_has_perms(struct ipc_perm *perm, int mode)
ipc_init         function     25 kernel/syscalls/ipc.c void ipc_init(void)
ipc_kludge       struct       97 kernel/syscalls/ipc.c struct ipc_kludge {
ipcmsg_resource  variable     23 kernel/syscalls/ipc.c struct resource ipcmsg_resource = { 0, 0 };
msgp             member       98 kernel/syscalls/ipc.c struct msgbuf *msgp;
msgtyp           member       99 kernel/syscalls/ipc.c long msgtyp;
proc_next        member       84 include/fiwix/sem.h struct sem_undo *proc_next; /* next entry on this process */
sem              struct       75 include/fiwix/sem.h struct sem {
sem_base         member       38 include/fiwix/sem.h struct sem *sem_base; /* ptr to the first semaphore in set */
sem_ctime        member       37 include/fiwix/sem.h __time_t sem_ctime; /* time of the last change */
sem_flg          member       49 include/fiwix/sem.h short int sem_flg; /* operation flags */
sem_nsems        member       42 include/fiwix/sem.h unsigned short int sem_nsems; /* number of semaphores in set */
sem_num          member       47 include/fiwix/sem.h unsigned short int sem_num; /* semaphore number */
sem_num          member       88 include/fiwix/sem.h unsigned short int sem_num; /* semaphore number */
sem_op           member       48 include/fiwix/sem.h short int sem_op; /* semaphore operation */
sem_otime        member       36 include/fiwix/sem.h __time_t sem_otime; /* time of the last semop() */
sem_perm         member       35 include/fiwix/sem.h struct ipc_perm sem_perm; /* access permissions */
sem_undo         struct       83 include/fiwix/sem.h struct sem_undo {
semadj           member       87 include/fiwix/sem.h short int semadj; /* adjustment during exit() */
semaem           member       71 include/fiwix/sem.h int semaem;
sembuf           struct       46 include/fiwix/sem.h struct sembuf {
semexit          function     35 kernel/syscalls/semop.c void semexit(void)
semid            member       86 include/fiwix/sem.h int semid; /* semaphore set identifier */
semid_ds         struct       34 include/fiwix/sem.h struct semid_ds {
seminfo          struct       61 include/fiwix/sem.h struct seminfo {
semmap           member       62 include/fiwix/sem.h int semmap;
semmni           member       63 include/fiwix/sem.h int semmni;
semmns           member       64 include/fiwix/sem.h int semmns;
semmnu           member       65 include/fiwix/sem.h int semmnu;
semmsl           member       66 include/fiwix/sem.h int semmsl;
semncnt          member       78 include/fiwix/sem.h short int semncnt; /* nprocs awaiting increase in semval */
semopm           member       67 include/fiwix/sem.h int semopm;
sempid           member       77 include/fiwix/sem.h short int sempid; /* pid of last operation */
semume           member       68 include/fiwix/sem.h int semume;
semun            union        53 include/fiwix/sem.h union semun {
semundo_ops      function     24 kernel/syscalls/semop.c static void semundo_ops(struct semid_ds *ss, struct sembuf *sops, int max)
semusz           member       69 include/fiwix/sem.h int semusz;
semval           member       76 include/fiwix/sem.h short int semval; /* current value */
semvmx           member       70 include/fiwix/sem.h int semvmx;
semzcnt          member       79 include/fiwix/sem.h short int semzcnt; /* nprocs awaiting semval = 0 */
sys_ipc          function     94 kernel/syscalls/ipc.c int sys_ipc(unsigned int call, int first, int second, int third, void *ptr, long fifth)
sys_semop        function     73 kernel/syscalls/semop.c int sys_semop(int semid, struct sembuf *sops, int nsops)
undo             member       41 include/fiwix/sem.h struct sem_undo *undo; /* list of undo requests */
unused1          member       39 include/fiwix/sem.h unsigned int unused1;
unused2          member       40 include/fiwix/sem.h unsigned int unused2;
val              member       54 include/fiwix/sem.h int val; /* value for SETVAL */

```
