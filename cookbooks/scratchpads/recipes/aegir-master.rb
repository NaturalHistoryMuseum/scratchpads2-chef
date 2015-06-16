#
# Cookbook Name:: scratchpads
# Recipe:: aegir-master
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# Copy any files we require.
node['scratchpads']['aegir']['cookbook_files'].each do|name,cb_file|
  cookbook_file cb_file['path'] do
    source cb_file['source']
    cookbook cb_file['cookbook']
    owner cb_file['owner']
    group cb_file['group']
    mode cb_file['mode']
  end
end

# Create the .drush folder
# FIXME - Is this required?
directory "#{node['scratchpads']['aegir']['home_folder']}/#{node['scratchpads']['control']['drush_config_folder']}" do
  owner node['scratchpads']['aegir']['user']
  group node['scratchpads']['aegir']['group']
  mode 0755
  action :create
end
# Execute the basic drush commands to download the provision code
execute 'download provision' do
  command "#{node['scratchpads']['control']['drush_command']} dl --destination=#{node['scratchpads']['aegir']['home_folder']}/#{node['scratchpads']['control']['drush_config_folder']} #{node['scratchpads']['aegir']['provision_version']}"
  cwd node['scratchpads']['aegir']['home_folder']
  group node['scratchpads']['aegir']['group']
  user node['scratchpads']['aegir']['user']
  not_if { ::File.exists?("#{node['scratchpads']['aegir']['home_folder']}/#{node['scratchpads']['control']['drush_config_folder']}/provision/provision.info")}
end
# Execute the basic drush command to download the registry_rebuild drush code which is useful for fixing broken sites.
execute 'download registry_rebuild' do
  command "#{node['scratchpads']['control']['drush_command']} dl --destination=#{node['scratchpads']['aegir']['home_folder']}/#{node['scratchpads']['control']['drush_config_folder']} registry_rebuild"
  cwd node['scratchpads']['aegir']['home_folder']
  group node['scratchpads']['aegir']['group']
  user node['scratchpads']['aegir']['user']
  not_if { ::File.exists?("#{node['scratchpads']['aegir']['home_folder']}/#{node['scratchpads']['control']['drush_config_folder']}/registry_rebuild")}
end
# Clear the drush cache so that the provision command is found.
execute 'clear drush cache' do
  command "#{node['scratchpads']['control']['drush_command']} cache-clear drush"
  cwd node['scratchpads']['aegir']['home_folder']
  group node['scratchpads']['aegir']['group']
  user node['scratchpads']['aegir']['user']
end
# Install the hostmaster site on this server using the database also on this
# server.
passwords = ScratchpadsEncryptedData.new(node)
aegir_pw = passwords.get_encrypted_data 'mysql', 'aegir'
# FIXME: The --aegir_db_user=... below is "odd"!
execute 'install hostmaster' do
  command "#{node['scratchpads']['control']['drush_command']} hostmaster-install \
           --aegir_db_pass='#{aegir_pw}' \
           --root=#{node['scratchpads']['aegir']['home_folder']}/#{node['scratchpads']['aegir']['hostmaster_folder']} \
           --aegir_db_user=#{node['scratchpads']['control'][node['scratchpads']['aegir']['user']]['dbuser']} \
           --aegir_db_host=#{node['scratchpads']['control']['dbserver']} \
           --client_email=#{node['scratchpads']['control']['admin_email']} \
           #{node['scratchpads']['control']['aegir_url']} \
           -y"
  cwd node['scratchpads']['aegir']['home_folder']
  group node['scratchpads']['aegir']['group']
  user node['scratchpads']['aegir']['user']
  not_if { ::File.exists?("#{node['scratchpads']['aegir']['home_folder']}/.drush/hm.alias.drushrc.php")}
  environment node['scratchpads']['aegir']['environment']
end
# Create the 'contrib' folder under sites/all for the memcache, varnish and any other modules to go into
directory "#{node['scratchpads']['aegir']['home_folder']}/#{node['scratchpads']['aegir']['hostmaster_folder']}/sites/all/modules/contrib" do
  owner node['scratchpads']['aegir']['user']
  group node['scratchpads']['aegir']['group']
  mode 0755
  action :create
