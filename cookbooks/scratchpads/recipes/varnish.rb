#
# Cookbook Name:: scratchpads
# Recipe:: varnish
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# Varnish
node.default['varnish']['listen_address'] = node['fqdn']
include_recipe 'varnish'
service 'varnishncsa'
# Note, we hardcode the cookbook here to scratchpads so that the varnish
# default recipe uses its own cookbook which builds and allows the service
# to be restarted.
if Chef::Config[:solo]
  app_hosts = {'sp-app-1' => {'fqdn' => 'sp-app-1'}}
else
  app_hosts = search(:node, "roles:#{node['scratchpads']['app']['role']} AND chef_environment:#{node.chef_environment}")
  search_master_hosts = search(:node, "roles:#{node['scratchpads']['search']['role']} AND chef_environment:#{node.chef_environment}")
  search_slave_hosts = search(:node, "(roles:#{node['scratchpads']['search-slave']['role']} OR roles:#{node['scratchpads']['search']['role']}) AND chef_environment:#{node.chef_environment}")
end
template "/etc/logrotate.d/varnish" do
  source 'varnish-logrotate.erb'
  cookbook 'scratchpads'
  owner 'root'
  group 'root'
  mode 0644
end
template "#{node['varnish']['dir']}/#{node['varnish']['vcl_conf']}" do
  source node['varnish']['vcl_source']
  cookbook 'scratchpads'
  owner 'root'
  group 'root'
  mode 0644
  notifies :reload, 'service[varnish]', :delayed
  notifies :restart, 'service[varnishncsa]', :delayed
  variables({
    :sp_app_servers => app_hosts,
    :sp_search_master_servers => search_master_hosts,
    :sp_search_slave_servers => search_slave_hosts
  })
end
template "/usr/local/sbin/clear-site-from-varnish" do
  source 'clear-site-from-varnish.erb'
  cookbook 'scratchpads'
  owner 'root'
  group 'root'
  mode 0755
end
# Add the maintenance varnish configuration.
template "#{node['varnish']['dir']}/maintenance.vcl" do
  source 'maintenance.vcl.erb'
  cookbook 'scratchpads'
  owner 'root'
  group 'root'
  mode 0644
end
# Add the maintenance HTML file
template "#{node['varnish']['dir']}/maintenance.html" do
  source 'maintenance.html.erb'
  cookbook 'scratchpads'
  owner 'root'
  group 'root'
  mode 0644
end
# Add the script which turns maintenance mode on. To turn maintenance mode off Varnish must simply be restarted.
template '/usr/local/sbin/varnish-maintenance' do
  source 'varnish-maintenance.erb'
  cookbook 'scratchpads'
  owner 'root'
  group 'root'
  mode 0700
end
execute 'restart_systemctl_daemon' do
  command 'systemctl daemon-reload'
  action :nothing
end
template '/etc/systemd/system/varnish.service' do
  path '/etc/systemd/system/varnish.service'
  source 'varnish.service.erb'
  cookbook 'scratchpads'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
  notifies :run, 'execute[restart_systemctl_daemon]', :immediately
  notifies :restart, 'service[varnish]', :delayed
end
template '/etc/systemd/system/varnishncsa.service' do
  path '/etc/systemd/system/varnishncsa.service'
  source 'varnishncsa.service.erb'
  cookbook 'scratchpads'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
  notifies :run, 'execute[restart_systemctl_daemon]', :immediately
  notifies :restart, 'service[varnishncsa]', :delayed
end
passwords = ScratchpadsEncryptedData.new(node)
node.default['scratchpads']['varnish']['varnish_secret'] = passwords.get_encrypted_data 'varnish', 'secret'
template node['varnish']['secret_file'] do
  source 'secret.erb'
  cookbook 'scratchpads'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
  notifies :restart, 'service[varnish]', :delayed
  notifies :restart, 'service[varnishncsa]', :delayed
end
# Install required packages
package ['libvarnishapi-dev','pkg-config','python-docutils']
# Clone the libvmod-vsthrottle module
git '/var/chef/libvmod-vsthrottle' do
  repository node['scratchpads']['varnish']['throttle']['git']['uri']
  user 'root'
  group 'root'
  revision node['scratchpads']['varnish']['throttle']['git']['revision']
end
# Run autogen.sh
execute 'libvmod-vsthrottle autogen.sh' do
  command './autogen.sh'
  group 'root'
  user 'root'
  cwd '/var/chef/libvmod-vsthrottle'
  creates '/var/chef/libvmod-vsthrottle/configure'
end
# Run configure
execute 'libvmod-vsthrottle configure' do
  command './configure'
  group 'root'
  user 'root'
  cwd '/var/chef/libvmod-vsthrottle'
  creates '/var/chef/libvmod-vsthrottle/src/Makefile'
end
# Run make
execute 'libvmod-vsthrottle make' do
  command 'make'
  group 'root'
  user 'root'
  cwd '/var/chef/libvmod-vsthrottle'
  creates '/var/chef/libvmod-vsthrottle/src/.libs/vmod_vsthrottle.o'
end
# Run make install
execute 'libvmod-vsthrottle make install' do
  command 'make install'
  group 'root'
  user 'root'
  cwd '/var/chef/libvmod-vsthrottle'
  creates '/usr/lib/varnish/vmods/libvmod_vsthrottle.so'
end