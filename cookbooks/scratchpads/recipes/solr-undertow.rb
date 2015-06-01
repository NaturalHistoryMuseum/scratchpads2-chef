#
# Cookbook Name:: scratchpads
# Recipe:: solr-undertow
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# Create a solrundertow group
group node['scratchpads']['solr-undertow']['group']
# Create the solrundertow user
user node['scratchpads']['solr-undertow']['user'] do
  group node['scratchpads']['solr-undertow']['group']
  system true
  shell node['scratchpads']['solr-undertow']['shell']
  comment node['scratchpads']['solr-undertow']['comment']
  home node['scratchpads']['solr-undertow']['data_folder']
  manage_home
end

# Check out the solr-undertow repository
git "#{node['scratchpads']['solr-undertow']['application_folder']}" do
  repository node['scratchpads']['solr-undertow']['repository']
  group node['scratchpads']['solr-undertow']['group']
  user node['scratchpads']['solr-undertow']['user']
end

# Create the bash script that starts the server
template "#{node['scratchpads']['solr-undertow']['bash_script']}" do
  path "#{node['scratchpads']['solr-undertow']['bash_script']}"
  source 'solr-undertow.bash.erb'
  cookbook 'scratchpads'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

# Create solr-undertow service
execute 'restart_systemctl_daemon' do
  command 'systemctl daemon-reload'
  action :nothing
end
template "#{node['scratchpads']['solr-undertow']['service_path']}" do
  path "#{node['scratchpads']['solr-undertow']['service_path']}"
  source "#{node['scratchpads']['solr-undertow']['service_template']}"
  cookbook "#{node['scratchpads']['solr-undertow']['service_template_cookbook']}"
  owner 'root'
  group 'root'
  mode '0644'
  action :create
  notifies :run, 'execute[restart_systemctl_daemon]', :immediately
  notifies :restart, 'service[solr-undertow]', :delayed
end