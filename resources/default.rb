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
default_action :create

# The name property is the label of the filesystem.
property  :label, String

# We have several kinds of device we might be using
property  :device, String
property  :vg, String
property  :file, String
property  :uuid, String

# Creation Options
property  :fstype, String, default: 'ext3'
property  :mkfs_options, String, default: ''
property  :package, String
property  :recipe, String
attribute :device_defer, [TrueClass, FalseClass], default: false

# LVM and filebacked
property  :sparse, [true, false], default: true
property  :size, String
property  :stripes, Integer
property  :mirrors, Integer

# Mounting Options
property  :mount, String
property  :options, String, default: 'defaults'
# Mount directory options
property  :user, String
property  :group, String
property  :mode, String
# Fstab parts
property  :pass, Integer, default: 0, equal_to: [0, 1, 2]
property  :dump, Integer, default: 0, equal_to: [0, 1, 2]

# We may try and force things with mkfs, danger...
property  :force, [true, false], default: false
# An additional thing to ignore existing filesystems - this will actively lose you data on unmounted filesystems if set.
property  :ignore_existing, [true, false], default: false

action_class do
  include FilesystemMod

  def wait_for_device(device)
    count = 0
    until ::File.exist?(device)
      count += 1
      sleep 0.3
      Chef::Log.debug "waiting for #{device} to exist, try # #{count}"
      if count >= 1000
        # TODO: make this a paramater
        raise Timeout::Error, 'Timeout waiting for device'
      end
    end
  end

  def device
    @device ||= if @new_resource.file
                  @new_resource.device
                elsif @new_resource.vg
                  "/dev/mapper/#{@new_resource.vg}-#{label}"
                elsif @new_resource.uuid
                  "/dev/disk/by-uuid/#{@new_resource.uuid}"
                elsif @new_resource.device
                  @new_resource.device
                else
                  "/dev/mapper/#{label}"
                end
  end

  def label
    @label = @new_resource.label || @new_resource.name
  end
end

action :create do
  fstype = @new_resource.fstype
  mkfs_options = @new_resource.mkfs_options
  ignore_existing = @new_resource.ignore_existing
  vg = @new_resource.vg
  file = @new_resource.file
  sparse = @new_resource.sparse
  size = @new_resource.size
  stripes = @new_resource.stripes ? @new_resource.stripes : nil
  mirrors = @new_resource.mirrors ? @new_resource.stripes : nil
  package = @new_resource.package
  force = @new_resource.force

  # In two cases we may need to idempotently create the storage before creating the filesystem on it: LVM and file-backed.
  if (vg || file) && !size.nil?

    # LVM
    # We use the lvm provider directly.
    lvm_logical_volume label do
      action :nothing
      group vg
      size size
      stripes unless stripes.nil?
      mirrors unless mirrors.nil?
      not_if do
        vg.nil?
      end
    end.run_action(:create)

    # File-backed
    # We use the local filebackend provider, to which we feed some variables including the loopback device we want.
    backed_device = device
    filesystem_filebacked file do
      action :nothing
      device backed_device
      size size
      sparse sparse
      not_if do
        file.nil?
      end
    end.run_action(:create)
  end

  unless ::File.exist?(device) || netfs?(fstype)
    count = 0
    until ::File.exist?(device)
      count += 1
      sleep 0.3
      Chef::Log.debug "waiting for #{device} to exist, try # #{count}"
      if count >= 1000
        # TODO: make this a paramater
        raise Timeout::Error, 'Timeout waiting for device'
      end
    end
  end

  # We only try and create a filesystem if the device exists and is unmounted
  unless mounted?(device)

    # We use this check to test if a device's filesystem is already mountable.
    generic_check_cmd = "mkdir -p /tmp/filesystemchecks/#{label}; mount #{device} /tmp/filesystemchecks/#{label} && umount /tmp/filesystemchecks/#{label}"

    # Install the filesystem's default package and recipes as configured in default attributes.
    fs_tools = node['filesystem_tools'].fetch(fstype, nil)
    # One day Chef will support calling dynamic include_recipe from resources but until then - see https://tickets.opscode.com/browse/CHEF-611
    if fs_tools && fs_tools.fetch('package', false)
      packages = fs_tools['package'].split(',')
      packages.each { |default_package| package default_package.to_s }
    end
    if package
      packages = @new_resource.package.split(',')
      packages.each { |keyed_package| package keyed_package.to_s }
    end

    Chef::Log.info "filesystem #{label} creating #{fstype} on #{device}"

    # Install the filesystem's default package and recipes as configured in default attributes.
    mkfs_force_options = node['filesystem_tools'].fetch(fstype, nil)
    # One day Chef will support calling dynamic include_recipe from LWRPS but until then - see https://tickets.opscode.com/browse/CHEF-611
    # (fs_tools['recipe'].split(',') || []).each {|default_recipe| include_recipe #{default_recipe}"}
    if mkfs_force_options && mkfs_force_options.fetch('forceopt', false)
      # if force is true, we set the force option. If it isn't set it remains empty.
      force_option = force ? mkfs_force_options['forceopt'] : ''
    end

    # We form our mkfs command
    mkfs_cmd = "mkfs -t #{fstype} #{force_option} #{mkfs_options} -L #{label} #{device}"

    if force
      return if generic_check_cmd && !ignore_existing
    elsif generic_check_cmd && !shell_out("which mkfs.#{fstype}").exitstatus == 0
      # We create the filesystem, but only if the device does not already contain a mountable filesystem, and we have the tools.
      return
    end
    converge_by("Mkfs type #{fstype} #{label} #{device}") do
      shell_out!(mkfs_cmd)
    end

  end
