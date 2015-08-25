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

# Add monit checks for each role.
# Add check for varnish to control role
monit_check 'varnish' do
  cookbook node['scratchpads']['monit']['varnish']['cookbook']
  check_type node['scratchpads']['monit']['varnish']['check_type']
  check_id node['scratchpads']['monit']['varnish']['check_id']
  id_type node['scratchpads']['monit']['varnish']['id_type']
  start node['scratchpads']['monit']['varnish']['start']
  stop node['scratchpads']['monit']['varnish']['stop']
  group node['scratchpads']['monit']['varnish']['group']
  tests node['scratchpads']['monit']['varnish']['tests']
  only_if {node['roles'].index(node['scratchpads']['control']['role'])}
end
# Add check for apache to control and app role.
monit_check 'apache2' do
  cookbook node['scratchpads']['monit']['apache2']['cookbook']
  check_type node['scratchpads']['monit']['apache2']['check_type']
  check_id node['scratchpads']['monit']['apache2']['check_id']
  id_type node['scratchpads']['monit']['apache2']['id_type']
  start node['scratchpads']['monit']['apache2']['start']
  stop node['scratchpads']['monit']['apache2']['stop']
  group node['scratchpads']['monit']['apache2']['group']
  tests node['scratchpads']['monit']['apache2']['tests']
  only_if {node['roles'].index(node['scratchpads']['control']['role']) || node['roles'].index(node['scratchpads']['app']['role'])}
end
# elsif node['roles'].index(node['scratchpads']['data']['role']) then
# elsif node['roles'].index(node['scratchpads']['app']['role']) then
# elsif node['roles'].index(node['scratchpads']['search']['role']) then