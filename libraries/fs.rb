require 'pathname'
require 'chef/mixin/shell_out'

module FilesystemMod
  include Chef::Mixin::ShellOut

  MOUNT_EX_FAIL = 32 unless const_defined?(:MOUNT_EX_FAIL)
  MOUNT_EX_BUSY = 1 unless const_defined?(:MOUNT_EX_BUSY)
  NET_FS_TYPES = %w(nfs nfs4 cifs smp nbd).freeze unless const_defined?(:NET_FS_TYPES)
  NFS_TYPES = %w(nfs nfs4).freeze unless const_defined?(:NFS_TYPES)

  def canonical_path(path)
    File.exist?(path) && File.realpath(path) || path
  end

  # Check to determine if a device is mounted.
  def mounted?(params = {})
    params.is_a?(String) && params = { device: params } # backward compatibility

    mounts = File.readlines('/proc/mounts').map(&:split).map do |field|
      {
        device: field[0].start_with?('/dev/') && canonical_path(field[0]) || field[0],
        mountpoint: field[1],
      }
    end

    if params.key?(:device) && params.key?(:mountpoint)
      mounts.select do |mount|
        mount[:device] == canonical_path(params[:device]) &&
          mount[:mountpoint] == params[:mountpoint].chomp('/')
      end.any?
    elsif params.key?(:device)
      mounts.select { |mount| mount[:device] == canonical_path(params[:device]) }.any?
    elsif params.key?(:mountpoint)
      mounts.select { |mount| mount[:mountpoint] == params[:mountpoint].chomp('/') }.any?
    else
      raise 'Invalid parameters passed to method "mounted?"'
    end
  end

  # Check to determine if the mount is frozen.
  # There is no really good way to determine if a file system is frozen.
  # Trying to remount the file system will return a FAIL or BUSY, we need to test for both but the results can be misleading
  def filesystem_frozen?(mount_loc)
    fields = File.readlines('/proc/mounts').map(&:split).detect { |field| field[1] == mount_loc }
    raise "#{mount_loc} not mounted" unless fields
    stat = shell_out('mount', '-o', "remount,#{fields[3]}", mount_loc)
    [MOUNT_EX_FAIL, MOUNT_EX_BUSY].include?(stat.exitstatus) ? true : false
  end

  # Check if provided filesystem type is netfs
  def netfs?(fstype)
    NET_FS_TYPES.include? fstype
  end
end
