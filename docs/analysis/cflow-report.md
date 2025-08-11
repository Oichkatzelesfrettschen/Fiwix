sys_semop() <int sys_semop (int semid, struct sembuf *sops, int nsops) at kernel/syscalls/semop.c:73>:
    printk()
    check_user_area()
    ipc_has_perms() <int ipc_has_perms (struct ipc_perm *perm, int mode) at kernel/syscalls/ipc.c:32>:
    semundo_ops() <void semundo_ops (struct semid_ds *ss, struct sembuf *sops, int max) at kernel/syscalls/semop.c:24>
    wakeup()
    sleep()
    sem_get_new_su()
