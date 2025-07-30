Fiwix
=====
Fiwix is an operating system kernel written from scratch, based on the UNIX architecture and fully focused on being POSIX compatible. It is designed and developed mainly as a hobby OS and, since it serves also for educational purposes, the kernel code is kept as simple as possible for the benefit of students and OS enthusiasts. It is small in size (less than 50K lines of code), runs on the i386 hardware platform and is compatible with a good base of existing GNU applications.

Features
--------
 - Written in ANSI C language (Assembly used only in the needed parts).
 - GRUB Multiboot Specification v1 compliant.
 - Full 32bit protected mode non-preemptive kernel.
 - For i386 processors and higher.
 - Preemptive multitasking.
 - POSIX-compliant (mostly).
 - Process groups, sessions and job control.
 - Interprocess communication with pipes, signals and UNIX-domain sockets.
 - UNIX System V IPC (semaphores, message queues and shared memory).
 - BSD file locking mechanism (POSIX restricted to file and advisory only).
 - Virtual memory splits (user/kernel): 3GB/1GB and 2GB/2GB.
 - Demand paging with Copy-On-Write feature.
 - Linux 2.0 ABI system calls compatibility (mostly).
 - ELF-i386 executable format support (statically and dynamically linked).
 - Round Robin based scheduler algorithm (no priorities yet).
 - VFS abstraction layer.
 - Kexec support with Multiboot Specification v1 and Linux boot protocols.
 - EXT2 filesystem support with 1KB, 2KB and 4KB block sizes.
 - Minix v1 and v2 filesystem support.
 - Linux-like PROC filesystem support (read only).
 - PIPE pseudo-filesystem support.
 - ISO9660 filesystem support with Rock Ridge extensions.
 - RAMdisk device support.
 - Initial RAMdisk (initrd) image support.
 - SVGAlib based applications support.
 - PCI local bus support.
   - QEMU PCI serial device support.
   - QEMU/Bochs Graphics Adapter support.
   - Intel PIIX3 PCI ISA IDE controller.
 - UNIX98 pseudoterminals (pty) support.
 - Virtual consoles support (up to 12).
 - Keyboard driver with Linux keymaps support.
 - PS/2 mouse support.
 - Framebuffer device support for VESA VBE 2.0+ compliant graphic cards.
 - Framebuffer console (fbcon) support.
 - Serial port (RS-232) driver support.
 - Remote serial console support.
 - QEMU Bochs-style debug console support.
 - Parallel port printer driver support.
 - Basic implementation of a Pseudo-Random Number Generator.
 - Floppy disk device driver and DMA management.
 - IDE/ATA ATAPI CD-ROM device driver.
 - IDE/ATA hard disk device driver.

Compiling
---------
The command needed to build the Fiwix kernel is `./build.sh clean && ./build.sh`.  This will create the files **fiwix** (the kernel itself) and **System.map.gz** (the symbol table) in the root directory of the source code tree.

Before compiling you might want to tweak the kernel configuration by changing the default values in `include/fiwix/config.h` and `include/fiwix/limits.h`.

Keep in mind that the kernel doesn't do anything on its own, you need to create a user-space environment to make use of it. Upon booting, the kernel mounts the root filesystem and tries to run `/sbin/init` on it, so you would need to provide this program yourself.  Fortunately, [FiwixOS](https://www.fiwix.org/downloads.html) provides a full user-space UNIX-like environment to test the Fiwix kernel.

Installing
----------
You can proceed to install FiwixOS on a hard disk either by booting from the CD-ROM or from a floppy. If you chosen the latter, you will also need the Installation CD-ROM inserted in order to install the packages that form all the system environment.

Let the system boot and when you are ready, just type `install.sh`.

The minimal hardware requirements are as follows:

 - Standard IBM PC-AT architecture.
 - i386 processor (with floating-point processor).
 - 4MB of RAM memory (128MB recommended).
 - IDE/ATAPI CD-ROM or floppy disk (3.5", 1.44MB).
 - 1GB ATA hard disk.

Please keep in mind that this is a kernel in its very early stages and may well have serious bugs and broken features which have not yet been identified or resolved.

Let me repeat that.

Please keep in mind that this is a kernel in its very early stages and may well have serious bugs and broken features which have not yet been identified or resolved.

			*****************************
			*** USE AT YOUR OWN RISK! ***
			*****************************

References
----------
- [Website](https://www.fiwix.org)
- [IRC](https://web.libera.chat/)
- [Mailing List](https://lists.sourceforge.net/lists/listinfo/fiwix-general)

License
-------
Fiwix is free software licensed under the terms of the MIT License, see the LICENSE file for more details.  
Copyright (C) 2018-2024, Jordi Sanfeliu.

Credits
-------
Fiwix was created by [Jordi Sanfeliu](https://www.fibranet.cat).  
You can contact me at [jordi@fibranet.cat](mailto:jordi@fibranet.cat).
See also the CREDITS file.

