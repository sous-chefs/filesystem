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
