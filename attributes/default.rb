#
# Cookbook Name:: filesystem
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
default['filesystems'] = {}

# These are used to provide sensible default recipes and packages for installing tools for supporting filesystems.
# The format is ['filesystem_tools']['fstype']['package|recipe'] = "package1,package2"
default['filesystem_tools']['ext2']['package'] = 'e2fsprogs'
default['filesystem_tools']['ext3']['package'] = 'e2fsprogs'
default['filesystem_tools']['ext4']['package'] = 'e2fsprogs'
default['filesystem_tools']['xfs']['package'] = 'xfsprogs'
default['filesystem_tools']['btrfs']['package'] = 'btrfs-tools'
# Different filesystems use different force options (stupid I know)
default['filesystem_tools']['ext2']['forceopt'] = '-F'
default['filesystem_tools']['ext3']['forceopt'] = '-F'
default['filesystem_tools']['ext4']['forceopt'] = '-F'
default['filesystem_tools']['xfs']['forceopt'] = '-f'
default['filesystem_tools']['btrfs']['forceopt'] = '-f'
