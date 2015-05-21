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

# Create the aegir user
user 'aegir' do
  group 'www-data'
  system true
  shell '/bin/bash'
  comment 'User which runs all of the behind the scenes actions.'
  home '/var/aegir'
  manage_home
end
# Add the aegir user to sudoers and ensure it does not need a password.
sudo 'aegir' do
  user 'aegir'
  nopasswd true
end

# Install Gkrellmd on all servers
include_recipe 'gkrellmd'

# Only include the postfix recipe IF we are the control server
include_recipe 'postfix'
