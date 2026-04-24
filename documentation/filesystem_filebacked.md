# filesystem_filebacked

Creates a loopback device backed by a file.

## Actions

| Action | Description |
| ------ | ----------- |
| `:create` | Creates the backing file when needed and attaches it to a loopback device. |

## Properties

| Property | Type | Default | Description |
| -------- | ---- | ------- | ----------- |
| `name` | String | name property | Backing file path. |
| `device` | String | `nil` | Loopback device path. |
| `size` | String | `nil` | Backing file size in megabytes. |
| `sparse` | true, false | `true` | Use sparse file creation. |

## Examples

### Basic Usage

```ruby
filesystem_filebacked '/tmp/myfile' do
  device '/dev/loop1'
  size '10'
  sparse true
end
```
