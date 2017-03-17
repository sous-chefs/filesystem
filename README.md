# filesystem cookbook

[![Build Status](https://travis-ci.org/sous-chefs/filesystem.svg?branch=master)](https://travis-ci.org/sous-chefs/filesystem) [![Cookbook Version](https://img.shields.io/cookbook/v/filesystem.svg)](https://supermarket.chef.io/cookbooks/filesystem)

This cookbook exists to generically define and create block device filesystems with the minimum of inputs.

This cookbook supports four main types of block devices:

- normal `device` - drives, ssds, volumes presented by HBAs etc
- device ID `uuid` - mostly found on drives / known block IDs.
- LVM Volume Groups `vg` - found on systems using LVM.
- file-backed `file` - created dynamically and looped back.

We will try to create filesystems in two ways: through keys found in node data under 'filesystems' or by being called directly with the `filesystem` default provider. See the example recipe.

You can also use your own key for a list of filesystems, see the example recipe for an example of this option.

Tools have been listed in the following attribute key : filesystem_tools. This allows for extending the support to other/new filesystems.

Requirements
============

* lvm cookbook when creating logical volumes
* package #{fstype}progs to support your chosen fstype. We provide some defaults, too.

Main Attributes
===============

##### `filesystems`
Hash of filesytems to setup - this is called filesystems because filesystem is already created/managed by ohai (i.e. no s on the end).
##### `node[:filesystems]` keys:
Each filesytem's key is the FS `label`: This explains each key in a filesystems entry. The label must not exceed 12 characters.

We also let you use your own top-level key if you want - see the default recipe and example recipe.

Filesystem Backing Location keys
================================

##### `device`
Path to the device to create the filesystem upon.
##### `uuid`
UUID of the device to create the filesystem upon.
##### `file`
Path to the file-backed storage to be used for a loopback device. `device` must also be present to specify the loopback. If the `file` is not present it will be created, as long as a size is given.
##### `vg`
Name of the LVM volume group use as backing store for a logical volume. If not present it will be created, as long as a size is given.

Each filesystem should be given one of these attributes for it to have a location to be created at.

If none of these are present then we try to find a device at the label itself.

Filesystem Creation Options
===========================

##### `fstype` [ocfs2|ext3|ext4|etc] (default: ext3)
The type of filesystem to be created.
##### `mkfs_options` unique for each filesystem.
Options to pass to mkfs at creation time.

Filesystem Backing Options
==========================

##### `size` 10000 (`file`) or 10%VG|10g (`vg`)
The size, only used for filesystems backed by `vg` and `file` storage. If vg then a number suffixied by the scale [g|m|t|p], if a file then just a number [megabytes].
##### `sparse` Boolean (default: true)
Sparse file creation, used by the `file` storage, by default we use this for speed, but you may not want that.
##### `stripes` optional.
The stripes, only used for filesystems backed by `vg` aka LVM storage.
##### `mirrors` optional.
The mirrors, only used for filesystems backed by `vg` aka LVM storage.

Filesystem Mounting Options
===========================

##### `mount` /path/to/mount
Path to mount the filesystem. (If present we will mount the filesystem - this is rather important)
##### `options` rw,noatime,defaults (default: defaults)
Options to mount with and add to the fstab.
##### `dump` 0|1|2 (default: 0)
Dump entry for fstab
##### `pass` 0|1|2 (default: 0)
Pass entry for fstab
##### `user` name
Owner of the mountpoint, otherwise we use the chef default. We will not try to create users. You should use the users cookbook for that.
##### `group` name
Group of the mountpoint, otherwise we use the chef default. We will not try to create groups. You should write a cookbook to make them nicely.
##### `mode` 775
Mode of the mountpoint, otherwise we use the chef default.

Package and Recipe Options
==========================

##### `package` Package name to install, if specified.
Used to support the filesystem
##### `recipe` Recipe to run, if specified - for future use, not currently supported from the lwrp.
Used to support the filesystem

Atypical Behaviour Modifiers
============================

##### `force` Boolean (default: false)
Set to true we unsafely create filesystems. If there is data it will be lost. Should not use this unless you are quite confident.
##### `ignore_existing` Boolean (default: false)
Set to true we will ignore existing filesystems and recreate them. Double Dangerous and only for unsound behaviour. Use with 'force' true.
##### `nomkfs` Boolean (default: false)
Set to true to disable creation of the filesystem.
##### `nomount` Boolean (default: false)
Set to true to disable mounting of the filesystem.
##### `noenable` Boolean (default: false)
Set to true to disable adding to fstab.

Usage
=====

Keyed filesystem creation:

````JSON
{
 "filesystems": {
   "testfs1": {
     "device": "/dev/sdb",
     "mount": "/db",
     "fstype": "xfs",
     "optons": "noatime,nobarrier",
     "mkfs_options": "-d sunit=128,swidth=2048"
   },
   "applv1": {
     "mount": "/logical1",
     "fstype": "ext4",
     "vg": "standardvg",
     "size": "20G"
   },
   "cluster_01": {
     "fstype": "ocfs2",
     "package": "ocfs2-tools",
     "device": "/dev/mpath/ocfs01",
     "mount": "/mnt/test"
    },
   "filebacked": {
     "file": "/mnt/filesystem-on-a-filesystem.file",
     "device": "/dev/loop7",
     "mount": "/mnt/filesystem-on-a-filesystem",
     "size": "20000"
    }
  }
}
````

Direct LWRP'd creation:

````RUBY
filesystem "label" do
  fstype "ext3"
  device "/dev/sdb1"
  mount "/mnt/littlelabel"
  action [:create, :enable, :mount]
end
````

Links
=====

Development is at https://github.com/atrullmdsol/filesystem_cookbook
Opscode community page is at http://community.opscode.com/cookbooks/filesystem

Authors
=======

* Alex Trull <cookbooks.atrullmdsol@trull.org>
* Jesse Nelson <spheromak@gmail.com> source of the original cookbook.
