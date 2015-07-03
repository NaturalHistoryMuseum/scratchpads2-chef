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
  client_hosts = node['scratchpads']['nfs']['default_hosts']
  unless Chef::Config[:solo]
    client_hosts_search = search(:node, "roles:#{node['scratchpads']['app']['role']} OR roles:#{node['scratchpads']['data']['role']}")
    client_hosts_search.each do|client_host|
      client_hosts << client_host['fqdn']
    end
  end
  node['scratchpads']['nfs']['exports'].each do|mount_dir|
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
  node['scratchpads']['nfs']['exports'].each do|mount_dir|
    # Create the mount directory
    directory mount_dir do
      owner 'aegir'
      group 'www-data'
      mode 0775
      action :create
      not_if { ::File.exists?(mount_dir)}
    end
    # Mount the directory
    mount mount_dir do
      device "#{control_host['fqdn']}:#{mount_dir}"
      fstype 'nfs'
      options 'rw,noacl,nocto,bg,ac,noatime,nodiratime'
      action [:mount, :enable]
    end
  end
end