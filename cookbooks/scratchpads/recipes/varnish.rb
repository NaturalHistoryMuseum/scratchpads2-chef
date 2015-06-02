#
# Cookbook Name:: scratchpads
# Recipe:: varnish
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# Varnish
node.default['varnish']['listen_address'] = node['fqdn']
include_recipe 'varnish'
# Note, we hardcode the cookbook here to scratchpads so that the varnish
# default recipe uses its own cookbook which builds and allows the service
# to be restarted.
if Chef::Config[:solo]
  app_hosts = {'sp-app-1' => {'fqdn' => 'sp-app-1'}}
else
  app_hosts = search(:node, 'flags:UP AND roles:app')
  search_master_hosts = search(:node, 'flags:UP AND roles:search')
  search_slave_hosts = search(:node, 'flags:UP AND roles:search-slave')
end
template "#{node['varnish']['dir']}/#{node['varnish']['vcl_conf']}" do
  source node['varnish']['vcl_source']
  cookbook 'scratchpads'
  owner 'root'
  group 'root'
  mode 0644
  notifies :reload, 'service[varnish]', :delayed
  variables({
    :sp_app_servers => app_hosts,
    :sp_search_master_servers => search_master_hosts,
    :sp_search_slave_servers => search_slave_hosts
  })
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
passwords = ScratchpadsEncryptedPasswords.new(node, node['scratchpads']['encrypted_data_bag'])
varnish_secret = passwords.find_password 'varnish', 'secret'
execute 'update varnish secret file' do
  command "echo \"#{varnish_secret}\" > #{node['varnish']['secret_file']}"
  group 'root'
  user 'root'
end
