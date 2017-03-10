#
# Cookbook Name:: filesystem
# Recipe:: example
#
# Copyright 2013 Alex Trull
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# There are several ways you could use this cookbook
# This is the default recipe's contents:

# We want to support LVM
include_recipe 'lvm'

# If we have contents at the default location, we try to make the filesystems with the LWRP.
filesystem_create_all_from_key 'filesystems' do
  action :create
  not_if { node['filesystems'].nil? || node['filesystems'].empty? }
end

## Examples:

# But there are always ways to do non-defaulty things

# If we have contents at a different location we try and make all those other filesystems to.
filesystem_create_all_from_key 'mylittlefilesystems' do
  action :create
  not_if { node['mylittlefilesystems'].nil? || node['mylittlefilesystems'].empty? }
end

# Or we can call the creation of a filesystem directly with the filesystem default LWRP
filesystem 'littlelabel' do
  fstype 'ext3'
  device '/dev/sdb1'
  mount '/mnt/littlelabel'
  action [:create, :enable, :mount]
end

# Or what about in combination with the mdadm provider ?
# mdadm "/dev/sd0" do
#  devices [ "/dev/s1", "/dev/s2", "/dev/s3", "/dev/s4" ]
#  level 5
#  action :create
# end

# filesystem "raid" do
#  fstype "ext4"
#  device "/dev/sd0"
#  mount "/mnt/raid"
#  action [:create, :enable, :mount]
# end
