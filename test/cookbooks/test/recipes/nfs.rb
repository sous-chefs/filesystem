#
# Cookbook:: test
# Recipe:: nfs
#

return unless platform_family?('debian')

# apt update
apt_update 'Update packages'

# apt install nfs-kernel-server
package 'nfs-kernel-server'

# create a directory
directory '/exports/nfs1' do
  recursive true
end

# configure to export the directory
file '/etc/exports' do
  content '/exports/nfs1 *(rw,no_root_squash,no_subtree_check)'
end

execute 'exportfs -a'

# start the nfs server service
service 'nfs-kernel-server' do
  action [:enable, :start]
  ignore_failure true
end

filesystem 'nfs-1' do
  fstype 'nfs'
  device 'localhost:/exports/nfs1'
  mount '/mnt/nfs-1'
  action [:enable]
end

filesystem 'nfs-4' do
  fstype 'nfs4'
  device 'localhost:/exports/nfs1'
  mount '/mnt/nfs-4'
  action [:enable]
end
