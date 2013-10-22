# We default to creating all filesystems found in the key
actions :create
default_action :create

# The name attribute is the file to be created.
attribute :name, :kind_of => String, :name_attribute => true

attribute :device, :kind_of => String
attribute :size, :kind_of => String
attribute :sparse, :kind_of => [ TrueClass, FalseClass ], :default => true

# default action is :create
def initialize(*args)
  super
  @action = :create
end

