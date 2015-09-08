#
# Cookbook Name:: scratchpads
# Recipe:: percona
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# Include the percona recipes
include_recipe 'percona::server'
include_recipe 'percona::backup'

# Install the mysql2_chef_gem as required by database
mysql2_chef_gem 'default' do
  provider Chef::Provider::Mysql2ChefGem::Percona
  action :install
end

# Load the passwords only once
passwords = ScratchpadsEncryptedData.new(node)

# Copy the percona-functions SQL file and execute it
unless(::File.exists?("/var/chef/#{node['scratchpads']['percona']['percona-functions-file']}"))
  cookbook_file "/var/chef/#{node['scratchpads']['percona']['percona-functions-file']}" do
    source node['scratchpads']['percona']['percona-functions-file']
    cookbook 'scratchpads'
    owner 'root'
    group 'root'
    mode '0400'
    notifies :run, 'execute[percona functions]', :immediately
  end
  execute 'percona functions' do
    action :nothing
    root_pw = passwords.get_encrypted_data 'mysql', 'root'
    command "mysql -h #{node['scratchpads']['control']['dbserver']} -u #{node['scratchpads']['control']['dbuser']} -p'#{root_pw}' < /var/chef/#{node['scratchpads']['percona']['percona-functions-file']}"
  end
end

# Copy the secure-installation SQL file and execute it
unless(::File.exists?("/var/chef/#{node['scratchpads']['percona']['secure-installation-file']}"))
  cookbook_file "/var/chef/#{node['scratchpads']['percona']['secure-installation-file']}" do
    source node['scratchpads']['percona']['secure-installation-file']
    cookbook 'scratchpads'
    owner 'root'
    group 'root'
    mode '0400'
    notifies :run, 'execute[secure installation]', :immediately
  end
  execute 'secure installation' do
    action :nothing
    root_pw = passwords.get_encrypted_data 'mysql', 'root'
    command "mysql -h #{node['scratchpads']['control']['dbserver']} -u #{node['scratchpads']['control']['dbuser']} -p'#{root_pw}' < /var/chef/#{node['scratchpads']['percona']['secure-installation-file']}"
  end
end

# Copy the gm3.sql.gz SQL file and load it
unless(::File.exists?("/var/chef/#{node['scratchpads']['percona']['gm3_data_file']}"))
  cookbook_file "/var/chef/#{node['scratchpads']['percona']['gm3_data_file']}" do
    source node['scratchpads']['percona']['gm3_data_file']
    cookbook 'scratchpads'
    owner 'root'
    group 'root'
    mode '0400'
  end
  # Create the GM3 user
  gm3_pw = passwords.get_encrypted_data 'mysql', 'gm3'
  root_pw = passwords.get_encrypted_data 'mysql', 'root'
  mysql_database 'gm3' do
    connection(
      :host => node['scratchpads']['control']['dbserver'],
      :username => node['scratchpads']['control']['dbuser'],
      :password => root_pw
    )
    action :create
  end
  mysql_database_user 'gm3' do
    connection(
      :host => node['scratchpads']['control']['dbserver'],
      :username => node['scratchpads']['control']['dbuser'],
      :password => root_pw
    )
    password gm3_pw
    database_name 'gm3'
    host node['scratchpads']['control']['aegir']['dbuserhost']
    action [:create, :grant]
  end
  execute 'load gm3 data' do
    root_pw = passwords.get_encrypted_data 'mysql', 'root'
    command "zcat /var/chef/#{node['scratchpads']['percona']['gm3_data_file']} | mysql -h #{node['scratchpads']['control']['dbserver']} -u #{node['scratchpads']['control']['dbuser']} -p'#{root_pw}' gm3"
  end
end

# Add the cron stuff
template "/etc/cron.d/xtrabackup" do
  source 'xtrabackup-cron.erb'
  cookbook 'scratchpads'
  owner 'root'
  group 'root'
  mode '0744'
  action :create
end

# Create the aegir user
# Add a database user using the password in the passwords bag.
root_pw = passwords.get_encrypted_data 'mysql', 'root'
aegir_pw = passwords.get_encrypted_data 'mysql', 'aegir'
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