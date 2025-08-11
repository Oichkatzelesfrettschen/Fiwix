Fiwix kernel parameters
=======================

The following is a list of the current kernel parameters:

bga=		Bochs Graphics Adapter resolution (width x height x bpp)
		Options: 640x480x32, 800x600x32, 1024x768x32

console=	Set the output console device.
		Options: /dev/tty[1..12], /dev/ttyS[0..3]
		Serial consoles have fixed settings: 9600,N,8,1

initrd=		Optional ramdisk image file which will be loaded by GRUB.

kexec_proto=	The boot method of the new kernel.
		Options: multiboot1, linux

kexec_size=	Size of the memory space to be reserved to allocate the new
		kernel (in KiB).

kexec_cmdline=	Command line to be passed to the new kernel (enclosed in double
		quotes).

ramdisksize=	Enable the RAM disk drive and configure its size (in KiB).

ro		Mount root device as read-only on boot.

root=		Root device name.
		Options: /dev/fd0, /dev/hda1, ...

rootfstype=	Set the root filesystem type.
		Options: ext2, minix, iso9660


Use -- to separate kernel parameters from arguments to init.

The kernel parses parameters from the kernel command line up to "--",
everything found after "--" is passed as an argument to init.