end

# If we're enabling, we create the fstab entry.
action :enable do
  mount = @new_resource.mount
  fstype = @new_resource.fstype
  user = @new_resource.user
  group = @new_resource.group
  mode = @new_resource.mode
  pass = @new_resource.pass
  dump = @new_resource.dump
  options = @new_resource.options
  file = @new_resource.file

  if mount

    # We use the chef directory method to create the mountpoint with the settings we provide
    directory mount do
      recursive true
      owner user if user
      group group if group
      mode mode if mode
    end

    # Substitute the device with the file when in loopback mode.
    # This should allow the mount to come back up on reboot.
    device_or_file = device
    if file && device.start_with?('/dev/loop')
      device_or_file = file
      options = [options, "loop=#{device}"].compact.join(',')
    end

    # Mount using the chef resource
    mount mount do
      device device_or_file
      pass pass
      dump dump
      fstype fstype
      options options
      action :enable
      only_if "test -b #{device}"
      notifies :create, "directory[#{mount}]", :immediately
    end

    # NFS?

  end
end

# If we're mounting, we mount.
action :mount do
  device = if @new_resource.file
             @new_resource.device
           elsif @new_resource.vg
             "/dev/mapper/#{@new_resource.vg}-#{label}"
           elsif @new_resource.uuid
             "/dev/disk/by-uuid/#{@new_resource.uuid}"
           elsif @new_resource.device
             @new_resource.device
           else
             "/dev/mapper/#{label}"
           end

  mount = @new_resource.mount
  fstype = @new_resource.fstype
  user = @new_resource.user
  group = @new_resource.group
  options = @new_resource.options

  if mount

    # We use the chef directory method to create the mountpoint with the settings we provide
    directory mount do
      recursive true
      owner user if user
      group group if group
      mode mode if mode
    end

    # Mount using the chef resource
    mount mount do
      device device
      fstype fstype
      options options
      action :mount
      only_if "test -b #{device}"
      not_if "mount | grep #{device}\" \" | grep #{mount}\" \""
      notifies :create, "directory[#{mount}]", :immediately
    end

    # handle NFS mounts
    # assume root has access to the mounted file system

  end
end

action :freeze do
  mount = @new_resource.mount
  raise 'mount not specified' if mount.nil?

  unless filesystem_frozen?(mount)
    converge_by("Freeze #{mount}") do
      shell_out!("fsfreeze --freeze #{mount}")
    end
  end
end

action :unfreeze do
  mount = @new_resource.mount
  raise 'mount not specified' if mount.nil?

  if filesystem_frozen?(mount)
    converge_by("Unfreeze #{mount}") do
      shell_out!("fsfreeze --unfreeze #{mount}")
    end
  end
end
