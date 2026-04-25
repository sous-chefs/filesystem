# frozen_string_literal: true

name              'filesystem'
maintainer        'Sous Chefs'
maintainer_email  'help@sous-chefs.org'
description       'Provides custom resources for creating and mounting filesystems'
license           'Apache-2.0'
version           '4.2.4'
source_url        'https://github.com/sous-chefs/filesystem'
issues_url        'https://github.com/sous-chefs/filesystem/issues'
chef_version      '>= 15.3'

supports 'almalinux', '>= 9.0'
supports 'amazon', '>= 2023.0'
supports 'centos_stream', '>= 9.0'
supports 'debian', '>= 12.0'
supports 'fedora'
supports 'opensuseleap', '>= 16.0'
supports 'oracle', '>= 8.0'
supports 'redhat', '>= 8.0'
supports 'rocky', '>= 9.0'
supports 'ubuntu', '>= 22.04'

depends 'lvm', '>= 1.1'
