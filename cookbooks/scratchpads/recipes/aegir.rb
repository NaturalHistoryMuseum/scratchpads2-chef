#
# Cookbook Name:: scratchpads
# Recipe:: aegir
#
# Copyright (c) 2015 The Authors, All Rights Reserved.


# Create the aegir directory
directory '/var/aegir' do
  owner 'aegir'
  group 'www-data'
  mode 0755
  action :create
end

# Install hostmaster/provision if the role is "control"
if node.automatic.roles.index("control") then
  # Create the .drush folder
  directory '/var/aegir/.drush' do
    owner 'aegir'
    group 'www-data'
    mode 0755
    action :create
  end
  # Execute the basic drush commands to download the code
  execute 'download provision' do
    command 'drush dl --destination=/var/aegir/.drush provision-7.x-3.x'
    cwd '/var/aegir'
    group 'www-data'
    user 'aegir'
    not_if { ::File.exists?("/var/aegir/.drush/provision/provision.info")}
  end

  # Clear the drush cache so that the provision command is found.
  execute 'clear drush cache' do
    command 'drush cache-clear drush'
    cwd '/var/aegir'
    group 'www-data'
    user 'aegir'
  end

  passwords = EncryptedPasswords.new(node, node["scratchpads"]["encrypted_data_bag"])
  aegir_pw = passwords.find_password "mysql", "aegir"
  execute 'install hostmaster' do
    command "drush hostmaster-install \
             --aegir_db_pass='#{aegir_pw}' \
             --root=/var/aegir/hostmaster \
             --aegir_db_user=#{node['scratchpads']['control']['aegir']['dbuser']} \
             --aegir_db_host=#{node['scratchpads']['control']['dbserver']} \
             --client_email=#{node['scratchpads']['control']['admin_email']} \
             #{node['scratchpads']['control']['fqdn']} \
             -y"
    cwd '/var/aegir'
    group 'www-data'
    user 'aegir'
    not_if { ::File.exists?("/var/aegir/.drush/hm.alias.drushrc.php")}
    environment(
      'SHELL' => '/bin/bash',
      'TERM' => 'xterm',
      'USER' => 'aegir',
      'MAIL' => '/var/mail/aegir',
      'PATH' => '/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games',
      'PWD' => '/var/aegir',
      'LANG' => 'en_GB.UTF-8',
      'SHLVL' => '1',
      'HOME' => '/var/aegir'
    )
  end
# # Download the memcache module, and move it to the correct folder (under 
# # contrib)
# su -l -s /bin/bash -c "drush @hm dl memcache varnish" aegir
# mkdir `ls -d1 /var/aegir/hostmaster*`/sites/all/modules/contrib
# mv `ls -d1 /var/aegir/hostmaster*`/sites/all/modules/memcache `ls -d1 /var/aegir/hostmaster*`/sites/all/modules/varnish `ls -d1 /var/aegir/hostmaster*`/sites/all/modules/contrib
# # Install additional modules
# su -l -s /bin/bash -c "drush @hm en hosting_queued hosting_alias hosting_clone hosting_cron hosting_migrate hosting_signup hosting_task_gc hosting_web_pack -y" aegir
# # Set the password for the admin user to "password", just to make it easier to
# # access and reset
# su -l -s /bin/bash -c "drush @hm upwd admin --password=scratchpads -y" aegir
# # Update the cron for the aegir user
# # su -l -s /bin/bash -c 'echo "NEW CRON LINE"|crontab -' aegir 
# # Generate SSH keys
# su -l -s /bin/bash -c "ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa" aegir
# # COPY THE key to the webserver, and download it from there on to each host we
# # setup
# cp /var/aegir/.ssh/id_rsa.pub `ls -d1 /var/aegir/hostmaster*`
# echo "Host *
#    StrictHostKeyChecking no
#    UserKnownHostsFile=/dev/null" > ~aegir/.ssh/config
# chown aegir:aegir ~aegir/.ssh/config

  template '/etc/systemd/system/hosting-queued.service' do
    path '/etc/systemd/system/hosting-queued.service'
    source 'hosting-queued.service.erb'
    cookbook 'scratchpads'
    owner 'root'
    group 'root'
    mode '0644'
    action :create
    notifies :run, 'execute[restart_systemctl_daemon]', :immediately
    notifies :restart, 'service[hosting-queued]', :delayed
  end
  system "hosting-queued" do
    action :enable,:restart
  end
end

# Link the aegir configuration to the apache sites folder
link "/etc/apache2/sites-available/aegir.conf" do
  action :create
  group "root"
  owner "root"
  to "/var/aegir/config/apache.conf"
  only_if "test -f /var/aegir/config/apache.conf"
end

# Enable the aegir configuration
apache_site "aegir" do
  enable true
  only_if "test -L /etc/apache2/sites-available/aegir.conf"	
end
