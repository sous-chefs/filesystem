require 'pathname'

# filesystem helpers
def lv_create(vg=nil, size=nil, lv=nil)
  execute "lvcreate -L#{size} -n #{lv}  #{vg} " do 
    not_if "test -b /dev/#{vg}/#{lv}"
  end
end

# is this damn thing already mounted ?
def is_mounted?(device)
  check_mount = Chef::ShellOut.new("mount | grep -q '#{device}'")
  check_mount.run_command
  return true if 0 == check_mount.status
  
  # might as well follow the link like mount does
  # recursion is fun
  return is_mounted?(Pathname.new(device).realpath.to_s) if File.symlink?(device)
  
  false
end


def mkfs(device=nil, label=nil, opts=nil, type="xfs" ) 
  return if is_mounted?(device)
  mkfs_cmd = "mkfs.#{type} #{opts} -L #{label} #{device}"
  case type 
  when "xfs"
    has_fs_cmd = "xfs_admin -l #{device}  | grep 'label'| grep -q #{label}"
  when "ocfs2"
    has_fs_cmd = "tunefs.ocfs2 -q -Q'%V' #{device} | grep -q '#{label}' "
  when "nfs"
    # we never make an nfs fs
    has_fs_cmd = "true"
  end 
  
  execute mkfs_cmd do
     not_if has_fs_cmd
  end unless is_mounted?(device)
end
