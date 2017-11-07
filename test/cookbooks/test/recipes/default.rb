#
# Cookbook:: test
# Recipe:: default
#
include_recipe 'filesystem::default'

filesystem 'loop-1' do
  fstype 'ext3'
  file '/opt/loop.img'
  size '10000'
  device '/dev/loop0'
  mount '/mnt/loop-1'
  action [:create, :enable, :mount]
end

filesystem 'loop-xfs' do
  fstype 'xfs'
  file '/opt/loop-xfs.img'
  size '10000'
  device '/dev/loop1'
  mount '/mnt/loop-xfs'
  action [:create, :enable, :mount]
end
