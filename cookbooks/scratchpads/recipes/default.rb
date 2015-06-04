#
# Cookbook Name:: scratchpads
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# First we remove the 127.0.1.1 entry from the hosts file
hostsfile_entry '127.0.1.1' do
  action    :remove
end
node['scratchpads']['additional_hosts'].each do|hostname, ip|
  hostfile_entry ip do
    hostname hostname
    unique true
  end
end

# Update apt repository and update
include_recipe 'apt'

# Install Gkrellmd on all servers
include_recipe 'gkrellmd'

# Install rsync and unzip
package ['rsync','unzip']