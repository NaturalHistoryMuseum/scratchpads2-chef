#
# Cookbook Name:: control
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

include_recipe 'apt::default'

include_recipe 'apache2::default'

include_recipe 'nfs::server'
nfs_export "/var/aegir/platforms" do
  network ['sp-app-1','sp-app-2', 'sp-app-3', 'sp-app-4']
  writeable true
  sync true
  options ['no_subtree_check']
end

#package ['php5','php5-cli','php5-curl','php5-gd','php5-mysql','php5-memcache']
