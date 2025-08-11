Fiwix kexec implementation
==========================
Kexec is a mechanism that let's you switch into a different kernel without
rebooting your machine. Its implementation in Fiwix differs from the Linux
kexec implementation because it doesn't need a system call nor specific
user-space tools, and your current system will completely shutdown before
jumping to the new kernel.

The new kernel can be another Fiwix kernel or any other ELF binary kernel as
long as it supports the Multiboot 1 Specification. It can also be a Linux Kernel
by using the Linux Boot protocol.

How it works
------------
Your system needs to know at boot-time that it might switch to a different
kernel. That is, you need to pass some special parameters in your kernel command
line during the system boot. The following are the three parameters that you
need to specify:

- kexec_proto=
  This is the boot method of the new kernel. Currently the supported values
  are 'multiboot1' and 'linux'.

- kexec_size=
  Size in KB of the memory space to be reserved to allocate the new kernel.

- kexec_cmdline=
  Command line to be passed to the new kernel (enclosed in double quotes).

Example of a kernel command line:
/boot/fiwix ro root=/dev/hda2 kexec_proto=multiboot1 kexec_size=500 \
kexec_cmdline="ro root=/dev/hda2"

The RAMdisk drives play an important role here. You already know that they can
be used to allocate an initrd image specified during the boot, or to allocate
one or more all-purpose RAMdisk drives. Now they are also used for kexec to
allocate the new kernel.

Kexec uses always the first unused RAMdisk drive. You'll know which one is the
first unused depending if you specified an initrd image, or if you specified to
have all-purpose RAMdisk drives at boot-time.

Fiwix is configured by default to have the following possible RAMdisk drives
layout:
	- If an initrd image was specified at boot-time then the first RAMdisk
	  drive is used for it (i.e: /dev/ram0).
	- If 'ramdisksize=' was specified at boot-time then the first unused
	  RAMDISK_DRIVES RAMdisk drives will be used.
	- If 'kexec_size=' was specified at boot-time then the first unused
	  RAMdisk drive will be used.

Let's see some examples to understand better these rules:

Example 1:
	- Kernel cmdline: "... ramdisksize=49152 initrd=/initrd.img"
	- Resulting RAMdisk drives layout:
		- /dev/ram0	-> initrd RAMdisk drive of 48MB (/ filesystem).
		- if RAMDISK_DRIVES == 1
			- /dev/ram1	-> all-purpose RAMdisk drive of 48MB.
		- if RAMDISK_DRIVES == 2
			- /dev/ram1	-> all-purpose RAMdisk drive of 48MB.
			- /dev/ram2	-> all-purpose RAMdisk drive of 48MB.
		...

Example 2:
	- Kernel cmdline: "... ramdisksize=16384"
	- Resulting RAMdisk drives layout:
		- if RAMDISK_DRIVES == 1
			- /dev/ram0	-> all-purpose RAMdisk drive of 16MB.
		- if RAMDISK_DRIVES == 2
			- /dev/ram0	-> all-purpose RAMdisk drive of 16MB.
			- /dev/ram1	-> all-purpose RAMdisk drive of 16MB.
		...

Example 3:
	- Kernel cmdline: "... ramdisksize=16384 kexec_size=500 ..."
	- Resulting RAMdisk drives layout:
		- if RAMDISK_DRIVES == 1
			- /dev/ram0	-> all-purpose RAMdisk drive of 16MB.
			- /dev/ram1	-> kexec RAMdisk drive of 500KB.
		- if RAMDISK_DRIVES == 2
			- /dev/ram0	-> all-purpose RAMdisk drive of 16MB.
			- /dev/ram1	-> all-purpose RAMdisk drive of 16MB.
			- /dev/ram2	-> kexec RAMdisk drive of 500KB.
		...


Multiboot
---------
Once you know what RAMdisk drive will be used to allocate the new kernel, you
can proceed to copy the ELF binary kernel into such RAMdisk drive by using a
common user-space tool like 'cp' or 'dd'.

Finally, when you are ready, just do a normal shutdown to switch automatically
to the new kernel.

Example:
# cp fiwix /dev/ram0
# shutdown -h 0


Linux
-----
In the case of Linux the boot protocol is different. The Linux kernel expects to
find two 32bit numbers (in little-endian format) at the beginning of the RAMdisk
drive. The first number is the length of the Linux kernel, and the second one is
the length of the initramfs. If the kernel doesn't need an initramfs, the length
must have a value of zero.

Right after both numbers you must copy the kernel image, and then the initramfs
image (if needed).

The RAMdisk drive should look like the following before to kexec:

+-----------+-----------+-------------------- ~~~ -+-------------------- ~~~ -+
| kernel    | initramfs |  the kernel image   ~~~ -|   the initramfs     ~~~ -|
| length    | length    |      'vmlinuz'      ~~~ -|   image (optional)  ~~~ -|
+-----------+-----------+-------------------- ~~~ -+-------------------- ~~~ -+
0            4           8                          n = (8 + kernel length)
offset (in bytes)


The following script might help you to format correctly the RAMdisk drive:

---------------------------------- 8< ----------------------------------------
KERNEL=linux-4.9.10
RAMFS=initramfs.cpio

size=$(printf "%08x" `stat -c %s $KERNEL` | tac -rs .. | echo "$(tr -d '\n')")
echo -n $size | xxd -r -p - /dev/ram0

if [ -n "$RAMFS" ]; then
        size=$(printf "%08x" `stat -c %s $RAMFS` | tac -rs .. | echo "$(tr -d '\n')")
else
        size=$(printf "%08x" `echo 0` | tac -rs .. | echo "$(tr -d '\n')")
fi
echo -n $size | xxd -r -p - | dd of=/dev/ram0 bs=1 seek=4

cat $KERNEL $RAMFS | dd of=/dev/ram0 bs=1 seek=8
---------------------------------- 8< ----------------------------------------

Finally, when you are ready, just do a normal shutdown to switch automatically
to the new kernel.

Example:
# shutdown -h 0

