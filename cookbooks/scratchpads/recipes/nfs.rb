#
# Cookbook Name:: scratchpads
# Recipe:: nfs
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# Check if we are the Control server, which has the NFS server installed.
if node['roles'].index('control') then
  # Install NFS server and set it to allow access to certain servers.
  include_recipe 'nfs::server4'
  app_hosts = ['sp-app-1']
  unless Chef::Config[:solo]
    app_hosts_search = search(:node, 'roles:app')
    app_hosts = []
    app_hosts_search.each do|app_host|
      app_hosts << app_host['fqdn']
    end
  end
  nfs_export '/var/aegir/platforms' do
    network app_hosts
    writeable true
    sync true
    options ['root_squash','no_subtree_check']
  end
  nfs_export '/var/www' do
    network app_hosts
    writeable true
    sync true
    options ['root_squash','no_subtree_check']
  end
  # Restart nfs-server components
  execute 'restart the NFS server' do
    command '/bin/systemctl restart nfs-kernel-server'
    group 'root'
    user 'root'
  end
else
  # We are not the control server, so must be an app server. We install the
  # client and add a mount point and mount!
  # Create the aegir directory
  directory '/var/aegir/platforms' do
    owner 'aegir'
    group 'www-data'
    mode 0777
    action :create
    not_if { ::File.exists?('/var/aegir/platforms')}
  end
  # Mount the folder from the control server
  include_recipe 'nfs::client4'
  if Chef::Config[:solo]
    control_hosts = {'sp-control-1' => {'fqdn' => 'sp-control-1'}}
  else
    control_hosts = search(:node, 'flags:UP AND roles:control')
  end
  control_host = control_hosts.first
  mount '/var/aegir/platforms' do
    device "#{control_host['fqdn']}:/var/aegir/platforms"
    fstype 'nfs'
    options 'rw,bg,ac,noatime'
    action [:mount, :enable]
  end
  execute 'delete /var/www/html before mount /var/www' do
    command 'rm -rf /var/www/html'
    group 'root'
    user 'root'
    not_if {::File.exists?('/var/www/html')}
  end
  mount '/var/www' do
    device "#{control_host['fqdn']}:/var/www"
    fstype 'nfs'
    options 'rw,bg,ac,noatime'
    action [:mount, :enable]
  end
end
