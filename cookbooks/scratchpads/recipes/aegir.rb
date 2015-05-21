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
  # su -l -s /bin/bash -c "drush @hm dl memcache varnish" aegir
  execute 'download memcache module' do
    command 'drush @hm dl memcache varnish'
    cwd '/var/aegir'
    group 'www-data'
    user 'aegir'
    not_if { ::File.exists?("/var/aegir/hostmaster/sites/all/modules/contrib/memcache")}
  end
  # mkdir `ls -d1 /var/aegir/hostmaster*`/sites/all/modules/contrib
  directory '/var/aegir/hostmaster/sites/all/modules/contrib' do
    owner 'aegir'
    group 'www-data'
    mode 0755
    action :create
  end
  # mv `ls -d1 /var/aegir/hostmaster*`/sites/all/modules/memcache `ls -d1 /var/aegir/hostmaster*`/sites/all/modules/varnish `ls -d1 /var/aegir/hostmaster*`/sites/all/modules/contrib
  execute 'move memcache module' do
    command 'mv /var/aegir/hostmaster/sites/all/modules/memcache /var/aegir/hostmaster/sites/all/modules/contrib'
    cwd '/var/aegir'
    group 'www-data'
    user 'aegir'
    not_if { ::File.exists?("/var/aegir/hostmaster/sites/all/modules/contrib/memcache")}
  end
  # su -l -s /bin/bash -c "drush @hm en hosting_queued hosting_alias hosting_clone hosting_cron hosting_migrate hosting_signup hosting_task_gc hosting_web_pack -y" aegir
  execute 'enable additional modules' do
    command 'drush @hm en hosting_queued hosting_alias hosting_clone hosting_cron hosting_migrate hosting_signup hosting_task_gc hosting_web_pack -y'
    cwd '/var/aegir'
    group 'www-data'
    user 'aegir'
  end
  # su -l -s /bin/bash -c "drush @hm upwd admin --password=scratchpads -y" aegir
  execute 'set the admin user password' do
    command 'drush @hm upwd admin --password=scratchpads -y'
    cwd '/var/aegir'
    group 'www-data'
    user 'aegir'
  end
  #
  # FIX CRON FOR AEGIR USER.
  #
  
  # Generate SSH keys
  execute 'generate keys' do
    command 'ssh-keygen -t rsa -N '' -f /var/aegir/.ssh/id_rsa'
    cwd '/var/aegir'
    group 'www-data'
    user 'aegir'
    not_if { ::File.exists?("/var/aegir/.ssh/id_rsa")}
  end
  # May be possible to do this using Chef - need to investigate.
  #
  # Copy public key to a location where it can be download from (no security issue here, it's the public key)
  execute 'copy public key' do
    command 'cp /var/aegir/.ssh/id_rsa.pub /var/aegir/hostmaster'
    cwd '/var/aegir'
    group 'www-data'
    user 'aegir'
    not_if { ::File.exists?("/var/aegir/hostmaster/id_rsa.pub")}
  end
  template '/var/aegir/.ssh/config' do
    path '/var/aegir/.ssh/config'
    source 'aegir-ssh-config.erb'
    cookbook 'scratchpads'
    owner 'aegir'
    group 'www-data'
    mode '0644'
    action :create
  end

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
