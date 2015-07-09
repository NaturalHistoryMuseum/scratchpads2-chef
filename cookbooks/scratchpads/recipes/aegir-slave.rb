#
# Cookbook Name:: scratchpads
# Recipe:: aegir-slave
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# Save SSH keys
enc_data_bag = ScratchpadsEncryptedData.new(node, 'ssh')
lines = enc_data_bag.get_encrypted_data 'aegir', 'public'
template "#{node['scratchpads']['aegir']['home_folder']}/.ssh/authorized_keys" do
  path "#{node['scratchpads']['aegir']['home_folder']}/.ssh/authorized_keys"
  source 'empty-file.erb'
  cookbook 'scratchpads'
  owner node['scratchpads']['aegir']['user']
  group node['scratchpads']['aegir']['group']
  mode '0744'
  action :create
  variables({
    :lines => lines
  })
end

# Create the local platforms directory if we're an application server
directory default['scratchpads']['aegir']['platforms_directory'] do
  owner node['scratchpads']['aegir']['user']
  group node['scratchpads']['aegir']['group']
  mode 0755
  action :create
  not_if {::File.exists?(default['scratchpads']['aegir']['platforms_directory'])}
end