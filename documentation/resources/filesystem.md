# Resource: filesystem

## Actions

| Action | Description           |
| ------ | --------------------- |
| create | Create a filesystem on a device |
| enable  | Add an entry for the filesystem mount to /etc/fstab |
| mount  | Mount the filesystem on a directory mount point |
| freeze  | Use fsfreeze to lock a filesystem |
| unfreeze  | Use fsfreeze to unlock a filesystem |

## Properties

### `label`

Each filesytem's key is the FS `label`: The label must not exceed 12 characters.

## Filesystem Backing Location keys

### `device`

Path to the device to create the filesystem upon.

### `uuid`

UUID of the device to create the filesystem upon.

### `file`

Path to the file-backed storage to be used for a loopback device. `device` must also be present to specify the loopback. If the `file` is not present it will be created, as long as a size is given.

### `vg`

Name of the LVM volume group use as backing store for a logical volume. If not present it will be created, as long as a size is given.

Each filesystem should be given one of these attributes for it to have a location to be created at.

If none of these are present then we try to find a device at the label itself.

## Filesystem Creation Options

### `fstype`

  [ocfs2|ext3|ext4|etc] (default: ext3). The type is not verified.

The type of filesystem to be created.

### `mkfs_options` unique for each filesystem

Options to pass to mkfs at creation time.

## Filesystem Backing Options

### `size` 10000 (`file`) or 10%VG|10g (`vg`)

The size, only used for filesystems backed by `vg` and `file` storage. If vg then a number suffixied by the scale [g|m|t|p], if a file then just a number [megabytes].

### `sparse` Boolean (default: true)

Sparse file creation, used by the `file` storage, by default we use this for speed, but you may not want that.

### `stripes` optional

The stripes, only used for filesystems backed by `vg` aka LVM storage.

### `mirrors` optional

The mirrors, only used for filesystems backed by `vg` aka LVM storage.

## Filesystem Mounting Options

### `mount` /path/to/mount

Path to mount the filesystem. (If present we will mount the filesystem - this is rather important)

### `options` rw,noatime,defaults (default: defaults)

Options to mount with and add to the fstab.

### `dump` 0|1|2 (default: 0)

Dump entry for fstab

### `pass` 0|1|2 (default: 0)

Pass entry for fstab

### `user` name

Owner of the root directory of the filesystem, otherwise we use the chef default. We will not try to create users. You should use the users cookbook for that.

### `group` name

Group of the root directory of the filesystem, otherwise we use the chef default. We will not try to create groups. You should write a cookbook to make them nicely.

### `mode` 775

Mode of the root directory of the filesystem, otherwise we use the chef default.

## Package and Recipe Options

### `package` Package name to install, if specified

Used to support the filesystem

### `recipe` Recipe to run, if specified - for future use, not currently supported from the custom resource

Used to support the filesystem

## Atypical Behaviour Modifiers

### `device_defer` Skip file system creation if the backing device does not exist. Defaults to false

### `force` Boolean (default: false)

Set to true we unsafely create filesystems. If there is data it will be lost. Should not use this unless you are quite confident.

### `ignore_existing` Boolean (default: false)

Set to true we will ignore existing filesystems and recreate them. Double Dangerous and only for unsound behaviour. Use with 'force' true.

### `nomkfs` Boolean (default: false)

Set to true to disable creation of the filesystem.

### `nomount` Boolean (default: false)

Set to true to disable mounting of the filesystem.

### `noenable` Boolean (default: false)

Set to true to disable adding to fstab.

## Usage

Filesystem creation:

````RUBY
filesystem "label" do
  fstype "ext3"
  device "/dev/sdb1"
  mount "/mnt/littlelabel"
  action [:create, :enable, :mount]
end
````
