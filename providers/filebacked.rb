action :create do
 
  file = @new_resource.name
  size = @new_resource.size
  sparse = @new_resource.sparse
  device = @new_resource.device
 
  # Idempotent behaviour:

  # Case 1) File found, Loopback found => return loopback.
  # Case 2) File found, Loopback missing => create loopback, return loopback.
  # Case 3) File missing, Loopback missing => create file and loopback, return loopback.

  create_loopback = "losetup #{device} #{file}"

  get_loopback_cmd = "losetup -a | grep #{file} | grep #{device}"

  loopback = `#{get_loopback_cmd}`.gsub(/: \[.*/, "").strip

  if ( ::File.exists?(file) && device == loopback )
    # Case 1)
    # File and Loopback found - we return the loopback.

    log "Device #{loopback} already exists for #{file}"

  elsif ( ::File.exists?(file) && device =! loopback )
    # Case 2)
    # File but no loopback - so we make a loopback.

    log "Creating #{device} for #{file}"
    execute create_loopback do
      only_if "ls #{file} >/dev/null"
    end

    log `#{get_loopback_cmd}`

  elsif size != nil
    # Case 3)
    # If we have a size, we can create the file

    # We make sure a directory exists for the file to live in.
    directory ::File.dirname(file) do
      recursive true
    end

    # We pick the file creation method
    if sparse == true
      # We default to speedy file creation.
      file_creation_cmd = "dd bs=1M count=0 seek=#{size} of=\"#{file}\""
    else
      # If not sparse we use zeros - this takes much longer.
      file_creation_cmd = "dd bs=1M count=#{size} if=/dev/zero of=\"#{file}\""
    end

    log "Creating #{file}"

    # We create the file, but only if there is not already a loopback device mapped for it.
    execute file_creation_cmd do
    end

    # If the file was created, we make a loopback device for the file and return the loopback result.
    log "Creating #{device} for #{file}"
    execute create_loopback do
      only_if "ls #{file} >/dev/null"
    end
    
    log `#{get_loopback_cmd}`

  end

end
