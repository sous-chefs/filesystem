require 'pathname'
require 'chef/mixin/shell_out'

module FilesystemMod
  include Chef::Mixin::ShellOut

  MOUNT_EX_FAIL = 32 unless const_defined?(:MOUNT_EX_FAIL)

  # Check to determine if the device is mounted.
  def mounted?(device)
    mounted = shell_out("grep -q '#{device}' /proc/mounts").exitstatus != 0 ? nil : shell_out("grep -q '#{device}' /proc/mounts").exitstatus
    mounted
  end

  # Check to determine if the mount is frozen.
  def frozen?(mount)
    fields = File.readlines('/proc/mounts').map(&:split).detect { |field| field[1] == mount }
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
