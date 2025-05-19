/*
 * fiwix/kernel/syscalls/exit.c
 *
 * Copyright 2018-2022, Jordi Sanfeliu. All rights reserved.
 * Distributed under the terms of the Fiwix License.
 */

#include <fiwix/asm.h>
#include <fiwix/kernel.h>
#include <fiwix/syscalls.h>
#include <fiwix/process.h>
#include <fiwix/sched.h>
#include <fiwix/mman.h>
#include <fiwix/sleep.h>
#include <fiwix/stdio.h>
#include <fiwix/string.h>
#include <fiwix/buffer.h>
#include <fiwix/filesystems.h>
#ifdef CONFIG_SYSVIPC
#include <fiwix/sem.h>
#endif /* CONFIG_SYSVIPC */

void do_exit(int exit_code)
{
	int n;
	struct proc *p, *init;

#ifdef __DEBUG__
	printk("\n");
	printk("sys_exit(pid %d, ppid %d)\n", current->pid, current->ppid->pid);
	printk("------------------------------\n");
#endif /*__DEBUG__ */

#ifdef CONFIG_SYSVIPC
	if(current->semundo) {
		semexit();
	}
#endif /* CONFIG_SYSVIPC */

	release_binary();
	current->argv = NULL;
	current->envp = NULL;

	init = &proc_table[INIT];
	FOR_EACH_PROCESS(p) {
		if(SESS_LEADER(current)) {
			if(p->sid == current->sid && p->state != PROC_ZOMBIE) {
				p->pgid = 0;
				p->sid = 0;
				p->ctty = NULL;
				send_sig(p, SIGHUP);
				send_sig(p, SIGCONT);
			}
		}

		/* make INIT inherit the children of this exiting process */
		if(p->ppid == current) {
			p->ppid = init;
			init->children++;
			current->children--;
			if(p->state == PROC_ZOMBIE) {
				send_sig(init, SIGCHLD);
				if(init->sleep_address == &sys_wait4) {
					wakeup_proc(init);
				}
			}
		}
		p = p->next;
	}

	if(SESS_LEADER(current)) {
		disassociate_ctty(current->ctty);
	}

	for(n = 0; n < OPEN_MAX; n++) {
		if(current->fd[n]) {
			sys_close(n);
		}
	}

	iput(current->root);
	current->root = NULL;
	iput(current->pwd);
	current->pwd = NULL;
	current->exit_code = exit_code;
	if(!--nr_processes) {
		printk("\n");
		printk("WARNING: the last user process has exited. The kernel will stop itself.\n");
		sync_superblocks(0);    /* in all devices */
		sync_inodes(0);         /* in all devices */
		sync_buffers(0);        /* in all devices */
		stop_kernel();
	}

	/* notify the parent about the child's death */
	p = current->ppid;
	send_sig(p, SIGCHLD);
	if(p->sleep_address == &sys_wait4) {
		wakeup_proc(p);
	}

	current->sigpending = 0;
	current->sigblocked = 0;
	current->sigexecuting = 0;
	for(n = 0; n < NSIG; n++) {
		current->sigaction[n].sa_mask = 0;
		current->sigaction[n].sa_flags = 0;
		current->sigaction[n].sa_handler = SIG_IGN;
	}

	not_runnable(current, PROC_ZOMBIE);
	do_sched();
}

int sys_exit(int exit_code)
{
#ifdef __DEBUG__
	printk("(pid %d) sys_exit()\n", current->pid);
#endif /*__DEBUG__ */

	/* exit code in the second byte.
	 *  15                8 7                 0
	 * +-------------------+-------------------+
	 * | exit code (0-255) |         0         |
	 * +-------------------+-------------------+
	 */
	do_exit((exit_code & 0xFF) << 8);
	return 0;
}
