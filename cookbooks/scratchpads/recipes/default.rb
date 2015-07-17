#
# Cookbook Name:: scratchpads
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# First we remove the 127.0.1.1 entry from the hosts file
hostsfile_entry '127.0.1.1' do
  action    :remove
end
# Add the search site
if Chef::Config[:solo]
  control_hosts = []
else
  control_hosts = search(:node, "roles:#{node['scratchpads']['control']['role']}")
end

template node['scratchpads']['gkrellmd']['path'] do
  source node['scratchpads']['gkrellmd']['source']
  cookbook node['scratchpads']['gkrellmd']['cookbook']
  owner node['scratchpads']['gkrellmd']['owner']
  group node['scratchpads']['gkrellmd']['group']
  mode node['scratchpads']['gkrellmd']['mode']
end

# Install monit
# include_recipe 'scratchpads::monit'

# Install various packages that are useful on all machines.
package ['gkrellmd','htop','iotop','rsync','unzip']

# Add a template for the gkrellmd service
template node['scratchpads']['gkrellmd']['path'] do
  source node['scratchpads']['gkrellmd']['source']
  cookbook node['scratchpads']['gkrellmd']['cookbook']
  owner node['scratchpads']['gkrellmd']['owner']
  group node['scratchpads']['gkrellmd']['group']
  mode node['scratchpads']['gkrellmd']['mode']
  notifies :restart, 'service[gkrellmd]', :delayed
end

# Gkrellmd service
service 'gkrellmd'