maintainer       "Jesse Nelson"
maintainer_email "spheromak@gmail.com"
description      "Installs/Configures various filesystems"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.6.3"

%w/redhat centos xenserver ubuntu debian/.each do |os|
  supports os
end

depends 'xfs'
depends 'databag-helper'

attribute'node[:filesystems_bag]',
  :description => "bagname to look for this fqdn's filesystems",
  :type => "hash",
  :required => "recommended"

attribute'node[:filesystems]',
  :description => "Filesystems to be manages/built",
  :type => "hash",
  :required => "recommended"

