#
# Cookbook Name:: scratchpads
# Recipe:: secure-installation
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# Copy the secure-installation SQL file.
cookbook_file node['scratchpads']['percona']['secure-installation-file'] do
  source 'secure-installation.sql'
  owner 'root'
  group 'root'
  mode '0600'
end

# Execute the SQL using the password set in the Percona passwords bag.
passwords = EncryptedPasswords.new(node, node["scratchpads"]["percona"]["encrypted_data_bag"])
execute 'secure installation' do
  root_pw = passwords.root_password
  command "mysql -h #{node['scratchpads']['percona']['host']} -u #{node['scratchpads']['percona']['username']} -p'#{root_pw}' < #{node['scratchpads']['percona']['secure-installation-file']}"
end
