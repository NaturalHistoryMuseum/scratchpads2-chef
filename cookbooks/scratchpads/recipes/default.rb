#
# Cookbook Name:: scratchpads
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# Add the search site
all_hosts = []
if Chef::Config[:solo]
  control_hosts = []
else
  control_hosts = search(:node, "roles:#{node['scratchpads']['control']['role']} AND chef_environment:#{node.chef_environment}")
  # Add all hosts to the list (this may cause issues if we have dev boxes using the same chef server - need to look into this)
  all_hosts_search = search(:node, "chef_environment:#{node.chef_environment}")
  all_hosts_search.each do|app_host|
    unless app_host['fqdn'].nil?
      all_hosts << app_host['fqdn']
    end
  end
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

# Set the swappiness on all machines to 0 (we always want to use memory over swap)
append_if_no_line "set swappiness to 0" do
  path '/etc/sysctl.conf'
  line 'vm.swappiness = 0'
end

# Add the prefix to the hosts in case we have one.
hosts = {}
if node['fqdn'].index('sp-') > 0
  node.default['scratchpads']['hostname_prefix'] = node['fqdn'][0, node['fqdn'].index('sp-')]
  Chef::Log.info("Hostname prefix: #{node.default['scratchpads']['hostname_prefix']}")
  node['scratchpads']['hosts']['variables']['hosts'].each do|ip_address,hostname|
    hostname_parts = hostname.split('.')
    hosts[ip_address] = {"fqdn" => "#{node.default['scratchpads']['hostname_prefix']}#{hostname}", "hostname" => "#{node.default['scratchpads']['hostname_prefix']}#{hostname_parts[0]}"}
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

# link /etc/iptables/rules.v4 to /etc/iptables/general
link '/etc/iptables/rules.v4' do
  action :create
  group 'root'
  owner 'root'
  to '/etc/iptables/general'
end
# Rebuild the iptables once an hour
cron 'rebuild-iptables' do
  command '/usr/sbin/rebuild-iptables'
  minute '1'
  mailto node['scratchpads']['control']['admin_email']
  user 'root'
end

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
