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
require 'resolv'
control_hosts.each do|control_host|
  Resolv::DNS.new.each_address(control_host['fqdn']) do|addr|
    hostsfile_entry addr do
      hostname 'search.scratchpads.eu'
      aliases ['test.scratchpad', 'sp-control-1']
    end
  end
end
node['scratchpads']['additional_hosts'].each do|hostname, ip|
  hostsfile_entry ip do
    hostname hostname
    unique true
  end
end
# Finally we add entries for the FQDN to ensure that it works properly with the chef server
Resolv::DNS.new.each_address(node['fqdn']) do|addr|
  hostsfile_entry addr do
    hostname node['fqdn']
  end
end

# Update apt repository and update
include_recipe 'apt'

# Install Gkrellmd on all servers
include_recipe 'gkrellmd'

# Install rsync and unzip
package ['rsync','unzip']

# Install the mysql2_chef_gem as required by database
mysql2_chef_gem 'default' do
  provider Chef::Provider::Mysql2ChefGem::Percona
  action :install
end