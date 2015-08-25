#
# Cookbook Name:: scratchpads
# Recipe:: monit
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# Install Mmonit on the control server
if node['roles'].index(node['scratchpads']['control']['role']) then
  mmonit = ScratchpadsEncryptedData.new(node, 'mmonit')
  node.default['mmonit']['license_owner'] = mmonit.get_encrypted_data 'mmonit', 'license_owner'
  node.default['mmonit']['license'] = mmonit.get_encrypted_data 'mmonit', 'license'
  include_recipe 'mmonit'
end

# Set the URL of the mmonit server and set which hosts can connect to monit.
if Chef::Config[:solo]
  control_hosts_search = []
else
  control_hosts_search = search(:node, "roles:#{node['scratchpads']['control']['role']}")
end
control_hosts_search.each do|control_host|
  node.default['monit']['config']['mmonit_url'] = "http://monit:monit@#{control_host['fqdn']}:8080/collector"
  node.default['monit']['config']['allow'] << control_host['fqdn']
end
node.default['monit']['config']['listen'] = node['fqdn']

# Install 'basic' monit on each server
include_recipe 'monit-ng::install'
include_recipe 'monit-ng::configure'

# Add monit checks
node['scratchpads']['monit']['conf'].each do|index,monit_conf|
  monit_check index do
    cookbook monit_conf['cookbook']
    check_type monit_conf['check_type']
    check_id monit_conf['check_id']
    id_type monit_conf['id_type']
    start monit_conf['start']
    stop monit_conf['stop']
    group monit_conf['group']
    tests monit_conf['tests']
    only_if {node['roles'].index(monit_conf['role'])}
  end
end