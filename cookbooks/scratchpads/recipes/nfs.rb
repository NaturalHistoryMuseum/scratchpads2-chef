#
# Cookbook Name:: scratchpads
# Recipe:: nfs
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# Install NFS server and set it to allow access to certain servers.
include_recipe 'nfs::server4'
app_hosts = ["sp-app-1"]
unless Chef::Config[:solo]
  app_hosts_search = search(:node, "role:app")
  app_hosts = []
  app_hosts_search.each do|app_host|
    app_hosts << app_host['fqdn']
  end
end
nfs_export "/var/aegir/platforms" do
  network app_hosts
  writeable true
  sync true
  options ['root_squash','no_subtree_check']
end
