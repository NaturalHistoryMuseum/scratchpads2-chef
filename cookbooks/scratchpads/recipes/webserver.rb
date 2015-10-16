#
# Cookbook Name:: scratchpads
# Recipe:: webserver
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# Install package required by Apache to connect to a MySQL database
# package ['libaprutil1-dbd-mysql']

# Install Apache2 and set it to use prefork and mod_php5
include_recipe 'apache2'
include_recipe 'apache2::mpm_prefork'
include_recipe 'apache2::mod_php5'

# Disable the other-vhosts-access-log configuration
apache_config 'other-vhosts-access-log' do
  enable false
end

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
end

# Install the mysql2_chef_gem as required by database
mysql2_chef_gem 'default' do
  provider Chef::Provider::Mysql2ChefGem::Percona
  action :install
end

# Fill in the host
if Chef::Config[:solo]
  data_host = {'fqdn' => 'sp-data-1'}
else
  data_hosts = search(:node, "roles:#{node['scratchpads']['data']['role']} AND chef_environment:#{node.chef_environment}")
  data_host = data_hosts.first
end
if(data_host)
  node.default['scratchpads']['webserver']['apache']['templates']['cite.scratchpads.eu']['database']['host'] = data_host['fqdn']
  node.default['scratchpads']['webserver']['apache']['templates']['help.scratchpads.eu']['database']['host'] = data_host['fqdn']
  node.default['scratchpads']['webserver']['apache']['templates']['help.scratchpads.eu']['templates']['help.scratchpads.eu.LocalSettings.php']['variables']['host'] = data_host['fqdn']
end
if(data_hosts)
  data_hosts.each do|data_host_x|
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
        not_if {::File.exists?(subtmplte['path'])}
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
          notifies :run, "execute[extract #{tmplte['files']['source']}]", :immediately
          if (tmplte['database'] && data_host)
            notifies :create, "mysql_database[#{tmplte['database']['database']}]", immediately
            notifies [:create, :grant], "mysql_database_user[#{tmplte['database']['user']}]", immediately
          end
        end
        execute "extract #{tmplte['files']['source']}" do
          cwd tmplte['documentroot']
          command "tar xfz /var/chef/#{tmplte['files']['source']}"
          user node['apache']['user']
          group node['apache']['group']
          action :nothing
        end
      end
      if (tmplte['database'] && data_host)
        # We need to set some database settings before attempting to create the templates
        passwords = ScratchpadsEncryptedData.new(node)
        db_pw = passwords.get_encrypted_data 'mysql', node['scratchpads']['control']['aegir']['dbuser']
        # Create the MySQL database
        mysql_database tmplte['database']['database'] do
          connection(
            :host => data_host['fqdn'],
            :username => node['scratchpads']['control']['aegir']['dbuser'],
            :password => db_pw
          )
          action :nothing
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
          action :nothing
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

# Install re2c which is required by the mailparse module
package ['re2c']

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
node['scratchpads']['webserver']['php']['pear']['pecl_modules'].each do|module_name,details|
  # Install pecl extensions
  php_pear module_name do
    action :install
    preferred_state details['preferred_state']
    notifies :run, "execute[enable #{module_name} module]", :immediately
  end
  # Could do the following in one big command, but it doesn't really make a difference.
  # The following code should check whether we installed a pecl module, or a pear library, perhaps using a "if file exists"
  execute "enable #{module_name} module" do
    command "#{node['scratchpads']['webserver']['php']['php5enmod_command']} #{module_name}"
    group 'root'
    user 'root'
    #action :nothing
    not_if { ::File.exists?("/etc/php5/apache2/conf.d/20-#{module_name}.ini")}
  end
end

# Install redmine packages
execute 'prevent redmine asking for installation crap' do
  command 'echo "redmine  redmine/instances/default/app-password-confirm  password  
redmine redmine/instances/default/mysql/admin-pass  password  
redmine redmine/instances/default/pgsql/app-pass  password  
redmine redmine/instances/default/pgsql/admin-pass  password  
redmine redmine/instances/default/password-confirm  password  
redmine redmine/instances/default/mysql/app-pass  password  
redmine redmine/instances/default/install-error select  abort
redmine redmine/instances/default/internal/skip-preseed boolean true
redmine redmine/instances/default/pgsql/manualconf  note  
redmine redmine/instances/default/db/app-user string  redmine_default
redmine redmine/instances/default/pgsql/authmethod-user select  password
redmine redmine/instances/default/remove-error  select  abort
redmine redmine/instances/default/upgrade-backup  boolean true
redmine redmine/instances/default/internal/reconfiguring  boolean false
redmine redmine/instances/default/dbconfig-remove boolean
redmine redmine/instances/default/dbconfig-upgrade  boolean true
redmine redmine/instances/default/database-type select  
redmine redmine/instances/default/db/basepath string  
redmine redmine/instances/default/purge boolean false
redmine redmine/old-instances string  
redmine redmine/instances/default/remote/newhost  string  
redmine redmine/notify-migration  note  
redmine redmine/instances/default/mysql/method  select  unix socket
redmine redmine/instances/default/pgsql/authmethod-admin  select  ident
redmine redmine/instances/default/remote/port string  
redmine redmine/instances/default/pgsql/method  select  unix socket
redmine redmine/instances/default/pgsql/admin-user  string  postgres
redmine redmine/instances/default/mysql/admin-user  string  root
redmine redmine/instances/default/upgrade-error select  abort
redmine redmine/instances/default/db/dbname string  redmine_default
redmine redmine/instances/default/dbconfig-reinstall  boolean false
redmine redmine/instances/default/pgsql/changeconf  boolean false
redmine redmine/instances/default/dbconfig-install  boolean false
redmine redmine/current-instances string  default
redmine redmine/instances/default/remote/host select  
redmine redmine/instances/default/missing-db-package-error  select  abort"|debconf-set-selections'
  group 'root'
  user 'root'
  not_if {::File.exists?('/usr/share/redmine')}
