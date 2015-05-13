#
# Cookbook Name:: learn_chef_apache2
# Recipe:: default
#
# Copyright (C) 2014
#
#
#
package 'apache2'

service 'apache2' do
  supports :status => true
  action [:enable, :start]
end

template '/var/www/html/index.html' do
  source 'index.html.erb'
end
