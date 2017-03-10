#
# Cookbook Name:: test
# Recipe:: default
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
execute 'dd if=/dev/zero of=/opt/loop.img bs=1M count=10'
execute 'losetup /dev/loop0 /opt/loop.img'

filesystem 'loop-1' do
  fstype 'ext3'
  device '/dev/loop0'
  mount '/mnt/loop-1'
  action [:create, :enable, :mount]
end
