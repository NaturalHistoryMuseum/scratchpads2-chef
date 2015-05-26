#
# Cookbook Name:: scratchpads
# Recipe:: aegir
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# Create the aegir user
user 'aegir' do
  group 'www-data'
  system true
  shell '/bin/bash'
  comment 'User which runs all of the behind the scenes actions.'
  home '/var/aegir'
  manage_home
end
# Add the aegir user to sudoers and ensure it does not need a password.
sudo 'aegir' do
  user 'aegir'
  nopasswd true
end
# Create the aegir directory
directory node["scratchpads"]["aegir"]["home_folder"] do
  owner node["scratchpads"]["aegir"]["user"]
  group node["scratchpads"]["aegir"]["group"]
  mode 0755
  action :create
end
# Check to see if we are running the "control" role. If so we install Aegir, and if not
# we just ensure that the aegir user on control can ssh to this box.
if node.automatic.roles.index("control") then
  # Create the .drush folder
  directory "#{node["scratchpads"]["aegir"]["home_folder"]}/.drush" do
    owner node["scratchpads"]["aegir"]["user"]
    group node["scratchpads"]["aegir"]["group"]
    mode 0755
    action :create
  end
  # Execute the basic drush commands to download the provision code
  execute 'download provision' do
    command "drush dl --destination=#{node["scratchpads"]["aegir"]["home_folder"]}/.drush #{node["scratchpads"]["aegir"]["provision_version"]}"
    cwd node["scratchpads"]["aegir"]["home_folder"]
    group node["scratchpads"]["aegir"]["group"]
    user node["scratchpads"]["aegir"]["user"]
    not_if { ::File.exists?("#{node["scratchpads"]["aegir"]["home_folder"]}/.drush/provision/provision.info")}
  end
  # Clear the drush cache so that the provision command is found.
  execute 'clear drush cache' do
    command 'drush cache-clear drush'
    cwd node["scratchpads"]["aegir"]["home_folder"]
    group node["scratchpads"]["aegir"]["group"]
    user node["scratchpads"]["aegir"]["user"]
  end
  # Install the hostmaster site on this server using the database also on this
  # server.
  passwords = ScratchpadsEncryptedPasswords.new(node, node["scratchpads"]["encrypted_data_bag"])
  aegir_pw = passwords.find_password "mysql", "aegir"
  execute 'install hostmaster' do
    command "drush hostmaster-install \
             --aegir_db_pass='#{aegir_pw}' \
             --root=#{node["scratchpads"]["aegir"]["home_folder"]}/hostmaster \
             --aegir_db_user=#{node['scratchpads']['control'][node["scratchpads"]["aegir"]["user"]]['dbuser']} \
             --aegir_db_host=#{node['scratchpads']['control']['dbserver']} \
             --client_email=#{node['scratchpads']['control']['admin_email']} \
             #{node['scratchpads']['control']['fqdn']} \
             -y"
    cwd node["scratchpads"]["aegir"]["home_folder"]
    group node["scratchpads"]["aegir"]["group"]
    user node["scratchpads"]["aegir"]["user"]
    not_if { ::File.exists?("#{node["scratchpads"]["aegir"]["home_folder"]}/.drush/hm.alias.drushrc.php")}
    environment node["scratchpads"]["aegir"]["environment"]
  end
  # # Copy the patch
  # cookbook_file "pack.patch" do
  #   path "#{node["scratchpads"]["aegir"]["home_folder"]}/.drush/provision/http/Provision/Service/http/pack.patch"
  #   owner node["scratchpads"]["aegir"]["user"]
  #   group node["scratchpads"]["aegir"]["group"]
  #   mode 0755
  #   action :create_if_missing
  # end
  # # Patch the pack.php file to allow us to create pack servers.
  # execute 'patch pack' do
  #   command "cd #{node["scratchpads"]["aegir"]["home_folder"]}/.drush/provision/http/Provision/Service/http/ ;\
  #           cp pack.php pack.php.unpatched;\
  #           patch < pack.patch"
  #   cwd node["scratchpads"]["aegir"]["home_folder"]
  #   group node["scratchpads"]["aegir"]["group"]
  #   user node["scratchpads"]["aegir"]["user"]
  #   not_if { ::File.exists?("#{node["scratchpads"]["aegir"]["home_folder"]}/.drush/provision/http/Provision/Service/http/pack.php.unpatched")}
  #   environment node["scratchpads"]["aegir"]["environment"]
  # end
  # Create the "contrib" folder under sites/all for the memcache, varnish and any other modules to go into
  directory "#{node["scratchpads"]["aegir"]["home_folder"]}/hostmaster/sites/all/modules/contrib" do
    owner node["scratchpads"]["aegir"]["user"]
    group node["scratchpads"]["aegir"]["group"]
    mode 0755
    action :create
  end
  # Download the Hosting Reinstall module which is currently a Sandbox, and therefore can't be downloaded using the method below.
  if ::File.exists?("#{node["scratchpads"]["aegir"]["home_folder"]}/hostmaster/sites/all/modules/contrib/hosting_reinstall") then
    execute "update Hosting Reinstall module code" do
      command "cd #{node["scratchpads"]["aegir"]["home_folder"]}/hostmaster/sites/all/modules/contrib/hosting_reinstall ; git pull"
      environment node["scratchpads"]["aegir"]["environment"]
      cwd node["scratchpads"]["aegir"]["home_folder"]
      group node["scratchpads"]["aegir"]["group"]
      user node["scratchpads"]["aegir"]["user"]
    end
  else
    execute "download Hosting Reinstall module" do
      command "git clone --branch 7.x-3.x http://git.drupal.org/sandbox/ergonlogic/2386543.git #{node["scratchpads"]["aegir"]["home_folder"]}/hostmaster/sites/all/modules/contrib/hosting_reinstall"
      environment node["scratchpads"]["aegir"]["environment"]
      cwd node["scratchpads"]["aegir"]["home_folder"]
      group node["scratchpads"]["aegir"]["group"]
      user node["scratchpads"]["aegir"]["user"]
    end
  end
  node["scratchpads"]["aegir"]["modules_to_download"].each do|module_name|
    # Download the additional module.
    execute "download #{module_name} module" do
      command "drush @hm dl #{module_name}"
      environment node["scratchpads"]["aegir"]["environment"]
      cwd node["scratchpads"]["aegir"]["home_folder"]
      group node["scratchpads"]["aegir"]["group"]
      user node["scratchpads"]["aegir"]["user"]
      not_if { ::File.exists?("#{node["scratchpads"]["aegir"]["home_folder"]}/hostmaster/sites/all/modules/contrib/#{module_name}")}
    end
    # Move the additional module into the contrib folder (which is where it is in the scratchpads code base)
    execute "move #{module_name} module" do
      command "mv #{node["scratchpads"]["aegir"]["home_folder"]}/hostmaster/sites/all/modules/#{module_name} #{node["scratchpads"]["aegir"]["home_folder"]}/hostmaster/sites/all/modules/contrib"
      cwd node["scratchpads"]["aegir"]["home_folder"]
      group node["scratchpads"]["aegir"]["group"]
      user node["scratchpads"]["aegir"]["user"]
      not_if { ::File.exists?("#{node["scratchpads"]["aegir"]["home_folder"]}/hostmaster/sites/all/modules/contrib/#{module_name}")}
    end
  end
  # Enable any additional modules as configured.
  execute 'enable additional modules' do
    command "drush @hm en #{node["scratchpads"]["aegir"]["modules_to_install"].join(" ")} -y"
    cwd node["scratchpads"]["aegir"]["home_folder"]
    group node["scratchpads"]["aegir"]["group"]
    user node["scratchpads"]["aegir"]["user"]
    environment node["scratchpads"]["aegir"]["environment"]
  end
  # Set the admin password to one contained in an encrypted data bag.
  passwords = ScratchpadsEncryptedPasswords.new(node, node["scratchpads"]["encrypted_data_bag"])
  admin_pw = passwords.find_password "aegir", "admin"
  execute 'set the admin user password' do
    command "drush @hm upwd admin --password=#{admin_pw} -y"
    cwd node["scratchpads"]["aegir"]["home_folder"]
    group node["scratchpads"]["aegir"]["group"]
    user node["scratchpads"]["aegir"]["user"]
    environment node["scratchpads"]["aegir"]["environment"]
  end
  #
  # FIX CRON FOR AEGIR USER.
  #
  # Create the .ssh directory
  directory "#{node["scratchpads"]["aegir"]["home_folder"]}/.ssh" do
    owner node["scratchpads"]["aegir"]["user"]
    group node["scratchpads"]["aegir"]["group"]
    mode 0700
    action :create
  end
  # Save SSH keys
  enc_data_bag = ScratchpadsEncryptedPasswords.new(node, "ssh")
  lines = enc_data_bag.find_password "aegir", "private"
  template "#{node["scratchpads"]["aegir"]["home_folder"]}/.ssh/id_rsa" do
    path "#{node["scratchpads"]["aegir"]["home_folder"]}/.ssh/id_rsa"
    source 'empty-file.erb'
    cookbook 'scratchpads'
    owner node["scratchpads"]["aegir"]["user"]
    group node["scratchpads"]["aegir"]["group"]
    mode '0600'
    action :create
    variables({
      :lines => lines
    })
  end
  # Create config file so that we don't fuss about ssh conflicts (could be a security issue - need to find a way around this)
  template "#{node["scratchpads"]["aegir"]["home_folder"]}/.ssh/config" do
    path "#{node["scratchpads"]["aegir"]["home_folder"]}/.ssh/config"
    source 'aegir-ssh-config.erb'
    cookbook 'scratchpads'
    owner node["scratchpads"]["aegir"]["user"]
    group node["scratchpads"]["aegir"]["group"]
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
  service "hosting-queued" do
    supports :restart => true
    action [:enable,:start]
  end
  # Create the memcache.inc file which will configure sites
  # to use the memcache servers on the role:data servers.
  data_hosts = ["sp-data-1"]
  unless Chef::Config[:solo]
    data_hosts_search = search(:node, "flags:UP AND role:data")
    data_hosts = []
    data_hosts_search.each do|data_host|
      data_hosts << data_host['fqdn']
    end
  end
  template "#{node["scratchpads"]["aegir"]["home_folder"]}/config/includes/memcache.inc" do
    source "memcache.inc.erb"
    cookbook "scratchpads"
    owner node["scratchpads"]["aegir"]["user"]
    group node["scratchpads"]["aegir"]["group"]
    mode 0644
    variables({
      :sp_data_servers => data_hosts
    })
  end
  # Create the varnish.inc file which contains the /etc/varnish/secret contents from an encrypted data bag
  # This allows us to know the secret on all servers, and therefore allows us to
  # control the Varnish server remotely (i.e. sp-app-xxx can clear varnish cache
  # for a specific site)
  passwords = ScratchpadsEncryptedPasswords.new(node, node["scratchpads"]["encrypted_data_bag"])
  varnish_secret = passwords.find_password "varnish", "secret"
  template "#{node["scratchpads"]["aegir"]["home_folder"]}/config/includes/varnish.inc" do
    source "varnish.inc.erb"
    cookbook "scratchpads"
    owner node["scratchpads"]["aegir"]["user"]
    group node["scratchpads"]["aegir"]["group"]
    mode 0644
    variables({
      :varnish_secret => varnish_secret
    })
  end
  template "#{node["scratchpads"]["aegir"]["home_folder"]}/config/includes/global.inc" do
    source "global.inc.erb"
    cookbook "scratchpads"
    owner node["scratchpads"]["aegir"]["user"]
    group node["scratchpads"]["aegir"]["group"]
    mode 0644
  end
  # Create Application servers for each application server we know about and that
  # has not already been created.
  app_hosts = ["sp-app-1"]
  unless Chef::Config[:solo]
    app_hosts_search = search(:node, "flags:UP AND role:app")
    app_hosts = []
    app_hosts_search.each do|app_host|
      app_hosts << app_host['fqdn']
    end
  end
  sanitised_names = []
  app_hosts.each do|app_host|
    sanitised_server_name = app_host.gsub(/[^a-z0-9]/, '')
    sanitised_names << "@server_#{sanitised_server_name}"
    # Create the server
    execute 'create the server node' do
      command "drush @hm provision-save server_#{sanitised_server_name} --context_type=server --remote_host=#{app_host} --http_service_type='apache' --http_port=80"
      cwd node["scratchpads"]["aegir"]["home_folder"]
      group node["scratchpads"]["aegir"]["group"]
      user node["scratchpads"]["aegir"]["user"]
      environment node["scratchpads"]["aegir"]["environment"]
      not_if{::File.exists?("#{node["scratchpads"]["aegir"]["home_folder"]}/.drush/server_#{sanitised_server_name}.alias.drushrc.php")}
    end
    # Verify the server
    execute 'verify the server node' do
      command "drush @server_#{sanitised_server_name} provision-verify"
      cwd node["scratchpads"]["aegir"]["home_folder"]
      group node["scratchpads"]["aegir"]["group"]
      user node["scratchpads"]["aegir"]["user"]
      environment node["scratchpads"]["aegir"]["environment"]
    end
    #drush @hm hosting-import @server_spapp1nhmacuk
    # Import the server into the front end
    execute 'import the server into front end' do
      command "drush @hm hosting-import @server_#{sanitised_server_name}"
      cwd node["scratchpads"]["aegir"]["home_folder"]
      group node["scratchpads"]["aegir"]["group"]
      user node["scratchpads"]["aegir"]["user"]
      environment node["scratchpads"]["aegir"]["environment"]
    end
  end
  # Create a "pack" for all
  if sanitised_names.length > 0 then
    # sanitised_names = sanitised_names.join(",")
    # execute 'create pack server' do
    #   command "drush @hm provision-save pack_apps --context_type=server --http_service_type='pack' --slave_web_servers='#{sanitised_names}' --master_web_servers='@server_master' --remote_host='pack-servers'"
    #   cwd node["scratchpads"]["aegir"]["home_folder"]
    #   group node["scratchpads"]["aegir"]["group"]
    #   user node["scratchpads"]["aegir"]["user"]
    #   environment node["scratchpads"]["aegir"]["environment"]
    # end  
    template "#{node["scratchpads"]["aegir"]["home_folder"]}/.drush/pack_apps.alias.drushrc.php" do
      path "#{node["scratchpads"]["aegir"]["home_folder"]}/.drush/pack_apps.alias.drushrc.php"
      source 'pack_apps.alias.drushrc.php.erb'
      cookbook 'scratchpads'
      owner node["scratchpads"]["aegir"]["user"]
      group node["scratchpads"]["aegir"]["group"]
      mode '0744'
      action :create
      variables({
        :app_servers => sanitised_names,
        :node_fqdn => node['scratchpads']['control']['fqdn']
      })
    end
    execute 'verify pack server' do
      command "drush @pack_apps provision-verify"
      cwd node["scratchpads"]["aegir"]["home_folder"]
      group node["scratchpads"]["aegir"]["group"]
      user node["scratchpads"]["aegir"]["user"]
      environment node["scratchpads"]["aegir"]["environment"]
    end
    execute 'import pack server' do
      command "drush @hm hosting-import @pack_apps"
      cwd node["scratchpads"]["aegir"]["home_folder"]
      group node["scratchpads"]["aegir"]["group"]
      user node["scratchpads"]["aegir"]["user"]
      environment node["scratchpads"]["aegir"]["environment"]
    end
  end
  # Create the scratchpads-master platform on the pack server
  # First get the code
  execute 'download scratchpads code for scratchpads-master platform' do
    command "git clone https://git.scratchpads.eu/git/scratchpads-2.0.git scratchpads-master"
    cwd "#{node["scratchpads"]["aegir"]["home_folder"]}/platforms"
    group node["scratchpads"]["aegir"]["group"]
    user node["scratchpads"]["aegir"]["user"]
    environment node["scratchpads"]["aegir"]["environment"]
    not_if{::File.exists?("#{node["scratchpads"]["aegir"]["home_folder"]}/platforms/scratchpads-master")}
    retries 5
  end
  # Create database servers for each database server we know about and that
  # has not already been created.
  data_hosts = ["sp-data-1"]
  unless Chef::Config[:solo]
    data_hosts_search = search(:node, "flags:UP AND role:data")
    data_hosts = []
    data_hosts_search.each do|data_host|
      data_hosts << data_host['fqdn']
    end
  end
  data_hosts.each do|data_host|
    sanitised_server_name = data_host.gsub(/[^a-z0-9]/, '')
    # Create the server
    passwords = ScratchpadsEncryptedPasswords.new(node, node["scratchpads"]["encrypted_data_bag"])
    aegir_pw = passwords.find_password "mysql", "aegir"
    execute 'create the server node' do
      command "drush @hm provision-save server_#{sanitised_server_name} --context_type=server --remote_host=#{data_host} --db_service_type='mysql' --master_db='mysql://aegir:#{aegir_pw}@#{data_host}'"
      cwd node["scratchpads"]["aegir"]["home_folder"]
      group node["scratchpads"]["aegir"]["group"]
      user node["scratchpads"]["aegir"]["user"]
      environment node["scratchpads"]["aegir"]["environment"]
      not_if{::File.exists?("#{node["scratchpads"]["aegir"]["home_folder"]}/.drush/server_#{sanitised_server_name}.alias.drushrc.php")}
    end
    # Verify the server
    execute 'verify the server node' do
      command "drush @server_#{sanitised_server_name} provision-verify"
      cwd node["scratchpads"]["aegir"]["home_folder"]
      group node["scratchpads"]["aegir"]["group"]
      user node["scratchpads"]["aegir"]["user"]
      environment node["scratchpads"]["aegir"]["environment"]
    end
    #drush @hm hosting-import @server_spapp1nhmacuk
    # Import the server into the front end
    execute 'import the server into front end' do
      command "drush @hm hosting-import @server_#{sanitised_server_name}"
      cwd node["scratchpads"]["aegir"]["home_folder"]
      group node["scratchpads"]["aegir"]["group"]
      user node["scratchpads"]["aegir"]["user"]
      environment node["scratchpads"]["aegir"]["environment"]
    end
  end