end

# Install redmine
package ['redmine', 'redmine-mysql', 'libapache2-mod-passenger']
# Database configuration
template node['scratchpads']['redmine']['templates']['database.yml']['path'] do
  source node['scratchpads']['redmine']['templates']['database.yml']['source']
  cookbook node['scratchpads']['redmine']['templates']['database.yml']['cookbook']
  owner node['scratchpads']['redmine']['templates']['database.yml']['owner']
  group node['scratchpads']['redmine']['templates']['database.yml']['group']
  mode node['scratchpads']['redmine']['templates']['database.yml']['mode']
end
# Session configuration
template node['scratchpads']['redmine']['templates']['session.yml']['path'] do
  source node['scratchpads']['redmine']['templates']['session.yml']['source']
  cookbook node['scratchpads']['redmine']['templates']['session.yml']['cookbook']
  owner node['scratchpads']['redmine']['templates']['session.yml']['owner']
  group node['scratchpads']['redmine']['templates']['session.yml']['group']
  mode node['scratchpads']['redmine']['templates']['session.yml']['mode']
end
# Extra configuration
template node['scratchpads']['redmine']['templates']['configuration.yml']['path'] do
  source node['scratchpads']['redmine']['templates']['configuration.yml']['source']
  cookbook node['scratchpads']['redmine']['templates']['configuration.yml']['cookbook']
  owner node['scratchpads']['redmine']['templates']['configuration.yml']['owner']
  group node['scratchpads']['redmine']['templates']['configuration.yml']['group']
  mode node['scratchpads']['redmine']['templates']['configuration.yml']['mode']
end
# Add plugins
cookbook_file node['scratchpads']['redmine']['cookbook_file']['plugins']['path'] do
  source node['scratchpads']['redmine']['cookbook_file']['plugins']['source']
  cookbook node['scratchpads']['redmine']['cookbook_file']['plugins']['cookbook']
  owner node['scratchpads']['redmine']['cookbook_file']['plugins']['owner']
  group node['scratchpads']['redmine']['cookbook_file']['plugins']['group']
  mode node['scratchpads']['redmine']['cookbook_file']['plugins']['mode']
  notifies :run, "execute[extract redmine plugins]", :immediately
end
# Extract the plugins directory
execute 'extract redmine plugins' do
  cwd '/usr/share/redmine'
  command "tar xfz #{node['scratchpads']['redmine']['cookbook_file']['plugins']['source']}"
  user 'root'
  group 'root'
  action :nothing
end
# Add theme
cookbook_file node['scratchpads']['redmine']['cookbook_file']['theme']['path'] do
  source node['scratchpads']['redmine']['cookbook_file']['theme']['source']
  cookbook node['scratchpads']['redmine']['cookbook_file']['theme']['cookbook']
  owner node['scratchpads']['redmine']['cookbook_file']['theme']['owner']
  group node['scratchpads']['redmine']['cookbook_file']['theme']['group']
  mode node['scratchpads']['redmine']['cookbook_file']['theme']['mode']
  notifies :run, "execute[extract redmine theme]", :immediately
end
# Extract theme
execute 'extract redmine theme' do
  cwd '/usr/share/redmine/public/themes'
  command "tar xfz #{node['scratchpads']['redmine']['cookbook_file']['theme']['source']}"
  user 'root'
  group 'root'
  action :nothing
end
# Add favicon
cookbook_file node['scratchpads']['redmine']['cookbook_file']['favicon']['path'] do
  source node['scratchpads']['redmine']['cookbook_file']['favicon']['source']
  cookbook node['scratchpads']['redmine']['cookbook_file']['favicon']['cookbook']
  owner node['scratchpads']['redmine']['cookbook_file']['favicon']['owner']
  group node['scratchpads']['redmine']['cookbook_file']['favicon']['group']
  mode node['scratchpads']['redmine']['cookbook_file']['favicon']['mode']
end
# This installs Redmine, but does not handle the database or upgrading
# from previous versions of Redmine. That must be handled manually using
# the following process