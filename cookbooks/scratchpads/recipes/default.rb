#
# Cookbook Name:: scratchpads
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# Add the search site
if Chef::Config[:solo]
  control_hosts = []
else
  control_hosts = search(:node, "roles:#{node['scratchpads']['control']['role']}")
end

# Add all hosts to the list (this may cause issues if we have dev boxes using the same chef server - need to look into this)
all_hosts = []
all_hosts_search = search(:node, "*:*")
all_hosts_search.each do|app_host|
  all_hosts << app_host['fqdn']
end
node.default['scratchpads']['all_hosts'] = all_hosts

# Add the default IPTables rules
iptables_rule 'iptables_default'
# Add role specific IPTables rules
if node['roles'].index(node['scratchpads']['control']['role']) then
  iptables_rule 'iptables_control'
elsif node['roles'].index(node['scratchpads']['data']['role']) then
  iptables_rule 'iptables_data'
elsif node['roles'].index(node['scratchpads']['app']['role']) then
  iptables_rule 'iptables_app'
elsif node['roles'].index(node['scratchpads']['search']['role']) then
  iptables_rule 'iptables_search'
end

# Add the prefix to the hosts in case we have one.
hosts = {}
if node['fqdn'].index('sp-') > 0
  node.default['scratchpads']['hostname_prefix'] = node['fqdn'][0, node['fqdn'].index('sp-')]
  Chef::Log.info("Hostname prefix: #{node.default['scratchpads']['hostname_prefix']}")
  node['scratchpads']['hosts']['variables']['hosts'].each do|ip_address,hostname|
    hosts[ip_address] = "#{node.default['scratchpads']['hostname_prefix']}#{hostname}"
    Chef::Log.info("#{ip_address}: #{hostname} -> #{node.default['scratchpads']['hostname_prefix']}#{hostname}")
  end
  node.default['scratchpads']['hosts']['variables']['hosts'] = hosts
end

# /etc/hosts file
template node['scratchpads']['hosts']['path'] do
  source node['scratchpads']['hosts']['source']
  cookbook node['scratchpads']['hosts']['cookbook']
  owner node['scratchpads']['hosts']['owner']
  group node['scratchpads']['hosts']['group']
  mode node['scratchpads']['hosts']['mode']
  variables ({
    :hosts => hosts
  })
end

# /etc/resolv.conf file
template node['scratchpads']['resolv.conf']['path'] do
  source node['scratchpads']['resolv.conf']['source']
  cookbook node['scratchpads']['resolv.conf']['cookbook']
  owner node['scratchpads']['resolv.conf']['owner']
  group node['scratchpads']['resolv.conf']['group']
  mode node['scratchpads']['resolv.conf']['mode']
end

# Install various packages that are useful on all machines.
package ['gkrellmd','htop','iotop','rsync','unzip','iptables-persistent']

# Add a template for the gkrellmd service
template node['scratchpads']['gkrellmd']['path'] do
  source node['scratchpads']['gkrellmd']['source']
  cookbook node['scratchpads']['gkrellmd']['cookbook']
  owner node['scratchpads']['gkrellmd']['owner']
  group node['scratchpads']['gkrellmd']['group']
  mode node['scratchpads']['gkrellmd']['mode']
  notifies :restart, 'service[gkrellmd]', :delayed
end

# Gkrellmd service
service 'gkrellmd'
