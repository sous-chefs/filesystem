#
# Cookbook:: test
# Recipe:: default
#

file '/etc/fstab' do
  action :touch
  not_if { ::File.exist?('/etc/fstab') }
end

filesystem 'loop-1' do
  fstype 'ext3'
  file '/opt/loop.img'
  size '10000'
  device '/dev/loop0'
  mount '/mnt/loop-1'
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
