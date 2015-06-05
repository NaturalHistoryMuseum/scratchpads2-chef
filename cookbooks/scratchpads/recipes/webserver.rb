#
# Cookbook Name:: scratchpads
# Recipe:: webserver
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# Add modules to the list to enable
node['scratchpads']['webserver']['apache']['additional_modules'].each do|module_name|
  node.default['apache']['default_modules'] << module_name
end

# Install Apache2 and set it to use prefork and mod_php5
include_recipe 'apache2'
include_recipe 'apache2::mpm_prefork'
include_recipe 'apache2::mod_php5'

# Delete the /var/www/html folder - we do not need it, and it'll cause issues with
# the mounting of NFS folders.
execute 'delete /var/www/html' do
  command 'rm -rf /var/www/html'
  group 'root'
  user 'root'
  only_if {::File.exists?('/var/www/html')}
end

# Create the session save path
if node['roles'].index('control') then
  directory node['scratchpads']['webserver']['php']['session_save_path'] do
    owner node['apache']['user']
    group node['apache']['group']
    mode 0755
    action :create
    not_if {::File.exists?(node['scratchpads']['webserver']['php']['session_save_path'])}
  end
end

# Add sites
node['scratchpads']['webserver']['apache']['templates'].each do|site_name,tmplte|
  web_app site_name do
    cookbook tmplte['cookbook']
    template tmplte['source']
    enable true
  end
  if node['roles'].index('control') then
    directory site_name do
      path tmplte['documentroot']
      owner node['apache']['user']
      group node['apache']['group']
      mode 0755
      action :create
      only_if {tmplte['documentroot']}
      not_if {::File.exists?(tmplte['documentroot'])}
    end
    if (tmplte['files'])
      cookbook_file "/var/chef/#{tmplte['files']['source']}" do
        source tmplte['files']['source']
        cookbook tmplte['files']['cookbook']
        owner node['apache']['user']
        group node['apache']['group']
        mode '0400'
      end
      execute "extract #{tmplte['files']['source']}" do
        cwd tmplte['documentroot']
        command "tar xfz /var/chef/#{tmplte['files']['source']}"
        user node['apache']['user']
        group node['apache']['group']
      end
    end
    if (tmplte['templates'])
      tmplte['templates'].each do|index,subtmplte|
        template subtmplte['path'] do
          path subtmplte['path']
          source subtmplte['source']
          cookbook subtmplte['cookbook']
          owner subtmplte['owner']
          group subtmplte['group']
          mode subtmplte['mode']
          action :create
        end
      end
    end
    git site_name do
      destination tmplte['documentroot']
      repository tmplte['git']
      user node['apache']['user']
      group node['apache']['group']
      only_if {tmplte['git']}
    end
  end
end

# PHP Package
# PHP has probably already been dragged in by mod_php5, but we still need to add
# other features/settings.
include_recipe 'php'

# Install pear modules from specific channels.
node['scratchpads']['webserver']['php']['pear']['pear_modules_custom_channels'].each do|module_name,channel|
  # Install drush from pear
  dc = php_pear_channel channel do
    action :discover
  end
  php_pear module_name do
    channel dc.channel_name
    action :install
  end
end

# Install pecl modules from known channels (no need to discover the channel)
node['scratchpads']['webserver']['php']['pear']['pecl_modules'].each do|module_name|
  # Install pecl extensions
  php_pear module_name do
    action :install
  end
  # Could do the following in one big command, but it doesn't really make a difference.
  # The following code should check whether we installed a pecl module, or a pear library, perhaps using a "if file exists"
  execute "enable #{module_name} module" do
    command "#{node['scratchpads']['webserver']['php']['php5enmod_command']} #{module_name}"
    group 'root'
    user 'root'
  end
end