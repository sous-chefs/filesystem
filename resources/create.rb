# Our filesystems_create provider creates filesystems, and can also mount and enable them.
actions :create, :enable, :mount
default_action :create

# The name attribute is label of the filesystem. 
attribute :name, :kind_of => String, :name_attribute => true
attribute :label, :kind_of => String

# We have several kinds of device we might be using
attribute :device, :kind_of => String
attribute :vg, :kind_of => String
attribute :file, :kind_of => String
attribute :uuid, :kind_of => String

# Creation Options
attribute :fstype, :kind_of => String, :default => "ext3"
attribute :mkfs_options, :kind_of => String, :default => ""
attribute :package, :kind_of => String
attribute :recipe, :kind_of => String

# LVM and filesystem-backed
attribute :mkstorage, :kind_of => [ TrueClass, FalseClass ], :default => true
attribute :sparse, :kind_of => [ TrueClass, FalseClass ], :default => true
attribute :size, :kind_of => String

# Mounting Options
attribute :mount, :kind_of => String
attribute :options, :kind_of => String, :default => "defaults"
# Mount directory options
attribute :user, :kind_of => String
attribute :group, :kind_of => String
attribute :mode, :kind_of => String
# Fstab parts
attribute :pass, :kind_of => Fixnum, :default => 0, :equal_to => [0, 1, 2]
attribute :dump, :kind_of => Fixnum, :default => 0, :equal_to => [0, 1, 2]

# We may try and force things, particularly if we expect to find existing filesystems on otherwise unmounted devices.
attribute :force, :kind_of => [ TrueClass, FalseClass ], :default => false

# default action is :create
def initialize(*args)
  super
  @action = :create
end

