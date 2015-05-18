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

# Create the aegir directory and the drush folder
directory '/var/aegir' do
  owner 'aegir'
  group 'www-data'
  mode 0755
  action :create
end
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
end

# Clear the drush cache so that the provision command is found.
execute 'clear drush cache' do
  command 'drush cache-clear drush'
  cwd '/var/aegir'
  group 'www-data'
  user 'aegir'
end

# Install hostmaster
passwords = EncryptedPasswords.new(node, node["scratchpads"]["encrypted_data_bag"])
aegir_pw = passwords.find_password "mysql", "aegir"
execute 'install hostmaster' do
  command "drush hostmaster-install --aegir_db_pass='#{aegir_pw}' --root=/var/aegir/hostmaster --aegir_db_user=#{node['scratchpads']['control']['aegir']['dbuser']} --aegir_db_host=#{node['scratchpads']['control']['dbserver']} #{node['scratchpads']['control']['fqdn']} -y"
  cwd '/var/aegir'
  group 'www-data'
  user 'aegir'
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