end
# Create the 'custom' folder under sites/all for the hosting_auto_pack and any other custom modules to go into
directory "#{node['scratchpads']['aegir']['home_folder']}/#{node['scratchpads']['aegir']['hostmaster_folder']}/sites/all/modules/custom" do
  owner node['scratchpads']['aegir']['user']
  group node['scratchpads']['aegir']['group']
  mode 0755
  action :create
end
# Download the Hosting Auto Pack module from our Git repository
git "#{node['scratchpads']['aegir']['home_folder']}/#{node['scratchpads']['aegir']['hostmaster_folder']}/sites/all/modules/custom/hosting_auto_pack" do
  repository node['scratchpads']['aegir']['hosting_auto_pack']['repository']
  group node['scratchpads']['aegir']['group']
  user node['scratchpads']['aegir']['user']
end
# Download the Hosting Reinstall module which is currently a Sandbox, and therefore can't be downloaded using the method below.
git "#{node['scratchpads']['aegir']['home_folder']}/#{node['scratchpads']['aegir']['hostmaster_folder']}/sites/all/modules/contrib/hosting_reinstall" do
  repository node['scratchpads']['aegir']['hosting_reinstall']['repository']
  checkout_branch node['scratchpads']['aegir']['hosting_reinstall']['checkout_branch']
  revision node['scratchpads']['aegir']['hosting_reinstall']['revision']
  group node['scratchpads']['aegir']['group']
  user node['scratchpads']['aegir']['user']
end

node['scratchpads']['aegir']['modules_to_download'].each do|module_name|
  # Download the additional module(s).
  execute "download #{module_name} module" do
    command "#{node['scratchpads']['control']['drush_command']} @hm dl #{module_name}"
    environment node['scratchpads']['aegir']['environment']
    cwd node['scratchpads']['aegir']['home_folder']
    group node['scratchpads']['aegir']['group']
    user node['scratchpads']['aegir']['user']
    not_if {::File.exists?("#{node['scratchpads']['aegir']['home_folder']}/#{node['scratchpads']['aegir']['hostmaster_folder']}/sites/all/modules/contrib/#{module_name}")}
  end
end
# Enable any additional modules as configured.
execute 'enable additional modules' do
  command "#{node['scratchpads']['control']['drush_command']} @hm en #{node['scratchpads']['aegir']['modules_to_install'].join(' ')} -y"
  cwd node['scratchpads']['aegir']['home_folder']
  group node['scratchpads']['aegir']['group']
  user node['scratchpads']['aegir']['user']
  environment node['scratchpads']['aegir']['environment']
end
# Set the admin password to one contained in an encrypted data bag.
admin_pw = passwords.get_encrypted_data 'aegir', 'admin'
execute 'set the admin user password' do
  command "#{node['scratchpads']['control']['drush_command']} @hm upwd admin --password=#{admin_pw} -y ; touch #{node['scratchpads']['aegir']['home_folder']}/#{node['scratchpads']['control']['drush_config_folder']}/admin_password_set"
  cwd node['scratchpads']['aegir']['home_folder']
  group node['scratchpads']['aegir']['group']
  user node['scratchpads']['aegir']['user']
  environment node['scratchpads']['aegir']['environment']
  not_if {::File.exists?("#{node['scratchpads']['aegir']['home_folder']}/#{node['scratchpads']['control']['drush_config_folder']}/admin_password_set")}
end
#
# Add cron functions to Aegir
#
# - cron to delete backups older than one week (every hour, or daily - not sure if it matters much)
# - Reinstall Sandbox, and possibly also tweak the drushrc.php file (every six hours)
# - Cron to create the backups using Aegir (every minute, or possibly using hosting-queue)
# - Run stats-aggregate on scratchpads.eu site (every four hours)
# - Clear vbrant.eu site caches (every five minutes)
# - Run updates on testing sites once a day
#
# Save SSH keys
enc_data_bag = ScratchpadsEncryptedData.new(node, 'ssh')
lines = enc_data_bag.get_encrypted_data 'aegir', 'private'
template "#{node['scratchpads']['aegir']['home_folder']}/.ssh/id_rsa" do
  path "#{node['scratchpads']['aegir']['home_folder']}/.ssh/id_rsa"
  source 'empty-file.erb'
  cookbook 'scratchpads'
  owner node['scratchpads']['aegir']['user']
  group node['scratchpads']['aegir']['group']
  mode '0600'
  action :create
  variables({
    :lines => lines
  })
