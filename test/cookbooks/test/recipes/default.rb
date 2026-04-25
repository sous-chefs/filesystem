#
# Cookbook:: test
# Recipe:: default
#

if platform_family?('debian')
  apt_update 'Update packages'
end

if platform_family?('debian')
  package 'mount'
end

if platform_family?('rhel')
  package 'e2fsprogs'
end

if platform_family?('suse')
  package 'util-linux-systemd'
end

execute 'detach stale loop devices from prior dokken runs' do
  command 'losetup -d /dev/loop2 /dev/loop3 /dev/loop4'
  returns [0, 1]
  not_if { ::File.exist?('/opt/loop.img') }
end

filesystem_create_all_from_key 'deferred_filesystems' do
  filesystems(
    'defer1' => {
      'device' => '/dev/defer1',
      'device_defer' => true,
      'fstype' => 'ext3',
      'mount' => '/mnt/defer-1',
    }
  )
end

file '/etc/fstab' do
  action :create_if_missing
end

filesystem 'loop-1' do
  fstype 'ext3'
  file '/opt/loop.img'
  size '10000'
  device '/dev/loop2'
  mount '/mnt/loop-1'
  action [:create, :enable, :mount]
end

filesystem 'loop-2' do
  fstype 'ext3'
  file '/opt/loop.img'
  size '10000'
  device '/dev/loop3'
  mount '/mnt/loop-2'
  action [:create, :enable, :mount]
end

filesystem 'loop-3' do
  fstype 'ext3'
  file '/opt/loop.img'
  size '10000'
  device '/dev/loop4'
  mount '/mnt/loop-3'
  action [:create, :enable, :mount]
end

filesystem 'dev1' do
  device_defer true
  fstype 'ext3'
  size '10000'
  device '/dev/dev1'
  mount '/mnt/dev-1'
  action [:create, :enable, :mount]
end

filesystem 'uuid1' do
  device_defer true
  fstype 'ext3'
  size '10000'
  uuid 'devuuid'
  mount '/mnt/uuid-1'
  action [:create, :enable, :mount]
end

filesystem 'label1' do
  device_defer true
  fstype 'ext3'
  size '10000'
  label 'label1'
  mount '/mnt/label-1'
  action [:create, :enable, :mount]
end

file '/mnt/loop-1/testfile'
