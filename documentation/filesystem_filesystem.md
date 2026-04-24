# filesystem

Creates, enables, mounts, freezes, and unfreezes block, LVM, network, and
file-backed filesystems.

## Actions

| Action | Description |
| ------ | ----------- |
| `:create` | Creates a filesystem on the backing device. |
| `:enable` | Adds a filesystem mount entry to `/etc/fstab`. |
| `:mount` | Mounts the filesystem. |
| `:freeze` | Freezes a mounted filesystem with `fsfreeze`. |
| `:unfreeze` | Unfreezes a mounted filesystem with `fsfreeze`. |

## Properties

| Property | Type | Default | Description |
| -------- | ---- | ------- | ----------- |
| `label` | String | name property | Filesystem label. Maximum length is 12 characters. |
| `device` | String | `nil` | Device path to format or mount. |
| `vg` | String | `nil` | LVM volume group for logical volume backed filesystems. |
| `file` | String | `nil` | Backing file path for loopback filesystems. |
| `uuid` | String | `nil` | UUID used to resolve `/dev/disk/by-uuid/<uuid>`. |
| `fstype` | String | `'ext3'` | Filesystem type passed to `mkfs`. |
| `mkfs_options` | String | `''` | Extra options passed to `mkfs`. |
| `package` | String | `nil` | Comma-separated packages to install for this filesystem. |
| `recipe` | String | `nil` | Reserved for compatibility; recipes are not included by the resource. |
| `device_defer` | true, false | `false` | Skip work when the backing device does not exist. |
| `filesystem_tools` | Hash | built-in map | Default package and force-option map by filesystem type. |
| `sparse` | true, false | `true` | Create sparse backing files for file-backed filesystems. |
| `size` | String | `nil` | File-backed size in megabytes or LVM logical volume size. |
| `stripes` | Integer | `nil` | LVM stripe count. |
| `mirrors` | Integer | `nil` | LVM mirror count. |
| `mount` | String | `nil` | Mount point path. |
| `options` | String | `'defaults'` | Mount options for `/etc/fstab` and mounting. |
| `user` | String | `nil` | Owner for the mounted filesystem root directory. |
| `group` | String | `nil` | Group for the mounted filesystem root directory. |
| `mode` | String | `nil` | Mode for the mounted filesystem root directory. |
| `pass` | Integer | `0` | `/etc/fstab` pass value. |
| `dump` | Integer | `0` | `/etc/fstab` dump value. |
| `force` | true, false | `false` | Pass the filesystem-specific force option to `mkfs`. |
| `ignore_existing` | true, false | `false` | Recreate even when an existing filesystem is detected. |

## Examples

### Block Device Filesystem

```ruby
filesystem 'data' do
  device '/dev/sdb'
  mount '/data'
  fstype 'xfs'
  action [:create, :enable, :mount]
end
```

### File-Backed Filesystem

```ruby
filesystem 'filebacked' do
  file '/mnt/filesystem.img'
  device '/dev/loop7'
  mount '/mnt/filesystem'
  size '20000'
  action [:create, :enable, :mount]
end
```

### LVM-Backed Filesystem

```ruby
filesystem 'applv1' do
  vg 'standardvg'
  size '20G'
  mount '/logical1'
  fstype 'ext4'
  action [:create, :enable, :mount]
end
```
