#
# Cookbook Name:: filesystem
# Recipe:: default
#

# load the dbag if its there
begin 
  fs_dbag = data_bag_item(node[:filesystem_bag], data_bag_fqdn )
rescue
  fs_dbag = nil
  Chef::Log.info "No fs data bag found for '#{node[:filesystem_bag]}:#{data_bag_fqdn}`"
end

# if no dbag and no attribs don't continue
return unless fs_dbag or ! node[:filesystems].empty?

# merge dbags over attribs. Take the dbag values over attrib values always
if fs_dbag
  filesystems = node[:filesystems].merge(fs_dbag["filesystems"]) if fs_dbag.has_key?("filesystems")
else
  filesystems = node[:filesystems]
end

return if filesystems == nil

# TODO: Refactor all this 
filesystems.each_key do |label|
  fs = filesystems[label]
  
  # build lv
  if ( fs["vg"] && ( fs["make_lv"] != false ) )
    lv_create(fs["vg"], fs["size"], label) 
  end 

  if fs["uuid"]
    device = "/dev/disk/by-uuid/#{fs['uuid']}"
  elsif fs["device"]
    device = fs["device"]
  elsif fs["vg"]
    device = "/dev/mapper/#{fs['vg']}-#{label}"
  else 
    device = label
  end
    

  type = fs["type"] ? fs["type"] : "xfs"  # xfs is default type
  # make sure we pull in the recipe for this type b4 we try to build this thing 
  include_recipe type
   
  mkfs_options = fs["mkfs_options"] ? fs["mkfs_options"] : nil
  
  # make this thing 
  mkfs( device, label, mkfs_options, type )  unless fs["mkfs"] == false

  # we need to make actions dynamically 
  actions = [] 
  actions << :enable unless fs["fstab"] == false
  actions << :mount  unless fs["mount"] == false

  # should have the dir we want to mount too
  directory fs["mount_point"] do
    recursive true
    owner fs["mount_user"] if fs["mount_user"]
  end unless actions.size == 0 

  mount fs["mount_point"] do

    # terribly ugly but we got a bug on mpath devices cause label lookup doens't find them right
    if device =~ /mpath/ 
      device device
    else 
      case type
      when "xfs", "ext3", "ocfs", "ocfs2", "ext4"
        device_type :label
        device   label
      else 
        device device
      end
    end

    fstype   type
    options  fs["mount_options"] ? fs["mount_options"] : "defaults"
    action   actions
    pass  0
    ignore_failure true
  end unless actions.size == 0 
    
end



