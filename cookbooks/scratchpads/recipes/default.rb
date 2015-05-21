#
# Cookbook Name:: scratchpads
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# First we remove the 127.0.1.1 entry from the hosts file
hostsfile_entry '127.0.1.1' do
  action    :remove
end

# Update apt repository and update
include_recipe 'apt'

# Install Gkrellmd on all servers
include_recipe 'gkrellmd'

package ['rsync','unzip']