else
  # Create the .ssh directory
  directory "#{node["scratchpads"]["aegir"]["home_folder"]}/.ssh" do
    owner node["scratchpads"]["aegir"]["user"]
    group node["scratchpads"]["aegir"]["group"]
    mode 0700
    action :create
  end
  # Save SSH keys
  enc_data_bag = ScratchpadsEncryptedPasswords.new(node, "ssh")
  lines = enc_data_bag.find_password "aegir", "public"
  template "#{node["scratchpads"]["aegir"]["home_folder"]}/.ssh/authorized_keys" do
    path "#{node["scratchpads"]["aegir"]["home_folder"]}/.ssh/authorized_keys"
    source 'empty-file.erb'
    cookbook 'scratchpads'
    owner node["scratchpads"]["aegir"]["user"]
    group node["scratchpads"]["aegir"]["group"]
    mode '0744'
    action :create
    variables({
      :lines => lines
    })
  end
end
# Link the aegir configuration to the apache sites folder
link "/etc/apache2/sites-available/aegir.conf" do
  action :create
  group "root"
  owner "root"
  to "#{node["scratchpads"]["aegir"]["home_folder"]}/config/apache.conf"
  only_if {::File.exists?("#{node["scratchpads"]["aegir"]["home_folder"]}/config/apache.conf")}
end
# Enable the aegir configuration
apache_site "aegir" do
  enable true
  only_if {::File.exists?("/etc/apache2/sites-available/aegir.conf")}
end