end
# Create config file so that we don't fuss about ssh conflicts (could be a security issue - need to find a way around this)
template "#{node['scratchpads']['aegir']['home_folder']}/.ssh/config" do
  path "#{node['scratchpads']['aegir']['home_folder']}/.ssh/config"
  source 'aegir-ssh-config.erb'
  cookbook 'scratchpads'
  owner node['scratchpads']['aegir']['user']
  group node['scratchpads']['aegir']['group']
  mode '0644'
  action :create
end
# Create the hosting-queued service from the template.
template '/etc/systemd/system/hosting-queued.service' do
  path '/etc/systemd/system/hosting-queued.service'
  source 'hosting-queued.service.erb'
  cookbook 'scratchpads'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
  notifies :run, 'execute[restart_systemctl_daemon]', :immediately
end
service 'hosting-queued' do
  supports :restart => true
  action [:enable,:start]
end
# Create the memcache.inc file which will configure sites
# to use the memcache servers on the roles:data servers.
data_hosts = []
unless Chef::Config[:solo]
  data_hosts_search = search(:node, "roles:#{node['scratchpads']['data']['role']}")
  data_hosts_search.each do|data_host|
    data_hosts << data_host['fqdn']
  end
end
template "#{node['scratchpads']['aegir']['home_folder']}/config/includes/memcache.inc" do
  source 'memcache.inc.erb'
  cookbook 'scratchpads'
  owner node['scratchpads']['aegir']['user']
  group node['scratchpads']['aegir']['group']
  mode 0644
  variables({
    :sp_data_servers => data_hosts
  })
end
# Create the solr.inc file
template "#{node['scratchpads']['aegir']['home_folder']}/config/includes/solr.inc" do
  source 'solr.inc.erb'
  cookbook 'scratchpads'
  owner node['scratchpads']['aegir']['user']
  group node['scratchpads']['aegir']['group']
  mode 0644
end
# Create the varnish.inc file which contains the /etc/varnish/secret contents from an encrypted data bag
# This allows us to know the secret on all servers, and therefore allows us to
# control the Varnish server remotely (i.e. sp-app-xxx can clear varnish cache
# for a specific site)
varnish_secret = passwords.get_encrypted_data 'varnish', 'secret'
template "#{node['scratchpads']['aegir']['home_folder']}/config/includes/varnish.inc" do
  source 'varnish.inc.erb'
  cookbook 'scratchpads'
  owner node['scratchpads']['aegir']['user']
  group node['scratchpads']['aegir']['group']
  mode 0644
  variables({
    :varnish_secret => varnish_secret
  })
end
gm3_password = passwords.get_encrypted_data 'mysql', 'gm3'
template "#{node['scratchpads']['aegir']['home_folder']}/config/includes/databases.inc" do
  source 'databases.inc.erb'
  cookbook 'scratchpads'
  owner node['scratchpads']['aegir']['user']
  group node['scratchpads']['aegir']['group']
  mode 0644
  variables({
    :gm3_password => gm3_password
  })
