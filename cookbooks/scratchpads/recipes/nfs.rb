#
# Cookbook Name:: scratchpads
# Recipe:: nfs
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# Install NFS server and set it to allow access to certain servers.
if node.automatic.roles.index("control") then
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
else
  # Create the aegir directory
  directory '/var/aegir/platforms' do
    owner 'aegir'
    group 'www-data'
    mode 0777
    action :create
  end
  # Mount the folder from the control server
  include_recipe 'nfs::client4'
  if Chef::Config[:solo]
    control_hosts = {"sp-control-1" => {"fqdn" => "sp-control-1"}}
  else
    control_hosts = search(:node, "role:control")
  end
  control_host = control_hosts.first
  mount "/var/aegir/platforms" do
    device "#{control_host['fqdn']}:/var/aegir/platforms"
    fstype "nfs"
    options "rw,bg,ac,noatime"
    action [:mount, :enable]
  end
end