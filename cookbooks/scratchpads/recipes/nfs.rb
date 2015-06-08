#
# Cookbook Name:: scratchpads
# Recipe:: nfs
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# Check if we are the Control server, which has the NFS server installed.
if node['roles'].index('control') then
  # Install NFS server and set it to allow access to certain servers.
  include_recipe 'nfs::server4'
  app_hosts = []
  unless Chef::Config[:solo]
    app_hosts_search = search(:node, 'roles:app')
    app_hosts_search.each do|app_host|
      app_hosts << app_host['fqdn']
    end
  end
  node['scratchpads']['nfs']['exports'].each do|mount_dir|
    nfs_export mount_dir do
      network app_hosts
      writeable true
      sync true
      options ['root_squash','no_subtree_check']
    end
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
  # Mount the folder from the control server
  include_recipe 'nfs::client4'
  if Chef::Config[:solo]
    control_host = {'fqdn' => 'sp-control-1'}
  else
    control_hosts = search(:node, 'flags:UP AND roles:control')
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
      options 'rw,bg,ac,noatime'
      action [:mount, :enable]
    end
  end
end
