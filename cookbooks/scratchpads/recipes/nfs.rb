#
# Cookbook Name:: scratchpads
# Recipe:: nfs
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# Check if we are the Control server, which has the NFS server installed.
if node['roles'].index(node['scratchpads']['control']['role']) then
  # Install NFS server and set it to allow access to certain servers.
  include_recipe 'nfs::server4'
  # Add any hosts that you'd like to use for development work here.
  client_hosts = []
  unless Chef::Config[:solo]
    client_hosts_search = search(:node, "roles:#{node['scratchpads']['app']['role']} OR roles:#{node['scratchpads']['data']['role']}")
    if client_hosts_search.length > 0
      client_hosts = node['scratchpads']['nfs']['default_hosts'].dup
      client_hosts_search.each do|client_host|
        client_hosts << client_host['fqdn']
      end
      node.default['scratchpads']['nfs']['hosts'] = client_hosts
    end
  end
  node['scratchpads']['nfs']['exports'].each do|mount_dir,mount_to|
    nfs_export mount_dir do
      network client_hosts
      writeable true
      sync true
      options ['root_squash','no_subtree_check']
      unique true
      notifies :run, 'execute[restart the NFS server]', :delayed
    end
  end
  # Restart nfs-server components
  execute 'restart the NFS server' do
    action :nothing
    command '/bin/systemctl restart nfs-kernel-server'
    group 'root'
    user 'root'
  end
else
  # Create the bash script for copying files
  node['scratchpads']['nfs']['templates']['clients'].each do|name,tmplte|
    template tmplte['path'] do
      path tmplte['path']
      source name
      cookbook tmplte['cookbook']
      owner tmplte['owner']
      group tmplte['group']
      mode tmplte['mode']
      action :create
    end
  end
  # We are not the control server, so must be an app server. We install the
  # client and add a mount point and mount!
  # Mount the folder from the control server
  include_recipe 'nfs::client4'
  if Chef::Config[:solo]
    control_host = {'fqdn' => 'sp-control-1'}
  else
    control_hosts = search(:node, "roles:#{node['scratchpads']['control']['role']}")
    control_host = control_hosts.first
  end
  node['scratchpads']['nfs']['exports'].each do|mount_dir,mount_to|
    # Create the mount directory
    directory mount_to do
      owner 'aegir'
      group 'www-data'
      mode 0775
      action :create
      not_if { ::File.exists?(mount_to)}
    end
    # Mount the directory
    mount mount_to do
      device "#{control_host['fqdn']}:#{mount_dir}"
      fstype 'nfs'
      options 'rw,noacl,nocto,bg,ac,noatime,nodiratime,intr,hard'
      action [:mount, :enable]
    end
  end
end