#
# Cookbook:: filesystem
# Resource:: default
#
# Copyright:: 2013-2017, Alex Trull
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

# Our filesystem provider creates filesystems and can also mount/enable them.
actions :create, :enable, :mount, :freeze, :unfreeze
default_action :create

# The name attribute is label of the filesystem.
attribute :label, kind_of: String

# We have several kinds of device we might be using
attribute :device, kind_of: String
attribute :vg, kind_of: String
attribute :file, kind_of: String
attribute :uuid, kind_of: String

# Creation Options
attribute :fstype, kind_of: String, default: 'ext3'
attribute :mkfs_options, kind_of: String, default: ''
attribute :package, kind_of: String
attribute :recipe, kind_of: String

# LVM and filebacked
attribute :sparse, kind_of: [TrueClass, FalseClass], default: true
attribute :size, kind_of: String
attribute :stripes, kind_of: Integer
attribute :mirrors, kind_of: Integer

# Mounting Options
attribute :mount, kind_of: String
attribute :options, kind_of: String, default: 'defaults'
# Mount directory options
attribute :user, kind_of: String
attribute :group, kind_of: String
attribute :mode, kind_of: String
# Fstab parts
attribute :pass, kind_of: Integer, default: 0, equal_to: [0, 1, 2]
attribute :dump, kind_of: Integer, default: 0, equal_to: [0, 1, 2]

# We may try and force things with mkfs, danger...
attribute :force, kind_of: [TrueClass, FalseClass], default: false
# An additional thing to ignore existing filesystems - this will actively lose you data on unmounted filesystems if set.
attribute :ignore_existing, kind_of: [TrueClass, FalseClass], default: false
