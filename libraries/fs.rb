require 'pathname'
require 'chef/mixin/shell_out'

module Filesystem
  include Chef::Mixin::ShellOut

  MOUNT_EX_FAIL = 32 unless const_defined?(:MOUNT_EX_FAIL)

  # Check to determine if the device is mounted.
  def is_mounted?(device)
    system("grep -q '#{device}' /proc/mounts")
  end

  # Check to determine if the mount is frozen.
  def is_frozen?(mount)
    fields = File.readlines('/proc/mounts').map {|line| line.split}.detect {|fields| fields[1] == mount}
    raise "#{mount} not mounted" unless fields
    remount = shell_out('mount', '-o', "remount,#{fields[3]}", mount)
    if remount.exitstatus == MOUNT_EX_FAIL
      true
    else
      remount.error!
      false
    end
  end
end
