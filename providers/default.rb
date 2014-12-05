#
# Cookbook Name:: filesystem
# Provider:: create
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

use_inline_resources

include Filesystem

action :create do

  label = @new_resource.label || @new_resource.name

  if @new_resource.file
    device = @new_resource.device
  elsif @new_resource.vg
    device = "/dev/mapper/#{@new_resource.vg}-#{label}"
  elsif @new_resource.uuid
    device = "/dev/disk/by-uuid/#{@new_resource.uuid}"
  elsif @new_resource.device
    device = @new_resource.device
  else
    device = "/dev/mapper/#{label}"
  end

  fstype = @new_resource.fstype
  mkfs_options = @new_resource.mkfs_options
  user = @new_resource.user
  group = @new_resource.group
  mode = @new_resource.mode
  pass = @new_resource.pass
  dump = @new_resource.dump
  options = @new_resource.options

  vg = @new_resource.vg
  file = @new_resource.file
  sparse = @new_resource.sparse
  size = @new_resource.size
  stripes = @new_resource.stripes ? @new_resource.stripes : nil
  mirrors = @new_resource.mirrors ? @new_resource.stripes : nil

  recipe = @new_resource.recipe
  package = @new_resource.package

  force = @new_resource.force

  # In two cases we may need to idempotently create the storage before creating the filesystem on it: LVM and file-backed.
  if ( ( vg || file ) && ( size != nil ) )

    # LVM
    if vg
      # We use the lvm provider directly.
      lvm_logical_volume label do
        group vg
        size size
        stripes if stripes != nil
        mirrors if mirrors != nil
      end
    end

    # File-backed
    if file
      # We use the local filebackend provider, to which we feed some variables including the loopback device we want.
      filesystem_filebacked file do
        device device
        size size
        sparse sparse
      end
    end

  end

  # We only try and create a filesystem if the device is existent and unmounted
  if ( ::File.exists?(device) ) && ( !is_mounted?(device) )

    # We use this check to test if a device's filesystem is already mountable.
    generic_check_cmd = "mkdir -p /tmp/filesystemchecks/#{label}; mount #{device} /tmp/filesystemchecks/#{label} && umount /tmp/filesystemchecks/#{label}"

    # Install the filesystem's default package and recipes as configured in default attributes.
    fs_tools = node[:filesystem_tools][fstype]
    # One day Chef will support calling dynamic include_recipe from LWRPS but until then - see https://tickets.opscode.com/browse/CHEF-611
    # (fs_tools['recipe'].split(',') || []).each {|default_recipe| include_recipe #{default_recipe}"}
    if fs_tools['package']
      packages = fs_tools['package'].split(',')
      (packages).each {|default_package| package "#{default_package}"}
    end

    # If we were keyed to use specific package or cookbooks we attempt to install those too.
    # One day Chef will support calling dynamic include_recipe from LWRPS but until then - see https://tickets.opscode.com/browse/CHEF-611
    #if recipe
    #  (recipe.split(',') || []).each {|keyed_recipe| include_recipe "#{keyed_recipe}"}
    #end
    if package
      packages = @new_resource.package.split(',')
      (packages).each {|keyed_package| package "#{keyed_package}"}
    end

    log "filesystem #{label} creating #{fstype} on #{device}"

    force_option = force ? '-f' : ''

    # We form our mkfs command
    mkfs_cmd = "mkfs -t #{fstype} #{force_option} #{mkfs_options} -L #{label} #{device}"
  
    if force
 
      # We create the filesystem without any checks, and we ignore failures. This is sparta, etc.
      # It should also be noted that forced behaviour is not default behaviour.
      execute mkfs_cmd do
        ignore_failure true
      end

    else

      # We create the filesystem, but only if the device does not already contain a mountable filesystem, and we have the tools.
      execute mkfs_cmd do
        only_if "which mkfs.#{fstype}"
        not_if generic_check_cmd
      end

    end 

  end

  new_resource.updated_by_last_action(true)
end

# If we're enabling, we create the fstab entry.
action :enable do

  label = @new_resource.label || @new_resource.name

  if @new_resource.file
    device = @new_resource.device
  elsif @new_resource.vg
    device = "/dev/mapper/#{@new_resource.vg}-#{label}"
  elsif @new_resource.uuid
    device = "/dev/disk/by-uuid/#{@new_resource.uuid}"
  elsif @new_resource.device
    device = @new_resource.device
  else
    device = "/dev/mapper/#{label}"
  end

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
      options options
      action :enable
      only_if "test -b #{device}"
    end

  end

end

# If we're mounting, we mount.
action :mount do

  label = @new_resource.label || @new_resource.name

  if @new_resource.file
    device = @new_resource.device
  elsif @new_resource.vg
    device = "/dev/mapper/#{@new_resource.vg}-#{label}"
  elsif @new_resource.uuid
    device = "/dev/disk/by-uuid/#{@new_resource.uuid}"
  elsif @new_resource.device
    device = @new_resource.device
  else
    device = "/dev/mapper/#{label}"
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
    end

  end

end

action :freeze do

  mount = @new_resource.mount

  if mount

    execute "fsfreeze --freeze #{mount}" do
      not_if { is_frozen?(mount) }
    end

  else

    raise "mount not specified"

  end

end

action :unfreeze do

  mount = @new_resource.mount

  if mount

    execute "fsfreeze --unfreeze #{mount}" do
      only_if { is_frozen?(mount) }
    end

  else

    raise "mount not specified"

  end
end
