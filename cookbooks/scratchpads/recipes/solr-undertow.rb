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

# Create the folder to clone into
directory node['scratchpads']['solr-undertow']['application_folder'] do
  owner node['scratchpads']['solr-undertow']['user']
  group node['scratchpads']['solr-undertow']['group']
  mode 0755
  action :create
end 
directory node['scratchpads']['solr-undertow']['data_folder'] do
  owner node['scratchpads']['solr-undertow']['user']
  group node['scratchpads']['solr-undertow']['group']
  mode 0755
  action :create
end
directory "#{node['scratchpads']['solr-undertow']['data_folder']}/#{node['scratchpads']['solr-undertow']['solr_home_folder']}" do
  owner node['scratchpads']['solr-undertow']['user']
  group node['scratchpads']['solr-undertow']['group']
  mode 0755
  action :create
  recursive true
end
directory "#{node['scratchpads']['solr-undertow']['data_folder']}/#{node['scratchpads']['solr-undertow']['solr_home_folder']}/scratchpads2" do
  owner node['scratchpads']['solr-undertow']['user']
  group node['scratchpads']['solr-undertow']['group']
  mode 0755
  action :create
  recursive true
end
directory "#{node['scratchpads']['solr-undertow']['data_folder']}/#{node['scratchpads']['solr-undertow']['solr_home_folder']}/scratchpads2/data" do
  owner node['scratchpads']['solr-undertow']['user']
  group node['scratchpads']['solr-undertow']['group']
  mode 0755
  action :create
  recursive true
end
directory node['scratchpads']['solr-undertow']['solr_logs_folder'] do
  owner node['scratchpads']['solr-undertow']['user']
  group node['scratchpads']['solr-undertow']['group']
  mode 0755
  action :create
end

# Download the latest release.
unless(::File.exists?("#{node['scratchpads']['solr-undertow']['application_folder']}/#{node['scratchpads']['solr-undertow']['release_version']}-#{node['scratchpads']['solr-undertow']['solr_version']}.tar.gz"))
  remote_file "#{node['scratchpads']['solr-undertow']['application_folder']}/#{node['scratchpads']['solr-undertow']['release_version']}-#{node['scratchpads']['solr-undertow']['solr_version']}.tar.gz" do
    action :create
    source node['scratchpads']['solr-undertow']['release_url']
    owner node['scratchpads']['solr-undertow']['user']
    group node['scratchpads']['solr-undertow']['group']
    mode 0444
    notifies :run, 'execute[extract the solr-undertow release]', :immediately
  end
  # Extract the shit out of that release
  execute 'extract the solr-undertow release' do
    action :nothing
    cwd node['scratchpads']['solr-undertow']['application_folder']
    command "tar xfz #{node['scratchpads']['solr-undertow']['release_version']}-#{node['scratchpads']['solr-undertow']['solr_version']}.tar.gz --strip-components 1"
    user node['scratchpads']['solr-undertow']['user']
    group node['scratchpads']['solr-undertow']['group']
    not_if { ::File.exists?("#{node['scratchpads']['solr-undertow']['application_folder']}/bin")}
  end
end

node['scratchpads']['solr-undertow']['templates'].each do|name,tmplte|
  template tmplte['path'] do
    path tmplte['path']
    source tmplte['source']
    cookbook tmplte['cookbook']
    owner tmplte['owner']
    group tmplte['group']
    mode tmplte['mode']
    action :create
    notifies :run, 'execute[restart_systemctl_daemon]', :immediately
  end
end

# Create a symlink to the wars folder
link "#{node['scratchpads']['solr-undertow']['data_folder']}/solr-wars" do
  owner node['scratchpads']['solr-undertow']['user']
  group node['scratchpads']['solr-undertow']['group']
  action :create
  to "#{node['scratchpads']['solr-undertow']['application_folder']}/example/solr-wars"
end

# Copy the configuration from Scratchpads which is held in a tar.gz file
cookbook_file node['scratchpads']['solr-undertow']['scratchpads_conf']['path'] do
  path node['scratchpads']['solr-undertow']['scratchpads_conf']['path']
  source node['scratchpads']['solr-undertow']['scratchpads_conf']['source']
  cookbook node['scratchpads']['solr-undertow']['scratchpads_conf']['cookbook']
  owner node['scratchpads']['solr-undertow']['scratchpads_conf']['owner']
  group node['scratchpads']['solr-undertow']['scratchpads_conf']['group']
  mode node['scratchpads']['solr-undertow']['scratchpads_conf']['mode']
  notifies :run, 'execute[extract the scratchpads conf]', :immediately
end
# Extract the scratchpads conf
execute 'extract the scratchpads conf' do
  action :nothing
  cwd "#{node['scratchpads']['solr-undertow']['data_folder']}/solr-home/scratchpads2"
  command "tar xfz #{node['scratchpads']['solr-undertow']['scratchpads_conf']['source']}"
  user node['scratchpads']['solr-undertow']['user']
  group node['scratchpads']['solr-undertow']['group']
  not_if { ::File.exists?("#{node['scratchpads']['solr-undertow']['data_folder']}/solr-home/scratchpads2/conf")}
end

# Create solr-undertow service
execute 'restart_systemctl_daemon' do
  command 'systemctl daemon-reload'
  action :nothing
end

# Start the service
service 'solr-undertow' do
  action [:enable, :start]
  provider Chef::Provider::Service::Systemd
end

# Add the webserver IPTables rules
iptables_rule 'iptables_search'