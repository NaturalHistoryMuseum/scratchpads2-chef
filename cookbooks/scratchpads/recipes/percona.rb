#
# Cookbook Name:: scratchpads
# Recipe:: percona
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

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

# Install the client and server.
include_recipe 'percona::client'
include_recipe 'percona::server'

# Install the mysql2_chef_gem as required by database
mysql2_chef_gem 'default' do
  provider Chef::Provider::Mysql2ChefGem::Percona
  action :install
end

# Copy the percona-functions SQL file.
cookbook_file node['scratchpads']['percona']['percona-functions-file'] do
  source 'percona-functions.sql'
  owner 'root'
  group 'root'
  mode '0600'
end

# Execute the MySQL using the password set in the Percona passwords bag.
passwords = EncryptedPasswords.new(node, node["scratchpads"]["encrypted_data_bag"])
execute 'percona functions' do
  root_pw = passwords.root_password
  command "mysql -h #{node['scratchpads']['control']['dbserver']} -u #{node['scratchpads']['control']['dbuser']} -p'#{root_pw}' < #{node['scratchpads']['percona']['percona-functions-file']}"
end

# Copy the secure-installation SQL file.
cookbook_file node['scratchpads']['percona']['secure-installation-file'] do
  source 'secure-installation.sql'
  owner 'root'
  group 'root'
  mode '0600'
end

# Execute the SQL using the password set in the Percona passwords bag.
passwords = EncryptedPasswords.new(node, node["scratchpads"]["encrypted_data_bag"])
execute 'secure installation' do
  root_pw = passwords.root_password
  command "mysql -h #{node['scratchpads']['control']['dbserver']} -u #{node['scratchpads']['control']['dbuser']} -p'#{root_pw}' < #{node['scratchpads']['percona']['secure-installation-file']}"
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


