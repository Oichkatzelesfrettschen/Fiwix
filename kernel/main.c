/*
 * fiwix/kernel/main.c
 *
 * Copyright 2018-2023, Jordi Sanfeliu. All rights reserved.
 * Distributed under the terms of the Fiwix License.
 */

#include <fiwix/asm.h>
#include <fiwix/kernel.h>
#include <fiwix/limits.h>
#include <fiwix/kparms.h>
#include <fiwix/fs.h>
#include <fiwix/system.h>
#include <fiwix/version.h>
#include <fiwix/utsname.h>
#include <fiwix/stdio.h>
#include <fiwix/string.h>
#include <fiwix/video.h>
#include <fiwix/console.h>
#include <fiwix/pci.h>
#include <fiwix/pic.h>
#include <fiwix/irq.h>
#include <fiwix/segments.h>
#include <fiwix/devices.h>
#include <fiwix/buffer.h>
#include <fiwix/cpu.h>
#include <fiwix/timer.h>
#include <fiwix/sleep.h>
#include <fiwix/locks.h>
#include <fiwix/ps2.h>
#include <fiwix/keyboard.h>
#include <fiwix/sched.h>
#include <fiwix/mm.h>
#include <fiwix/ipc.h>
#include <fiwix/kexec.h>
#include <fiwix/sysconsole.h>

struct kernel_params kparms;
struct kernel_stat kstat;
unsigned int _last_data_addr;

struct new_utsname sys_utsname = {
	UTS_SYSNAME,
	UTS_NODENAME,
	UTS_RELEASE,
	UTS_VERSION,
	"",
	UTS_DOMAINNAME,
};

static void set_default_values(void)
{
	/* filesystem is ext2 */
	if(!kparms.rootfstype[0]) {
		strcpy(kparms.rootfstype, "ext2");
	}

	/* console is /dev/tty0 */
	if(!kparms.syscondev) {
		kparms.syscondev = MKDEV(VCONSOLES_MAJOR, 0);
		add_sysconsoledev(kparms.syscondev);
	}
}

void start_kernel(unsigned int magic, unsigned int info, unsigned int last_boot_addr)
{
	struct proc *init;

	_last_data_addr = last_boot_addr - PAGE_OFFSET;
	memset_b(&kstat, 0, sizeof(kstat));
	sysconsole_init();

#ifdef CONFIG_QEMU_DEBUGCON
	if(inport_b(QEMU_DEBUG_PORT) == QEMU_DEBUG_PORT) {
		kstat.flags |= KF_HAS_DEBUGCON;
	}
#endif /* CONFIG_QEMU_DEBUGCON */

	printk("                    Fiwix kernel v%s for i386 architecture\n", UTS_RELEASE);
	printk("                     Copyright (c) 2018-2024, Jordi Sanfeliu\n");
	printk("\n");
#ifdef __TINYC__
	printk("             (built on %s with tcc)\n", UTS_VERSION);
#else
	printk("             (built on %s with GCC %s)\n", UTS_VERSION, __VERSION__);
#endif
	printk("\n");
	printk("DEVICE    ADDRESS         IRQ   COMMENT\n");
	printk("--------------------------------------------------------------------------------\n");

	cpu_init();
	multiboot(magic, info);
	set_default_values();
	pic_init();
	irq_init();
	idt_init();
	dev_init();
	tty_init();
	mem_init();

#ifdef CONFIG_PCI
	pci_init();
#endif /* CONFIG_PCI */

	video_init();
	console_init();
	timer_init();
	ps2_init();
	proc_init();
	sleep_init();
	buffer_init();
	sched_init();
	inode_init();
	fd_init();

#ifdef CONFIG_SYSVIPC
	ipc_init();
#endif /* CONFIG_SYSVIPC */

#ifdef CONFIG_NET
	net_init();
#endif /* CONFIG_NET */

	/*
	 * IDLE is now the current process (created manually as PID 0),
	 * it won't be placed in the running queue.
	 */
	current = get_proc_free();
	proc_slot_init(current);
	set_tss(current);
	load_tr(TSS);
	current->tss.cr3 = V2P((unsigned int)kpage_dir);
	current->flags |= PF_KPROC;
	sprintk(current->argv0, "%s", "idle");

	/* PID 1 is for the INIT process */
	init = get_proc_free();
	proc_slot_init(init);
	init->pid = get_unused_pid();

	kernel_process("kswapd", kswapd);	/* PID 2 */
	kernel_process("kbdflushd", kbdflushd);	/* PID 3 */

	/* kswapd will take over the rest of the kernel initialization */
	need_resched = 1;

	STI();		/* let's rock! */
	cpu_idle();
}

void stop_kernel(void)
{
	struct proc *p, *next;
	int n;

	/* put all processes to sleep and reset all pending signals */
	FOR_EACH_PROCESS_RUNNING(p) {
		next = p->next_run;
		not_runnable(p, PROC_SLEEPING);
		p->sigpending = 0;
		p = next;
	}

#ifdef CONFIG_KEXEC
	if(!(kstat.flags & KF_HAS_PANICKED)) {
		if(kexec_size > 0) {
			switch(kexec_proto) {
				case KEXEC_MULTIBOOT1:
					kexec_multiboot1();
					break;
				case KEXEC_LINUX:
					kexec_linux();
					break;
			}
		}
	}
#endif /* CONFIG_KEXEC */

	printk("\n");
	printk("**    Safe to Power Off    **\n");
	printk("            -or-\n");
	printk("** Press Any Key to Reboot **\n");
	any_key_to_reboot = 1;

	/* stop and disable all interrupts! */
	CLI();
	for(n = 0; n < NR_IRQS; n++) {
		disable_irq(n);
	}

	/* enable keyboard only */
	enable_irq(KEYBOARD_IRQ);
	STI();

	cpu_idle();
}

void cpu_idle()
{
	for(;;) {
		if(need_resched) {
			do_sched();
		}
		HLT();
	}
}
