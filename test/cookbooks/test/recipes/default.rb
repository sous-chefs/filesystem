#
# Cookbook:: test
# Recipe:: default
#

file '/etc/fstab' do
  action :touch
end

filesystem 'loop-1' do
  fstype 'ext3'
  file '/opt/loop.img'
  size '10000'
  device '/dev/loop0'
  mount '/mnt/loop-1'
  action [:create, :enable, :mount]
end

filesystem 'loop-2' do
  fstype 'ext3'
  file '/opt/loop.img'
  size '10000'
  device '/dev/loop0'
  mount '/mnt/loop-2'
  action [:create, :enable, :mount, :freeze]
end

filesystem 'loop-3' do
  fstype 'ext3'
  file '/opt/loop.img'
  size '10000'
  device '/dev/loop0'
  mount '/mnt/loop-3'
  action [:create, :enable, :mount, :freeze, :unfreeze]
end

# filesystem actions
#   :create
#   :enable
#   :mount
#   :freeze
#   :unfreeze

# filesystem_filebacked actions
#   :create   :create

# create lots of file systems looking for node attributes specs
# filesystem_create_all_from_key actions
#   :create   :create
