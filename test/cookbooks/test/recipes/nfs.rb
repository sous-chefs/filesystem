#
# Cookbook:: test
# Recipe:: nfs
#

return unless platform_family?('debian')

# apt update
apt_update 'Update packages'

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
