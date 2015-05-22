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

# Install hostmaster/provision if the role is "control"
if node.automatic.roles.index("control") then
  # Create the .drush folder
  directory "#{node["scratchpads"]["aegir"]["home_folder"]}/.drush" do
    owner node["scratchpads"]["aegir"]["user"]
    group node["scratchpads"]["aegir"]["group"]
    mode 0755
    action :create
  end
  # Execute the basic drush commands to download the code
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

  passwords = EncryptedPasswords.new(node, node["scratchpads"]["encrypted_data_bag"])
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
  # mkdir `ls -d1 /var/aegir/hostmaster*`/sites/all/modules/contrib
  directory "#{node["scratchpads"]["aegir"]["home_folder"]}/hostmaster/sites/all/modules/contrib" do
    owner node["scratchpads"]["aegir"]["user"]
    group node["scratchpads"]["aegir"]["group"]
    mode 0755
    action :create
  end
  node["scratchpads"]["aegir"]["modules_to_download"].each do|module_name|
    # su -l -s /bin/bash -c "drush @hm dl memcache varnish" aegir
    execute "download #{module_name} module" do
      command "drush @hm dl #{module_name}"
      environment node["scratchpads"]["aegir"]["environment"]
      cwd node["scratchpads"]["aegir"]["home_folder"]
      group node["scratchpads"]["aegir"]["group"]
      user node["scratchpads"]["aegir"]["user"]
      not_if { ::File.exists?("#{node["scratchpads"]["aegir"]["home_folder"]}/hostmaster/sites/all/modules/contrib/#{module_name}")}
    end
    # mv `ls -d1 /var/aegir/hostmaster*`/sites/all/modules/memcache `ls -d1 /var/aegir/hostmaster*`/sites/all/modules/varnish `ls -d1 /var/aegir/hostmaster*`/sites/all/modules/contrib
    execute "move #{module_name} module" do
      command "mv #{node["scratchpads"]["aegir"]["home_folder"]}/hostmaster/sites/all/modules/#{module_name} #{node["scratchpads"]["aegir"]["home_folder"]}/hostmaster/sites/all/modules/contrib"
      cwd node["scratchpads"]["aegir"]["home_folder"]
      group node["scratchpads"]["aegir"]["group"]
      user node["scratchpads"]["aegir"]["user"]
      not_if { ::File.exists?("#{node["scratchpads"]["aegir"]["home_folder"]}/hostmaster/sites/all/modules/contrib/#{module_name}")}
    end
  end
  # su -l -s /bin/bash -c "drush @hm en hosting_queued hosting_alias hosting_clone hosting_cron hosting_migrate hosting_signup hosting_task_gc hosting_web_pack -y" aegir
  execute 'enable additional modules' do
    command "drush @hm en #{node["scratchpads"]["aegir"]["modules_to_install"].join(" ")} -y"
    cwd node["scratchpads"]["aegir"]["home_folder"]
    group node["scratchpads"]["aegir"]["group"]
    user node["scratchpads"]["aegir"]["user"]
    environment node["scratchpads"]["aegir"]["environment"]
  end
  # su -l -s /bin/bash -c "drush @hm upwd admin --password=scratchpads -y" aegir
  passwords = EncryptedPasswords.new(node, node["scratchpads"]["encrypted_data_bag"])
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
  enc_data_bag = EncryptedPasswords.new(node, "ssh")
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
  system "hosting-queued" do
    action :enable,:restart
  end
  # Create the memcache.inc file which will configure sites
  # to use the memcache servers on the role:data servers.
  if Chef::Config[:solo]
    data_hosts = {"sp-data-1" => {"fqdn" => "sp-data-1"}}
  else
    data_hosts = search(:node, "role:data")
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
  passwords = EncryptedPasswords.new(node, node["scratchpads"]["encrypted_data_bag"])
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
  template "#{node["scratchpads"]["aegir"]["home_folder"]}/config/includes/gloabl.inc" do
    source "global.inc.erb"
    cookbook "scratchpads"
    owner node["scratchpads"]["aegir"]["user"]
    group node["scratchpads"]["aegir"]["group"]
    mode 0644
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
  enc_data_bag = EncryptedPasswords.new(node, "ssh")
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