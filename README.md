# filesystem cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/filesystem.svg)](https://supermarket.chef.io/cookbooks/filesystem)
[![CI State](https://github.com/sous-chefs/filesystem/workflows/ci/badge.svg)](https://github.com/sous-chefs/filesystem/actions?query=workflow%3Aci)
[![OpenCollective](https://opencollective.com/sous-chefs/backers/badge.svg)](#backers)
[![OpenCollective](https://opencollective.com/sous-chefs/sponsors/badge.svg)](#sponsors)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](https://opensource.org/licenses/Apache-2.0)

This cookbook exists to generically define and create block device filesystems with the minimum of inputs.

This cookbook supports four main types of block devices:

- normal `device` - drives, SSDs, volumes presented by HBAs etc
- device ID `uuid` - mostly found on drives / known block IDs.
- LVM Volume Groups `vg` - found on systems using LVM.
- file-backed `file` - created dynamically and looped back.

We will try to create filesystems in two ways: through keys found in node data under 'filesystems' or by being called directly with the `filesystem` default provider. See the example recipe.

You can also use your own key for a list of filesystems, see the example recipe for an example of this option.

Tools have been listed in the following attribute key : filesystem_tools. This allows for extending the support to other/new filesystems.

Network file systems, nfs and others, are somewhat supported. This cookbook will attempt to create a mount point, enable the filesystem by adding an `/etc/fstab` entry for the filesystem mount and will attempt to mount the filesystem.  This cookbook does not attempt to modify the internal contents of network filesystems.

## Maintainers

This cookbook is maintained by the Sous Chefs. The Sous Chefs are a community of Chef cookbook maintainers working together to maintain important cookbooks. If you’d like to know more please visit [sous-chefs.org](https://sous-chefs.org/) or come chat with us on the Chef Community Slack in [#sous-chefs](https://chefcommunity.slack.com/messages/C2V7B88SF).

## Requirements

- lvm cookbook when creating logical volumes
- package #{fstype}progs to support your chosen fstype. We provide some defaults, too.

## Resources

- [filesystem_create_all_from_key](https://github.com/sous-chefs/filesystem/blob/master/documentation/resources/create_all_from_key.md) - Create a filesystem, add a definition to fstab, mount the filesystem
- [filesystem](https://github.com/sous-chefs/filesystem/blob/master/documentation/resources/filesystem.md) - Create a filesystem, add a definition to fstab, mount the filesystem
- [filesystem_filebacked](https://github.com/sous-chefs/filesystem/blob/master/documentation/resources/filebacked.md) - Create a loopback filesystem

## Main Attributes

### `filesystems`

Hash of filesytems to setup - this is called filesystems because filesystem is already created/managed by ohai (i.e. no s on the end).

### `node[:filesystems]` keys

Each filesytem's key is the FS `label`: This explains each key in a filesystems entry. The label must not exceed 12 characters.

We also let you use your own top-level key if you want - see the default recipe and example recipe.

## Usage

Keyed filesystem creation:

````JSON
{
 "filesystems": {
   "testfs1": {
     "device": "/dev/sdb",
     "mount": "/db",
     "fstype": "xfs",
     "options": "noatime,nodev",
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

## Authors

- Alex Trull <cookbooks.atrullmdsol@trull.org>
- Jesse Nelson <spheromak@gmail.com> source of the original cookbook.

## Contributors

This project exists thanks to all the people who [contribute.](https://opencollective.com/sous-chefs/contributors.svg?width=890&button=false)

### Backers

Thank you to all our backers!

![https://opencollective.com/sous-chefs#backers](https://opencollective.com/sous-chefs/backers.svg?width=600&avatarHeight=40)

### Sponsors

Support this project by becoming a sponsor. Your logo will show up here with a link to your website.

![https://opencollective.com/sous-chefs/sponsor/0/website](https://opencollective.com/sous-chefs/sponsor/0/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/1/website](https://opencollective.com/sous-chefs/sponsor/1/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/2/website](https://opencollective.com/sous-chefs/sponsor/2/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/3/website](https://opencollective.com/sous-chefs/sponsor/3/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/4/website](https://opencollective.com/sous-chefs/sponsor/4/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/5/website](https://opencollective.com/sous-chefs/sponsor/5/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/6/website](https://opencollective.com/sous-chefs/sponsor/6/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/7/website](https://opencollective.com/sous-chefs/sponsor/7/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/8/website](https://opencollective.com/sous-chefs/sponsor/8/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/9/website](https://opencollective.com/sous-chefs/sponsor/9/avatar.svg?avatarHeight=100)
