# We default to creating all filesystems found in the key
actions :create
default_action :create

# The name attribute is the key of the filesystems. 
attribute :name, :kind_of => String, :name_attribute => true, :default => "filesystems"

# default action is :create
def initialize(*args)
  super
  @action = :create
end

