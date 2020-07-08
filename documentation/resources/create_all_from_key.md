# Resource: filesystem_create_all_from_key

## Actions

| Action | Description           |
| ------ | --------------------- |
| create | Create multiple filesystems based on node attributes |

## Properties

### `name`

The resource looks in the node attribute for node[new_resource.name] or node['filesystems'].
The cookbook assumes with will find a hash with a key (label) and value of a hash filesystem resource properties.
Each label and set of filesystem properties is used to create a filesystem resource.

## Usage

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
