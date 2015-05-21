#
# Cookbook Name:: scratchpads
# Recipe:: app
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# First we remove the 127.0.1.1 entry from the hosts file
hostsfile_entry '127.0.1.1' do
  action    :remove
end

# Update apt repository and update
include_recipe 'apt'

# Install Apache2 and set it to use prefork and mod_php5
include_recipe 'apache2'
include_recipe 'apache2::mpm_prefork'
include_recipe 'apache2::mod_php5'

# PHP Package
# PHP has probably already been dragged in by mod_php5, but we still need to add
# other features/settings.
include_recipe 'php'
# Install drush from pear
dc = php_pear_channel "pear.drush.org" do
  action :discover
end
php_pear "drush" do
  channel dc.channel_name
  action :install
end

# Create the aegir user and the various aegir stuff
include_recipe 'scratchpads::aegir'

# Create the aegir directory
directory '/var/aegir/platforms' do
  owner 'aegir'
  group 'www-data'
  mode 0777
  action :create
end

# Mount the folder from the control server
include_recipe 'nfs::client4'
if Chef::Config[:solo]
  control_hosts = {"sp-control-1" => {"fqdn" => "sp-control-1"}}
else
  control_hosts = search(:node, "role:control")
end
control_host = control_hosts.first
mount "/var/aegir/platforms" do
  device "#{control_host['fqdn']}:/var/aegir/platforms"
  fstype "nfs"
  options "rw,bg,ac,noatime"
  action [:mount, :enable]
end
