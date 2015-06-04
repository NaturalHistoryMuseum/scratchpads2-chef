#
# Cookbook Name:: scratchpads
# Recipe:: webserver
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# Add modules to the list to enable
default['scratchpads']['apache']['additional_modules'].each do|module_name|
  node.default['apache']['default_modules'] << module_name
end

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
node['scratchpads']['php']['pecl_or_pear_modules'].each do|module_name|
  # Install pecl extensions
  php_pear module_name do
    action :install
  end
  # Could do the following in one big command, but it doesn't really make a difference.
  execute "enable #{module_name} module" do
    command "#{node['scratchpads']['php']['php5enmod_command']} #{module_name}"
    group 'root'
    user 'root'
  end
end