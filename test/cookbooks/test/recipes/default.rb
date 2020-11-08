#
# Cookbook:: test
# Recipe:: default
#

if platform_family?('debian')
  package 'mount'
end

if platform_family?('rhel')
  package 'e2fsprogs'
end

file '/etc/fstab' do
  action :touch
end

filesystem 'loop-1' do
  fstype 'ext3'
  file '/opt/loop.img'
  size '10000'
  device '/dev/loop5'
  mount '/mnt/loop-1'
  action [:create, :enable, :mount]
end

filesystem 'loop-2' do
  fstype 'ext3'
  file '/opt/loop.img'
  size '10000'
  device '/dev/loop6'
  mount '/mnt/loop-2'
  action [:create, :enable, :mount, :freeze]
end

filesystem 'loop-3' do
  fstype 'ext3'
  file '/opt/loop.img'
  size '10000'
  device '/dev/loop7'
  mount '/mnt/loop-3'
  action [:create, :enable, :mount, :freeze, :unfreeze]
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

# verify the idempotence of filesystem initialization
# add a file
# unmount it
# create the file system again - should not run mkfs again which would wipe out the filet

file '/mnt/loop-1/testfile'

mount '/mnt/loop-1 unmount' do
  action :unmount
  device '/dev/loop5'
  mount_point '/mnt/loop-1'
end

filesystem 'loop-1 remount' do
  fstype 'ext3'
  file '/opt/loop.img'
  label 'loop-1'
  size '10000'
  device '/dev/loop5'
  mount '/mnt/loop-1'
  action [:create, :enable, :mount]
end
