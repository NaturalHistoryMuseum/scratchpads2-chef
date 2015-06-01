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
directory "#{node['scratchpads']['solr-undertow']['data_folder']}/#{node['scratchpads']['solr-undertow']['solr_home_folder']}/scratchpads2" do
  owner node['scratchpads']['solr-undertow']['user']
  group node['scratchpads']['solr-undertow']['group']
  mode 0755
  action :create
  recursive
end
directory "#{node['scratchpads']['solr-undertow']['solr_logs_folder']}" do
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
  end

  # Extract the shit out of that release
  execute 'extract the solr-undertow release' do
    cwd node['scratchpads']['solr-undertow']['application_folder']
    command "tar xfz #{node['scratchpads']['solr-undertow']['release_version']}-#{node['scratchpads']['solr-undertow']['solr_version']}.tar.gz --strip-components 1"
    user node['scratchpads']['solr-undertow']['user']
    group node['scratchpads']['solr-undertow']['group']
    not_if { ::File.exists?("#{node['scratchpads']['solr-undertow']['application_folder']}/bin")}
  end
end

# Create the configuration file that is used to start solr-undertow
template node['scratchpads']['solr-undertow']['conf_file']['path'] do
  path node['scratchpads']['solr-undertow']['conf_file']['path']
  source node['scratchpads']['solr-undertow']['conf_file']['source']
  cookbook node['scratchpads']['solr-undertow']['conf_file']['cookbook']
  owner node['scratchpads']['solr-undertow']['conf_file']['owner']
  group node['scratchpads']['solr-undertow']['conf_file']['group']
  mode node['scratchpads']['solr-undertow']['conf_file']['mode']
  action :create
end

# Create a symlink to the wars folder
execute 'link to wars folder' do
  cwd node['scratchpads']['solr-undertow']['data_folder']
  command "ln -s #{node['scratchpads']['solr-undertow']['application_folder']}/example/solr-wars"
  user node['scratchpads']['solr-undertow']['user']
  group node['scratchpads']['solr-undertow']['group']
  not_if { ::File.exists?("#{node['scratchpads']['solr-undertow']['data_folder']}/solr-wars")}
end

# Create another configuration file that is used to start solr-undertow
template node['scratchpads']['solr-undertow']['conf_xml']['path'] do
  path node['scratchpads']['solr-undertow']['conf_xml']['path']
  source node['scratchpads']['solr-undertow']['conf_xml']['source']
  cookbook node['scratchpads']['solr-undertow']['conf_xml']['cookbook']
  owner node['scratchpads']['solr-undertow']['conf_xml']['owner']
  group node['scratchpads']['solr-undertow']['conf_xml']['group']
  mode node['scratchpads']['solr-undertow']['conf_xml']['mode']
  action :create
end

# Create the configuration file that is used to start solr-undertow
template node['scratchpads']['solr-undertow']['cfg_file']['path'] do
  path node['scratchpads']['solr-undertow']['cfg_file']['path']
  source node['scratchpads']['solr-undertow']['cfg_file']['source']
  cookbook node['scratchpads']['solr-undertow']['cfg_file']['cookbook']
  owner node['scratchpads']['solr-undertow']['cfg_file']['owner']
  group node['scratchpads']['solr-undertow']['cfg_file']['group']
  mode node['scratchpads']['solr-undertow']['cfg_file']['mode']
  action :create
end

# Copy the configuration from Scratchpads which is held in a tar.gz file
cookbook_file node['scratchpads']['solr-undertow']['scratchpads_conf']['path'] do
  path node['scratchpads']['solr-undertow']['scratchpads_conf']['path']
  source node['scratchpads']['solr-undertow']['scratchpads_conf']['source']
  cookbook node['scratchpads']['solr-undertow']['scratchpads_conf']['cookbook']
  owner node['scratchpads']['solr-undertow']['scratchpads_conf']['owner']
  group node['scratchpads']['solr-undertow']['scratchpads_conf']['group']
  mode node['scratchpads']['solr-undertow']['scratchpads_conf']['mode']
end
# Extract the scratchpads conf
execute 'extract the scratchpads conf' do
  cwd "#{node['scratchpads']['solr-undertow']['data_folder']}/solr-home/scratchpads2"
  command "tar xfz #{node['scratchpads']['solr-undertow']['scratchpads_conf']['source']}"
  user node['scratchpads']['solr-undertow']['user']
  group node['scratchpads']['solr-undertow']['group']
  not_if { ::File.exists?("#{node['scratchpads']['solr-undertow']['data_folder']}/solr-home/scratchpads2/conf")}
end

# Create the bash script that starts the server
template node['scratchpads']['solr-undertow']['bash_script']['path'] do
  path node['scratchpads']['solr-undertow']['bash_script']['path']
  source node['scratchpads']['solr-undertow']['bash_script']['source']
  cookbook node['scratchpads']['solr-undertow']['bash_script']['cookbook']
  owner node['scratchpads']['solr-undertow']['bash_script']['owner']
  group node['scratchpads']['solr-undertow']['bash_script']['group']
  mode node['scratchpads']['solr-undertow']['bash_script']['mode']
  action :create
end

# Create solr-undertow service
execute 'restart_systemctl_daemon' do
  command 'systemctl daemon-reload'
  action :nothing
end
template node['scratchpads']['solr-undertow']['systemd_service']['path'] do
  path node['scratchpads']['solr-undertow']['systemd_service']['path']
  source node['scratchpads']['solr-undertow']['systemd_service']['source']
  cookbook node['scratchpads']['solr-undertow']['systemd_service']['cookbook']
  owner node['scratchpads']['solr-undertow']['systemd_service']['owner']
  group node['scratchpads']['solr-undertow']['systemd_service']['group']
  mode node['scratchpads']['solr-undertow']['systemd_service']['mode']
  action :create
  notifies :run, 'execute[restart_systemctl_daemon]', :immediately
end

# Start the service
service 'solr-undertow' do
  action [:enable, :start]
  provider Chef::Provider::Service::Systemd
end