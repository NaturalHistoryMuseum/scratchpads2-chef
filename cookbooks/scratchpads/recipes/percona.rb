#
# Cookbook Name:: scratchpads
# Recipe:: percona
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# Manually add the Percona apt repository, as we need to use
# the wheezy repo, and not the jessie one (which isn't yet
# complete).
apt_repository 'percona' do
  uri node['percona']['apt_uri']
  distribution 'wheezy'
  components ['main']
  keyserver node['percona']['apt_keyserver']
  key node['percona']['apt_key']
end

# Install the client and server.
include_recipe 'percona::client'