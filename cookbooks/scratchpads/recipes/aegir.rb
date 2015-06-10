#
# Cookbook Name:: scratchpads
# Recipe:: aegir
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# Alter the www-data group, ensuring it always has the ID of 33.
# We do this so that the www-data group is identical across servers
# for NFS purposes.
group node['scratchpads']['aegir']['group'] do
  gid 33
  action :manage
end
# Create the aegir user
user node['scratchpads']['aegir']['user'] do
  group node['scratchpads']['aegir']['group']
  system true
  shell node['scratchpads']['aegir']['shell']
  comment node['scratchpads']['aegir']['comment']
  home node['scratchpads']['aegir']['home_folder']
  manage_home
  uid 997
end
# Add the aegir user to sudoers and ensure it does not need a password.
sudo node['scratchpads']['aegir']['user'] do
  user node['scratchpads']['aegir']['user']
  nopasswd true
end
# Create the aegir directory
# FIXME - Do I need to do this? Shouldn't the "user" command above create
# the /var/aegir folder for us?
directory node['scratchpads']['aegir']['home_folder'] do
  owner node['scratchpads']['aegir']['user']
  group node['scratchpads']['aegir']['group']
  mode 0755
  action :create
end
# Create the .ssh directory
directory "#{node['scratchpads']['aegir']['home_folder']}/.ssh" do
  owner node['scratchpads']['aegir']['user']
  group node['scratchpads']['aegir']['group']
  mode 0700
  action :create
end
# Check to see if we are running the 'control' role. If so we install Aegir, and if not
# we just ensure that the aegir user on control can ssh to this box.
if node['roles'].index(node['scratchpads']['control']['role']) then
  include_recipe 'scratchpads::aegir-master'
else
  include_recipe 'scratchpads::aegir-slave'
end
# Link the aegir configuration to the apache sites folder
link '/etc/apache2/sites-available/aegir.conf' do
  action :create
  group 'root'
  owner 'root'
  to "#{node['scratchpads']['aegir']['home_folder']}/config/apache.conf"
  only_if {::File.exists?("#{node['scratchpads']['aegir']['home_folder']}/config/apache.conf")}
end
# Enable the aegir configuration
apache_site 'aegir' do
  enable true
  only_if {::File.exists?('/etc/apache2/sites-available/aegir.conf')}
end
