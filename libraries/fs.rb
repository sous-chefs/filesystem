require 'pathname'

# Check to determine if the device is mounted. 
def is_mounted?(device)
  system("grep -q '#{device}' /proc/mounts")
end

