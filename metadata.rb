name             'filesystem'
maintainer       'Sous Chefs'
maintainer_email 'help@sous-chefs.org'
description      'Installs/Configures various filesystems'
license          'Apache-2.0'
version          '1.0.0'
source_url       'https://github.com/sous-chefs/filesystem'
issues_url       'https://github.com/sous-chefs/filesystem/issues'
chef_version     '>= 12.5'

%w(redhat centos xenserver ubuntu debian scientific amazon).each do |os|
  supports os
end

depends 'lvm', '>= 1.1'
