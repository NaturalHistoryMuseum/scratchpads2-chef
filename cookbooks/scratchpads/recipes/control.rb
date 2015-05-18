#
# Cookbook Name:: scratchpads
# Recipe:: control
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

include_recipe 'apt'

# Git
include_recipe 'git'

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

include_recipe 'apache2'
include_recipe 'apache2::mpm_prefork'
include_recipe 'apache2::mod_php5'

include_recipe 'nfs::server'
nfs_export "/var/aegir/platforms" do
  network ['sp-app-1','sp-app-2', 'sp-app-3', 'sp-app-4']
  writeable true
  sync true
  options ['no_subtree_check']
end

# Manually add the Percona apt repository, as we need to use
# the wheezy repo, and not the jessie one (which isn't yet
# complete).
apt_repository "percona" do
  uri node["percona"]["apt_uri"]
  distribution "wheezy"
  components ["main"]
  keyserver node["percona"]["apt_keyserver"]
  key node["percona"]["apt_key"]
end
include_recipe 'percona::client'
include_recipe 'percona::server'

# Execute the Percona SQL to create the functions
include_recipe 'scratchpads::percona-functions'
include_recipe 'scratchpads::secure-installation'

# Install the mysql2_chef_gem as required by database
mysql2_chef_gem 'default' do
  provider Chef::Provider::Mysql2ChefGem::Percona
  action :install
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
