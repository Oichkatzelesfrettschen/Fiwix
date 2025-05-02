/*
 * fiwix/fs/super.c
 *
 * Copyright 2018-2022, Jordi Sanfeliu. All rights reserved.
 * Distributed under the terms of the Fiwix License.
 */

#include <fiwix/asm.h>
#include <fiwix/kernel.h>
#include <fiwix/kparms.h>
#include <fiwix/types.h>
#include <fiwix/errno.h>
#include <fiwix/fs.h>
#include <fiwix/stat.h>
#include <fiwix/filesystems.h>
#include <fiwix/sleep.h>
#include <fiwix/sched.h>
#include <fiwix/stdio.h>
#include <fiwix/string.h>
#include <fiwix/mm.h>

struct mount *mount_table = NULL;
static struct resource sync_resource = { 0, 0 };

void superblock_lock(struct superblock *sb)
{
	unsigned int flags;

	for(;;) {
		SAVE_FLAGS(flags); CLI();
		if(sb->state & SUPERBLOCK_LOCKED) {
			RESTORE_FLAGS(flags);
			sleep(sb, PROC_UNINTERRUPTIBLE);
		} else {
			break;
		}
	}
	sb->state |= SUPERBLOCK_LOCKED;
	RESTORE_FLAGS(flags);
}
 
void superblock_unlock(struct superblock *sb)
{
	unsigned int flags;

	SAVE_FLAGS(flags); CLI();
	sb->state &= ~SUPERBLOCK_LOCKED;
	wakeup(sb);
	RESTORE_FLAGS(flags);
}

struct mount *add_mount_point(__dev_t dev, const char *devname, const char *dirname)
{
	unsigned int flags;
	struct mount *mp;

	if(kstat.mount_points + 1 > NR_MOUNT_POINTS) {
		printk("WARNING: tried to exceed NR_MOUNT_POINTS (%d).\n", NR_MOUNT_POINTS);
		return NULL;
	}

	/* check if this device is already mounted */
	if(get_superblock(dev)) {
		return NULL;
	}

	if(!(mp = (struct mount *)kmalloc(sizeof(struct mount)))) {
		return NULL;
	}
	memset_b(mp, 0, sizeof(struct mount));

	if(!(mp->devname = (char *)kmalloc(strlen(devname) + 1))) {
		kfree((unsigned int)mp);
		return NULL;
	}
	if(!(mp->dirname = (char *)kmalloc(strlen(dirname) + 1))) {
		kfree((unsigned int)mp->devname);
		kfree((unsigned int)mp);
		return NULL;
	}

	SAVE_FLAGS(flags); CLI();
	if(!mount_table) {
		mount_table = mp;
	} else {
		mp->prev = mount_table->prev;
		mount_table->prev->next = mp;
	}
	mount_table->prev = mp;
	RESTORE_FLAGS(flags);

	mp->dev = dev;
	strcpy(mp->devname, devname);
	strcpy(mp->dirname, dirname);
	kstat.mount_points++;
	return mp;
}

void del_mount_point(struct mount *mp)
{
	unsigned int flags;
	struct mount *tmp;

	tmp = mp;

	if(!mp->next && !mp->prev) {
		printk("WARNING: %s(): trying to umount an unexistent mount point (%x, '%s', '%s').\n", __FUNCTION__, mp->dev, mp->devname, mp->dirname);
		return;
	}

	SAVE_FLAGS(flags); CLI();
	if(mp->next) {
		mp->next->prev = mp->prev;
	}
	if(mp->prev) {
		if(mp != mount_table) {
			mp->prev->next = mp->next;
		}
	}
	if(!mp->next) {
		mount_table->prev = mp->prev;
	}
	if(mp == mount_table) {
		mount_table = mp->next;
	}
	RESTORE_FLAGS(flags);

	kfree((unsigned int)tmp->devname);
	kfree((unsigned int)tmp->dirname);
	kfree((unsigned int)tmp);
	kstat.mount_points--;
}

struct mount *get_mount_point(struct inode *i)
{
	struct mount *mp;

	mp = mount_table;

	while(mp) {
		if(S_ISDIR(i->i_mode)) {
			if(mp->sb.root == i) {
				return mp;
			}
		}
		if(S_ISBLK(i->i_mode)) {
			if(mp->dev == i->rdev) {
				return mp;
			}
		}
		mp = mp->next;
	}

	return NULL;
}

struct superblock *get_superblock(__dev_t dev)
{
	struct mount *mp;

	mp = mount_table;

	while(mp) {
		if(mp->dev == dev) {
			return &mp->sb;
		}
		mp = mp->next;
	}
	return NULL;
}

void sync_superblocks(__dev_t dev)
{
	struct superblock *sb;
	struct mount *mp;
	int errno;

	mp = mount_table;

	lock_resource(&sync_resource);
	while(mp) {
		if(!dev || mp->dev == dev) {
			sb = &mp->sb;
			if((sb->state & SUPERBLOCK_DIRTY) && !(sb->flags & MS_RDONLY)) {
				if((errno = sb->fsop->write_superblock(sb))) {
					printk("WARNING: %s(): I/O error on device %d,%d while syncing superblock.\n", __FUNCTION__, MAJOR(sb->dev), MINOR(sb->dev));
				}
			}
		}
		mp = mp->next;
	}
	unlock_resource(&sync_resource);
}

/* pseudo-filesystems are only mountable by the kernel */
int kern_mount(__dev_t dev, struct filesystems *fs)
{
	struct mount *mp;

	if(!(mp = add_mount_point(dev, "none", "none"))) {
		return -EBUSY;
	}

	if(fs->fsop->read_superblock(dev, &mp->sb)) {
		del_mount_point(mp);
		return -EINVAL;
	}

	mp->sb.dir = NULL;
	mp->fs = fs;
	fs->mp = mp;
	return 0;
}

int mount_root(void)
{
	struct filesystems *fs;
	struct mount *mp;

	/*
	 * FIXME: before trying to mount the filesystem, we should first
	 * check if '_rootdev' is a device successfully registered.
	 */

	if(!kparms.rootdev) {
		PANIC("root device not defined.\n");
	}

	if(!(fs = get_filesystem(kparms.rootfstype))) {
		printk("WARNING: %s(): '%s' is not a registered filesystem. Defaulting to 'ext2'.\n", __FUNCTION__, kparms.rootfstype);
		if(!(fs = get_filesystem("ext2"))) {
			PANIC("ext2 filesystem is not registered!\n");
		}
	}

	if(!(mp = add_mount_point(kparms.rootdev, "/dev/root", "/"))) {
		PANIC("unable to get a free mount point.\n");
	}

	if(kparms.ro) {
		mp->sb.flags = MS_RDONLY;
	}
	if(fs->fsop->read_superblock(kparms.rootdev, &mp->sb)) {
		PANIC("unable to mount root filesystem on %s.\n", kparms.rootdevname);
	}

	mp->sb.root->mount_point = mp->sb.root;
	mp->sb.root->count++;
	mp->sb.dir = mp->sb.root;
	mp->sb.dir->count++;
	mp->fs = fs;

	current->root = mp->sb.root;
	current->root->count++;
	current->pwd = mp->sb.root;
	current->pwd->count++;
	iput(mp->sb.root);

	printk("mounted root device (%s filesystem)", fs->name);
	if(mp->sb.flags & MS_RDONLY) {
		printk(" in readonly mode");
	}
	printk(".\n");
	return 0;
}
