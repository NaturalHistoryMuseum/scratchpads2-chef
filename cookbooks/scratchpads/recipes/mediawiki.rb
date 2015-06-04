#
# Cookbook Name:: scratchpads
# Recipe:: mediawiki
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# Start by downloading the specific version of Mediawiki to the /var/chef folder.
remote_file "#{node['scratchpads']['mediawiki']['download']['path']}/#{node['scratchpads']['mediawiki']['download']['filename']}" do
  source node['scratchpads']['mediawiki']['download']['download_url']
  action :create_if_missing
end

# Create the directory to extract to
directory node['scratchpads']['mediawiki']['install_location'] do
  user node['apache']['user']
  group node['apache']['group']
  action :create
  mode 0755
end

# Next, extract the contents of the mediawiki directory to the install location
execute 'extract mediawiki' do
  cwd node['scratchpads']['mediawiki']['install_location']
  command "tar xfz #{node['scratchpads']['mediawiki']['download']['path']}/#{node['scratchpads']['mediawiki']['download']['filename']} --strip-components 1"
  user node['apache']['user']
  group node['apache']['group']
  not_if { ::File.exists?("#{node['scratchpads']['mediawiki']['install_location']}/index.php")}
end