end
# Create the global.inc file which has general settings, and also includes the memcache.inc, 
# varnish.inc and databases.inc files.
twitter_consumer_secret = passwords.get_encrypted_data 'twitter', 'secret'
twitter_consumer_key = passwords.get_encrypted_data 'twitter', 'key'
scratchpads_multilingual_contribute_key = passwords.get_encrypted_data 'scratchpads_multilingual_contribute', 'key'
scratchpads_multilingual_contribute_uwho = passwords.get_encrypted_data 'scratchpads_multilingual_contribute', 'uwho'
scratchpads_gbif_registry_username = passwords.get_encrypted_data 'scratchpads_gbif_registry', 'username'
scratchpads_gbif_registry_password = passwords.get_encrypted_data 'scratchpads_gbif_registry', 'password'
scratchpads_taverna_auth_token = passwords.get_encrypted_data 'taverna', 'auth_token'
template "#{node['scratchpads']['aegir']['home_folder']}/config/includes/global.inc" do
  source 'global.inc.erb'
  cookbook 'scratchpads'
  owner node['scratchpads']['aegir']['user']
  group node['scratchpads']['aegir']['group']
  mode 0644
  variables({
    :twitter_consumer_key => twitter_consumer_key,
    :twitter_consumer_secret => twitter_consumer_secret,
    :scratchpads_multilingual_contribute_key => scratchpads_multilingual_contribute_key,
    :scratchpads_multilingual_contribute_uwho => scratchpads_multilingual_contribute_uwho,
    :scratchpads_gbif_registry_username => scratchpads_gbif_registry_username,
    :scratchpads_gbif_registry_password => scratchpads_gbif_registry_password,
    :scratchpads_taverna_auth_token => scratchpads_taverna_auth_token
  })
end

# Add remote hosts (data and app servers)
include_recipe 'scratchpads::aegir-add-remote-hosts'

# Create the scratchpads-master platform on the pack server
# First get the code
git "#{node['scratchpads']['aegir']['home_folder']}/platforms/scratchpads-master" do
  repository node['scratchpads']['aegir']['scratchpads_master']['repository']
  group node['scratchpads']['aegir']['group']
  user node['scratchpads']['aegir']['user']
  timeout node['scratchpads']['aegir']['scratchpads_master']['timeout']
end
# Create the scratchpads-master platform
execute 'create the platform node' do
  command "#{node['scratchpads']['control']['drush_command']} provision-save --context_type=platform --web_server='@server_automaticpack' --root='/var/aegir/platforms/scratchpads-master' platform_scratchpads-master"
  cwd node['scratchpads']['aegir']['home_folder']
  group node['scratchpads']['aegir']['group']
  user node['scratchpads']['aegir']['user']
  environment node['scratchpads']['aegir']['environment']
  not_if {::File.exists?("#{node['scratchpads']['aegir']['home_folder']}/.drush/platform_scratchpads-master.alias.drushrc.php")}
  only_if {::File.exists?("#{node['scratchpads']['aegir']['home_folder']}/.drush/server_automaticpack.alias.drushrc.php")}
end
# Verify the server
execute 'verify the platform node' do
  command "drush @platform_scratchpads-master provision-verify"
  cwd node['scratchpads']['aegir']['home_folder']
  group node['scratchpads']['aegir']['group']
  user node['scratchpads']['aegir']['user']
  environment node['scratchpads']['aegir']['environment']
  only_if {::File.exists?("#{node['scratchpads']['aegir']['home_folder']}/.drush/platform_scratchpads-master.alias.drushrc.php")}
  only_if {::File.exists?("#{node['scratchpads']['aegir']['home_folder']}/.drush/server_automaticpack.alias.drushrc.php")}
  not_if {::File.exists?("#{node['scratchpads']['aegir']['home_folder']}/.drush/platform_scratchpads-master.alias.drushrc.php")}
end
#drush @hm hosting-import @server_spapp1nhmacuk
# Import the platform into the front end
execute 'import the platform into front end' do
  command "touch #{node['scratchpads']['aegir']['home_folder']}/.drush/platform_scratchpads-master.imported ; drush @hm hosting-import @platform_scratchpads-master"
  cwd node['scratchpads']['aegir']['home_folder']
  group node['scratchpads']['aegir']['group']
  user node['scratchpads']['aegir']['user']
  environment node['scratchpads']['aegir']['environment']
  only_if {::File.exists?("#{node['scratchpads']['aegir']['home_folder']}/.drush/platform_scratchpads-master.alias.drushrc.php")}
  only_if {::File.exists?("#{node['scratchpads']['aegir']['home_folder']}/.drush/server_automaticpack.alias.drushrc.php")}
  not_if {::File.exists?("#{node['scratchpads']['aegir']['home_folder']}/.drush/platform_scratchpads-master.imported")}
end
