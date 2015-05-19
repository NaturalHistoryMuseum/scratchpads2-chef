#
# Cookbook Name:: scratchpads
# Recipe:: control
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# Update apt repository and update
include_recipe 'apt'

# Install percona (MySQL) server and client, and secure it.
include_recipe 'scratchpads::percona'

# Install Git client
include_recipe 'git'

# Install Apache2 and set it to use prefork and mod_php5
include_recipe 'apache2'
include_recipe 'apache2::mpm_prefork'

# PHP Package
include_recipe 'php'
# Install drush from pear
dc = php_pear_channel "pear.drush.org" do
  action :discover
end
php_pear "drush" do
  channel dc.channel_name
  action :install
end

# Add mod_php once PHP has been installed
include_recipe 'apache2::mod_php5'

# Install NFS server and set it to allow access to certain servers.
include_recipe 'nfs::server'
nfs_export "/var/aegir/platforms" do
  network ['sp-app-1','sp-app-2', 'sp-app-3', 'sp-app-4']
  writeable true
  sync true
  options ['no_subtree_check']
end

# Create the aegir user
# Add a database user using the password in the passwords bag.
passwords = EncryptedPasswords.new(node, node["scratchpads"]["encrypted_data_bag"])
root_pw = passwords.root_password
aegir_pw = passwords.find_password "mysql", "aegir"
mysql_database_user node['scratchpads']['control']['aegir']['dbuser'] do
  connection(
    :host => node['scratchpads']['control']['dbserver'],
    :username => node['scratchpads']['control']['dbuser'],
    :password => root_pw
  )
  password aegir_pw
  host node['scratchpads']['control']['aegir']['dbuserhost']
  action [:create, :grant]
  grant_option true
end

include_recipe 'postfix'

include_recipe 'scratchpads::aegir'

include_recipe 'imagemagick'

include_recipe 'gkrellmd'

include_recipe 'varnish'
