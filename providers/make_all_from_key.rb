action :create do

  # Our key is the new resource name
  key = @new_resource.name
  
  # We get our filesystems from the key in node data
  filesystems = node[key]

  # For reach filesystem we want to make, we enter the main creation loop
  filesystems.each_key do |label|

    fs = filesystems[label]

    # We pass all possible options to the lwrp that creates, enables and mounts filesystems.
    filesystems_create label do

      label fs["label"] if fs["label"]
      device fs["device"] if fs["device"]
      vg fs["vg"] if fs["vg"]
      file fs["file"] if ["file"]
      uuid fs["uuid"] if fs["uuid"]
      fstype fs["fstype"] if fs["fstype"]
      mkfs_options fs["mkfs_options"] if fs["mkfs_options"]
      recipe fs["recipe"] if fs["recipe"]
      package fs["package"] if fs["package"]
      sparse fs["sparse"] if fs["sparse"]
      size fs["size"] if fs["size"]
      stripes fs["stripes"] if fs["stripes"]
      mirrors fs["mirrors"] if fs["mirrors"]
      mount fs["mount"] if fs["mount"]
      options fs["options"] if fs["options"]
      user fs["user"] if fs["user"]
      group fs["group"] if fs["group"]
      mode fs["mode"] if fs["mode"]
      pass fs["pass"] if fs["pass"]
      dump fs["dump"] if fs["dump"]
      force fs["force"] if fs["force"]
      # We may not want to do the default action
      if ( fs["mount"] && fs["nomount"] )
        # We are not mounting the fs, but we do enable it's fstab entry.
        action [:create, :enable]
      elsif ( fs["mount"] && fs["noenable"] )
        # We we not enable the fs in fstab, but we do mount it.
        action [:create, :mount]
      elsif ( fs["nomkfs"] )
        # We don't create - we just mount and enable - like the mount resource would do.
        action [:enable, :mount]
      elsif fs["mount"]
        # Default expected behiavour - create, enable and mount
        action [:create, :enable, :mount]
      else
        # Non-default expected behaviour if no mountpoint is given : we only create the filesystem, nothing else.
        action [:create]
      end

    end
  
  end

  new_resource.updated_by_last_action(true)
end
