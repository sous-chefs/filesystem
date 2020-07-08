
# Resource: filebacked

## Actions

| Action | Description           |
| ------ | --------------------- |
| create | Create a loopback filesystem backed by a file |

## Properties

### `name`

The backing file name.

### `device`

The loopback device name.

### `size`

Size in M (1024x1014).

### `sparse`

Fast file creation. The file is not filled with zeros.

## Usage

filesystem_filebacked '/tmp/myfile'  do
  device /dev/loop1
  size 10
  sparse true
end
