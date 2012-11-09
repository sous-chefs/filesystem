Description
-----------
This is verry old code that I am extneralizing. My hope is to refactor alot of it to more digestable providers, and to leverage the LWRP for LVM. 

Create mount and add to fstab filesystems defined from attributes by default filesystems will be created, added to the fstab and mounted. Unless atribs are set to tell it otherwise

Currently there is no remove or delete options for filesystems.  

Requirements
------------
* xfs cookbook when building xfs filesystems
* ocfs2 cookbook when creating ocfs2 filesystems

Aattributes
-----------
#### `filesystem_bag` 
   Data bag to look for `node[:fqdn]` item describing this nodes filesystems
#### `filesystems`   
  Hash of filesytems to setup

## `node[:filesystems]` keys:
Each Filesytem's key is the FS `Label`: This explains each key in a filesystem entry
#### `vg`      
    name of the Volume group to create this under
#### `uuid`
    used the disk uuid to identify what disk to make this on 
#### `device` 
    path to the device 
#### `type`  - _xfs|ocfs2|ext3|ext4   (default: xfs)_
#### `size`  
  size paramater as would be passed to lvcrate -l ( XX[g|m|t|p] )  only needed when vg is specified. and we want the lv created.
#### `mkfs_options`  
  Options to pass to mkfs.xfs (defaults to xfs atm)
#### `mount_options`  
  Options to add to the mount command (also added to fstab)
#### `mount_point`  
  Where to mount this filesystem. (will mkdir -p first)
#### `mount` - _Boolean  (default: true)_
  mount this fs ? 
#### `mkfs`  - _Boolean  (default: true)_ 
  make the filesystem or not
#### `fstab` -  _Boolean  (default: true)_
  Add entry to fstab 
#### `make_lv` - _Boolean  (default: true)_
  create logical volume 


# USAGE

role some_role.json:
      {
        "override_attributes": {
          "filesystems": {  
            "db": {
              "vg": "vg01",   
              "size": "50g",
              "mount_point": "/db",
              "mount_optons": "noatime, nobarrier",
              "mkfs_options": "-d sunit=128,swidth=2048"
            },
            "cluster_01": {
              "type": "ocfs2",
              "device": "/dev/mpath/ocfs01",
              "mount_point": "/mnt/test"
            }
          }
        }
      }


This creates 2 filesystems one thats /dev/vg01/db and one thats an ocfs2 volume from multipath named device ocfs01 

the Logical volume for db will be created from volume group vg01 if it doesn't already exists this lv will the be formated as xfs with d sunit=128,swidth=2048 options, and mounted on /db  (added to fstab etc etc)


