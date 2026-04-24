# filesystem_create_all_from_key

Creates multiple `filesystem` resources from a hash of filesystem definitions.

## Actions

| Action | Description |
| ------ | ----------- |
| `:create` | Creates filesystem resources from keyed data. |

## Properties

| Property | Type | Default | Description |
| -------- | ---- | ------- | ----------- |
| `name` | String | name property | Node attribute key to read when `filesystems` is not set. |
| `filesystems` | Hash | `node[name] \|\| {}` | Hash keyed by filesystem label with `filesystem` resource properties as values. |

## Examples

### Explicit Filesystem Data

```ruby
filesystem_create_all_from_key 'filesystems' do
  filesystems(
    'data' => {
      'device' => '/dev/sdb',
      'mount' => '/data',
      'fstype' => 'xfs',
    }
  )
end
```
