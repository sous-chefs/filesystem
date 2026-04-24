# Migration Guide

## Overview

This release completes the migration to custom resources. Top-level cookbook
`attributes/` and `recipes/` are removed. Consumers should declare resources from
their own wrapper cookbooks instead of including `filesystem::default` or setting
cookbook default attributes.

## Old Recipe and Attribute Usage

Previously, a run list could include:

```ruby
include_recipe 'filesystem'
```

The default recipe installed some platform packages, included the `lvm` cookbook,
and read filesystem definitions from `node['filesystems']`.

Filesystem definitions were commonly supplied as attributes:

```json
{
  "filesystems": {
    "testfs1": {
      "device": "/dev/sdb",
      "mount": "/db",
      "fstype": "xfs",
      "options": "noatime,nodev"
    }
  }
}
```

Default filesystem tool packages were also supplied by
`node['filesystem_tools']`.

## New Resource API

Call the custom resources directly from your wrapper cookbook recipes.

```ruby
filesystem 'testfs1' do
  device '/dev/sdb'
  mount '/db'
  fstype 'xfs'
  options 'noatime,nodev'
  action [:create, :enable, :mount]
end
```

The resource now owns the default filesystem tool mapping through the
`filesystem_tools` property. Override it only when your platform needs different
package names or mkfs force options.

```ruby
filesystem 'data' do
  device '/dev/sdb'
  mount '/data'
  fstype 'ext4'
  filesystem_tools(
    'ext4' => {
      'package' => 'e2fsprogs',
      'forceopt' => '-F',
    }
  )
  action [:create, :enable, :mount]
end
```

## Migrating `node['filesystems']`

Use `filesystem_create_all_from_key` when you still want keyed filesystem data,
but pass the data as a resource property.

```ruby
filesystem_create_all_from_key 'filesystems' do
  filesystems(
    'testfs1' => {
      'device' => '/dev/sdb',
      'mount' => '/db',
      'fstype' => 'xfs',
      'options' => 'noatime,nodev',
    }
  )
end
```

For compatibility, `filesystem_create_all_from_key 'filesystems'` still reads
`node['filesystems']` when the `filesystems` property is not set. New code should
prefer the explicit property form.

## LVM and File-Backed Filesystems

Declare LVM-backed filesystems directly:

```ruby
filesystem 'applv1' do
  vg 'standardvg'
  size '20G'
  mount '/logical1'
  fstype 'ext4'
  action [:create, :enable, :mount]
end
```

Declare file-backed loop devices directly:

```ruby
filesystem 'filebacked' do
  file '/mnt/filesystem-on-a-filesystem.file'
  device '/dev/loop7'
  mount '/mnt/filesystem-on-a-filesystem'
  size '20000'
  action [:create, :enable, :mount]
end
```

## Removed Behavior

* `include_recipe 'filesystem'` is no longer available.
* `include_recipe 'filesystem::example'` is no longer available.
* Top-level cookbook defaults under `attributes/default.rb` are no longer loaded.
* Package defaults for filesystem tools are now resource defaults, not node attributes.
