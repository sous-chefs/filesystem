require 'pathname'

# We check that the device is not already mounted. 
def is_mounted?(device)
  check_mount = system("grep -q '#{device}' /proc/mounts")
 
  if check_mount
    return true
  else 
    return false
  end
  
end


