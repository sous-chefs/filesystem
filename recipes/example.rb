# There are several ways you could use this cookbook

# This is the default recipe's contents:

# If we have contents at the default location, we try to make the filesystems with the LWRP.
filesystems_make_all_from_key "filesystems" do
  action :create
  not_if ( node[:filesystems] == nil || node[:filesystems].empty? )
end

# But there are always ways to do non-defaulty things

# If we have contents at a different location we try and make all those other filesystems to.
filesystems_make_all_from_key "mylittlefilesystems" do
  action :create
  not_if ( node[:mylittlefilesystems] == nil || node[:mylittlefilesystems].empty? )
end

# Or we can call the creation of a filesystem directly with the filesystems_create LWRP

filesystems_create "littlelabel" do
  fstype "ext3"
  device "/dev/sdb1"
  mount "/mnt/littlelabel"
  actions [:create, :enable, :mount]
end

