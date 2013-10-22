#
# Cookbook Name:: filesystems
# Attributes:: default
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

# This is used to create the filesystems themselves, see examples in the README.
default[:filesystems] = Hash.new

# These are used to provide sensible default recipes and packages for installing tools for supporting filesystems.
# The format is [:filesystems_tools][:fstype][:package|recipe] = "package1,package2"
default[:filesystems_tools][:ext2][:package] = "e2fsprogs"
default[:filesystems_tools][:ext3][:package] = "e2fsprogs"
default[:filesystems_tools][:ext4][:package] = "e2fsprogs"
default[:filesystems_tools][:xfs][:recipe] = "xfs"
default[:filesystems_tools][:xfs][:package] = "xfsprogs"
default[:filesystems_tools][:btrfs][:package] = "btrfs-tools"
