#
# Cookbook Name:: scratchpads
# Recipe:: percona-functions
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

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
