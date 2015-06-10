#
# Cookbook Name:: scratchpads
# Recipe:: webserver
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# Add modules to the list to enable
node['scratchpads']['webserver']['apache']['additional_modules'].each do|module_name|
  node.default['apache']['default_modules'] << module_name
end

# Install package required by Apache to connect to a MySQL database
# package ['libaprutil1-dbd-mysql']

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
if node['roles'].index(node['scratchpads']['control']['role']) then
  directory node['scratchpads']['webserver']['php']['session_save_path'] do
    owner node['apache']['user']
    group node['apache']['group']
    mode 0755
    action :create
    not_if {::File.exists?(node['scratchpads']['webserver']['php']['session_save_path'])}
  end
  # Create an empty folder which is used by certain sites
  directory '/var/www/empty' do
    path '/var/www/empty'
    owner node['apache']['user']
    group node['apache']['group']
    mode 0755
    action :create
  end 
end

# Install the mysql2_chef_gem as required by database
mysql2_chef_gem 'default' do
  provider Chef::Provider::Mysql2ChefGem::Percona
  action :install
end

# We need to set some database settings before attempting to create the templates
passwords = ScratchpadsEncryptedPasswords.new(node, node['scratchpads']['encrypted_data_bag'])
db_pw = passwords.find_password 'mysql', node['scratchpads']['control']['aegir']['dbuser']

# Fill in the host
if Chef::Config[:solo]
  data_host = {'fqdn' => 'sp-data-1'}
else
  data_hosts = search(:node, "roles:#{node['scratchpads']['data']['role']}")
  data_host = data_hosts.first
end
if(data_host)
  node.default['scratchpads']['webserver']['apache']['templates']['cite.scratchpads.eu']['database']['host'] = data_host['fqdn']
  node.default['scratchpads']['webserver']['apache']['templates']['help.scratchpads.eu']['database']['host'] = data_host['fqdn']
  node.default['scratchpads']['webserver']['apache']['templates']['help.scratchpads.eu']['templates']['help.scratchpads.eu.LocalSettings.php']['variables']['host'] = data_host['fqdn']
end
if(data_hosts)
  data_hosts.each do|index,data_host_x|
    node.default['scratchpads']['webserver']['apache']['templates']['help.scratchpads.eu']['templates']['help.scratchpads.eu.LocalSettings.php']['variables']['sp_data_servers'] << data_host_x['fqdn']
  end
end

# Add sites
node['scratchpads']['webserver']['apache']['templates'].each do|site_name,tmplte|
  web_app site_name do
    cookbook tmplte['cookbook']
    template tmplte['source']
    enable true
  end
  # We process templates on all servers, as some files may be outside of the
  # /var/www/ folder.
  if (tmplte['templates'])
    tmplte['templates'].each do|index,subtmplte|
      template index do
        path subtmplte['path']
        source subtmplte['source']
        cookbook subtmplte['cookbook']
        owner subtmplte['owner']
        group subtmplte['group']
        mode subtmplte['mode']
        variables subtmplte['variables']
        action :create
        only_if {::File.exists?(::File.dirname(subtmplte['path']))}
        only_if {node['roles'].index(node['scratchpads']['control']['role']) || subtmplte['all_servers']}
      end
    end
  end
  # We only add certain files and try to create databases from the control server. This 
  # is because we are sharing the /var/www/ directory to all hosts, and we only need
  # to create a database once.
  if node['roles'].index(node['scratchpads']['control']['role']) then
    # Check to see if the parent folder exists before we try to create it. If it doesn't, we go no further
    if(::File.exists?(::File.dirname(tmplte['documentroot'])))
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
      if (tmplte['database'] && data_host)
        # Create the MySQL database
        mysql_database tmplte['database']['database'] do
          connection(
            :host => data_host['fqdn'],
            :username => node['scratchpads']['control']['aegir']['dbuser'],
            :password => db_pw
          )
          action :create
        end
        # Create the MySQL user
        mysql_database_user tmplte['database']['user'] do
          connection(
            :host => data_host['fqdn'],
            :username => node['scratchpads']['control']['aegir']['dbuser'],
            :password => db_pw
          )
          password tmplte['database']['password']
          database_name tmplte['database']['database']
          host '%'
          action [:create, :grant]
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
