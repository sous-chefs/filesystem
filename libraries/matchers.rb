if defined?(ChefSpec)
  def create_filesystem(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new('filesystem', :create, resource_name)
  end

  def enable_filesystem(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new('filesystem', :enable, resource_name)
  end

  def mount_filesystem(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new('filesystem', :mount, resource_name)
  end

  def freeze_filesystem(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new('filesystem', :freeze, resource_name)
  end

  def unfreeze_filesystem(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new('filesystem', :unfreeze, resource_name)
  end
end
