#
# Cookbook Name:: scratchpads
# Recipe:: webserver
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# Install Apache2 and set it to use prefork and mod_php5
include_recipe 'apache2'
include_recipe 'apache2::mpm_prefork'
include_recipe 'apache2::mod_php5'

# PHP Package
# PHP has probably already been dragged in by mod_php5, but we still need to add
# other features/settings.
include_recipe 'php'
# Install drush from pear
dc = php_pear_channel 'pear.drush.org' do
  action :discover
end
php_pear 'drush' do
  channel dc.channel_name
  action :install
end
