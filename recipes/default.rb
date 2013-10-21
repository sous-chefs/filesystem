#
# Cookbook Name:: filesystems
# Recipe:: default
#

# We want to support LVM and xfs
include_recipe "lvm"
include_recipe "xfs"

# If we have contents at the default location, we try to make the filesystems with the LWRP.
filesystems_make_all_from_key "filesystems" do
  action :create
  not_if ( node[:filesystems] == nil || node[:filesystems].empty? )
end
