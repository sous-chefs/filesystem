Description
===========

This cookbook exists to generically define and create filesystems with the minimum of inputs.

Requirements
============

* xfs cookbook when building xfs filesystems
* ocfs2 cookbook when creating ocfs2 filesystems
* lvm cookbook when creating logical volumes

Attributes
==========

#### `filesystems`  
Hash of filesytems to setup
## `node[:filesystems]` keys:
Each filesytem's key is the FS `label`: This explains each key in a filesystems entry. The label must not exceed 12 characters.

Filesystem Backing Location keys
================================

#### `device`
Path to the device to create the filesystem upon.
#### `uuid`
UUID of the device to create the filesystem upon.
#### `file`
Path to the file-backed storage to be used for a loopback device. If not present it will be created, as long as a size is given.
#### `vg`
Name of the LVM volume group use as backing store for a logical volume. If not present it will be created, as long as a size is given.

If none of these are present then we try to find a device at the label itself.

Filesystem Creation Options
===========================

#### `size`
The size, only used for filesystems backed by `vg` and `file` storage. If vg then a number suffixied by the scale [g|m|t|p], if a file then just a number [megabytes].
#### `fstype` [xfs|ocfs2|ext3|ext4|etc] (default: ext3)
The type of filesystem to be created.
#### `mkfs_options` unique for each filesystem.
Options to pass to mkfs at creation time.
#### `mount` /path/to/mount
Path to mount the filesystem. (If present we will create and mount the filesystem)
#### `options` rw,noatime,defaults (default: defaults)
Options to mount with and add to the fstab.
#### `dump` 0|1|2 (default: 0)
Dump entry for fstab
#### `pass` 0|1|2 (default: 0)
Pass entry for fstab
#### `owner` user name
Owner of the mountpoint, otherwise we use the chef default, if specified but not present on the system, we will create the user.
#### `group` group name
Group of the mountpoint, otherwise we use the chef default. if specified but not present on the system, we will create the group. 
#### `mode` 775
Mode of the mountpoint, otherwise we use the chef default.

Filesystem Package and Recipe Options
=====================================

#### `package` Package name to install, if specified.
Used to support the filesystem
#### `recipe` Recipe to run, if specified.
Used to support the filesystem

Atypical Behaviour Modifiers
============================

#### `force` Boolean (default: false)
Set to true, unsafely creates filesystems even if they already exist.
#### `mkstorage` Boolean (default: true)
Set to false to avoid creating logical volumes or file-backed storage.
#### `mkfs` Boolean (default: true)
Set to false to disable creation of the filesystem.
#### `domount` Boolean (default: true)
Set to false to disable mounting of the filesystem.
#### `modfstab` Boolean (default: true)
Set to false to disable adding to fstab.
#### `mkuser` Boolean (default: true)
Set to false to disable creation of users specified for mountpoint ownership.

Usage
=====

````JSON
{
 "filesystems": { 
   "testfs1": {
     "device": "/dev/sdb"
     "mount": "/db",
     "fstype", "xfs",
     "optons": "noatime,nobarrier",
     "mkfs_options": "-d sunit=128,swidth=2048"
   },
   "applv1": {
     "mount": "/logical1",
     "fstype", "ext4",
     "vg": "standardvg",
     "size": "20G"
   },
   "cluster_01": {
     "fstype": "ocfs2",
     "device": "/dev/mpath/ocfs01",
     "mount": "/mnt/test"
    },
   "filebacked": {
     "file": "/mnt/filesystem-on-a-filesystem.file",
     "mount": "/mnt/filesystem-on-a-filesystem",
     "modfstab": "false",
     "size": "20000"
    }
  }
}
````

Authors
=======

* Alex Trull <cookbooks.atrullmdsol@trull.org>
* Jesse Nelson <spheromak@gmail.com> source of the original cookbook.
