name             'filesystem'
maintainer       'Alex Trull'
maintainer_email 'cookbooks.atrullmdsol@trull.org'
description      'Installs/Configures various filesystems'
license          'Apache 2.0'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.11.0"
source_url       "https://github.com/atrull/filesystem_cookbook"
issues_url       "https://github.com/atrull/filesystem_cookbook/issues"
chef_version '>= 12.0' if respond_to?(:chef_version)

%w/redhat centos xenserver ubuntu debian scientific amazon/.each do |os|
  supports os
end

depends 'xfs'
depends 'lvm', '~> 3.1'

attribute 'filesystems',
  :description => "Filesystems to be created and/or mounted",
  :type => "hash",
  :required => "recommended"

