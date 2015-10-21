#
# Cookbook Name:: scratchpads
# Recipe:: nfs
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# Check if we are the Control server, which has the NFS server installed.
if node['roles'].index(node['scratchpads']['control']['role']) then
  # Install NFS server and set it to allow access to certain servers.
  include_recipe 'nfs::server4'
  client_hosts = node['scratchpads']['nfs']['default_hosts'].dup
  unless Chef::Config[:solo]
    client_hosts_search = search(:node, "(roles:#{node['scratchpads']['app']['role']} OR roles:#{node['scratchpads']['data']['role']}) AND chef_environment:#{node.chef_environment}")
    if client_hosts_search.length > 0
      client_hosts_search.each do|client_host|
        Chef::Log.info("Added #{client_host['fqdn']} to nfs clients")
        client_hosts << client_host['fqdn']
      end
      node.default['scratchpads']['nfs']['hosts'] = client_hosts
    end
  end
  node['scratchpads']['nfs']['exports'].each do|mount_dir,nfs_mnt|
    nfs_export mount_dir do
      network client_hosts
      writeable nfs_mnt['writeable']
      sync nfs_mnt['sync']
      options nfs_mnt['options']
      unique nfs_mnt['unique']
      notifies :run, 'execute[restart the NFS server]', :delayed
    end
  end
  # Restart nfs-server components
  execute 'restart the NFS server' do
    action :nothing
    command '/bin/systemctl reload nfs-kernel-server'
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
    control_hosts = search(:node, "roles:#{node['scratchpads']['control']['role']} AND chef_environment:#{node.chef_environment}")
    control_host = control_hosts.first
  end
  node['scratchpads']['nfs']['exports'].each do|mount_dir,nfs_mnt|
    # Create the mount directory
    directory mount_dir do
      owner 'root'
      group 'root'
      mode 0775
      action :create
      recursive true
      not_if { ::File.exists?(mount_dir)}
    end
    # Mount the directory
    mount mount_dir do
      device "#{control_host['fqdn']}:#{mount_dir}"
      fstype 'nfs'
      options nfs_mnt['mount_options']
      action [:mount, :enable]
    end
  end
end