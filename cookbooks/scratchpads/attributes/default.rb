# Encrypted data file path
default['scratchpads']['encrypted_data_secret_file_path'] = '/vagrant/.chef/encrypted_data_bag_secret'

# Passwords bag
default['scratchpads']['encrypted_data_bag'] = 'passwords'

# FQDN of the control server (this probably shouldn't be set here)
default['scratchpads']['control']['fqdn'] = 'sp-control-1.nhm.ac.uk'

# Role of the control server
default['scratchpads']['control']['role'] = 'control'

# Aegir database user
default['scratchpads']['control']['aegir']['dbuser'] = 'aegir'
default['scratchpads']['control']['aegir']['dbuserhost'] = '%'
#default['scratchpads']['control']['aegir']['host'] = 'sp-control-1'
default['scratchpads']['control']['aegir']['dbname'] = 'aegir'

# Aegir database server
default['scratchpads']['control']['dbserver'] = 'localhost'
default['scratchpads']['control']['dbuser'] = 'root'
default['scratchpads']['control']['admin_email'] = 's.rycroft@nhm.ac.uk'

# Extra SQL files
default['scratchpads']['percona']['percona-functions-file'] = '/tmp/percona-functions.sql'
default['scratchpads']['percona']['secure-installation-file'] = '/tmp/secure-installation.sql'

# Drush config folder
default['scratchpads']['control']['drush_config_folder'] = '.drush'
default['scratchpads']['control']['drush_command'] = '/usr/bin/drush'

# Aegir settings
default['scratchpads']['aegir']['home_folder'] = '/var/aegir'
default['scratchpads']['aegir']['hostmaster_folder'] = 'platforms/hostmaster'
default['scratchpads']['aegir']['environment'] = ({
  'SHELL' => '/bin/bash',
  'TERM' => 'xterm',
  'USER' => 'aegir',
  'MAIL' => '/var/mail/aegir',
  'PATH' => '/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games',
  'PWD' => default['scratchpads']['aegir']['home_folder'],
  'LANG' => 'en_GB.UTF-8',
  'SHLVL' => '1',
  'HOME' => default['scratchpads']['aegir']['home_folder']
})
default['scratchpads']['aegir']['shell'] = '/bin/bash'
default['scratchpads']['aegir']['comment'] = 'User which runs all of the behind the scenes actions.'
default['scratchpads']['aegir']['group'] = 'www-data'
default['scratchpads']['aegir']['user'] = 'aegir'
default['scratchpads']['aegir']['provision_version'] = 'provision-7.x-3.x'
default['scratchpads']['aegir']['modules_to_install'] = ['hosting_queued','hosting_alias','hosting_clone','hosting_cron','hosting_migrate','hosting_signup','hosting_task_gc','hosting_web_pack','hosting_reinstall','hosting_auto_pack']
default['scratchpads']['aegir']['modules_to_download'] = ['memcache','varnish']
# Hosting Reinstall module settings for aegir
default['scratchpads']['aegir']['hosting_reinstall']['repository'] = 'http://git.drupal.org/sandbox/ergonlogic/2386543.git'
default['scratchpads']['aegir']['hosting_reinstall']['revision'] = '7.x-3.x'
default['scratchpads']['aegir']['hosting_reinstall']['checkout_branch'] = '7.x-3.x'
# Hosting Auto Pack module settings for aegir
default['scratchpads']['aegir']['hosting_auto_pack']['repository'] = 'https://git.scratchpads.eu/git/hosting_auto_pack.git'
default['scratchpads']['aegir']['hosting_auto_pack']['checkout_branch'] = 'master'
# Scratchpads repository
default['scratchpads']['aegir']['scratchpads_master']['repository'] = 'https://git.scratchpads.eu/git/scratchpads-2.0.git'
default['scratchpads']['aegir']['scratchpads_master']['checkout_branch'] = 'master'
default['scratchpads']['aegir']['scratchpads_master']['timeout'] = 600

# Solr
default['scratchpads']['solr-undertow']['port'] = 8983
default['scratchpads']['solr-undertow']['solr_home_folder'] = './solr-home'
default['scratchpads']['solr-undertow']['solr_logs_folder'] = '/var/log/solr-undertow'
default['scratchpads']['solr-undertow']['solr_temp_folder'] = '/tmp'
default['scratchpads']['solr-undertow']['solr_wars_folder'] = './solr-wars'
default['scratchpads']['solr-undertow']['release_version'] = '1.3.0'
default['scratchpads']['solr-undertow']['solr_version'] = '4.10.4'
default['scratchpads']['solr-undertow']['release_url'] = "https://github.com/bremeld/solr-undertow/releases/download/v#{node['scratchpads']['solr-undertow']['release_version']}/solr-undertow-#{node['scratchpads']['solr-undertow']['release_version']}-with-solr-#{node['scratchpads']['solr-undertow']['solr_version']}.tgz"
default['scratchpads']['solr-undertow']['application_folder'] = '/usr/local/share/solr-undertow'
default['scratchpads']['solr-undertow']['data_folder'] = '/var/lib/solr-undertow'
default['scratchpads']['solr-undertow']['user'] = 'solrundertow'
default['scratchpads']['solr-undertow']['group'] = 'solrundertow'
default['scratchpads']['solr-undertow']['shell'] = '/bin/bash'
default['scratchpads']['solr-undertow']['memory']['xms'] = '8G'
default['scratchpads']['solr-undertow']['memory']['xmx'] = '8G'
default['scratchpads']['solr-undertow']['memory']['maxpermsize'] = '512m'
default['scratchpads']['solr-undertow']['memory']['permsize'] = '256m'
# Init script
default['scratchpads']['solr-undertow']['bash_script']['path'] = '/usr/local/sbin/solr-undertow'
default['scratchpads']['solr-undertow']['bash_script']['cookbook'] = 'scratchpads'
default['scratchpads']['solr-undertow']['bash_script']['source'] = 'solr-undertow.bash.erb'
default['scratchpads']['solr-undertow']['bash_script']['owner'] = 'root'
default['scratchpads']['solr-undertow']['bash_script']['group'] = 'root'
default['scratchpads']['solr-undertow']['bash_script']['mode'] = '0755'
# Configuration file
default['scratchpads']['solr-undertow']['conf_file']['path'] = '/var/lib/solr-undertow/solr-undertow.conf'
default['scratchpads']['solr-undertow']['conf_file']['cookbook'] = 'scratchpads'
default['scratchpads']['solr-undertow']['conf_file']['source'] = 'solr-undertow.conf.erb'
default['scratchpads']['solr-undertow']['conf_file']['owner'] = 'root'
default['scratchpads']['solr-undertow']['conf_file']['group'] = 'root'
default['scratchpads']['solr-undertow']['conf_file']['mode'] = '0755'
# Configuration xml file
default['scratchpads']['solr-undertow']['conf_xml']['path'] = '/var/lib/solr-undertow/solr-home/solr.xml'
default['scratchpads']['solr-undertow']['conf_xml']['cookbook'] = 'scratchpads'
default['scratchpads']['solr-undertow']['conf_xml']['source'] = 'solr.xml.erb'
default['scratchpads']['solr-undertow']['conf_xml']['owner'] = 'root'
default['scratchpads']['solr-undertow']['conf_xml']['group'] = 'root'
default['scratchpads']['solr-undertow']['conf_xml']['mode'] = '0755'
# Configuration zoo file
default['scratchpads']['solr-undertow']['cfg_file']['path'] = '/var/lib/solr-undertow/solr-home/zoo.cfg'
default['scratchpads']['solr-undertow']['cfg_file']['cookbook'] = 'scratchpads'
default['scratchpads']['solr-undertow']['cfg_file']['source'] = 'zoo.cfg.erb'
default['scratchpads']['solr-undertow']['cfg_file']['owner'] = 'root'
default['scratchpads']['solr-undertow']['cfg_file']['group'] = 'root'
default['scratchpads']['solr-undertow']['cfg_file']['mode'] = '0755'
# Service file
default['scratchpads']['solr-undertow']['systemd_service']['path'] = '/etc/systemd/system/solr-undertow.service'
default['scratchpads']['solr-undertow']['systemd_service']['source'] = 'solr-undertow.service.erb'
default['scratchpads']['solr-undertow']['systemd_service']['cookbook'] = 'scratchpads'
default['scratchpads']['solr-undertow']['systemd_service']['owner'] = 'root'
default['scratchpads']['solr-undertow']['systemd_service']['group'] = 'root'
default['scratchpads']['solr-undertow']['systemd_service']['mode'] = '0644'
# Scratchpads configuration archive
default['scratchpads']['solr-undertow']['scratchpads_conf']['path'] = '/var/lib/solr-undertow/solr-home/scratchpads2/conf.tar.gz'
default['scratchpads']['solr-undertow']['scratchpads_conf']['source'] = 'conf.tar.gz'
default['scratchpads']['solr-undertow']['scratchpads_conf']['cookbook'] = 'scratchpads'
default['scratchpads']['solr-undertow']['scratchpads_conf']['owner'] = 'root'
default['scratchpads']['solr-undertow']['scratchpads_conf']['group'] = 'root'
default['scratchpads']['solr-undertow']['scratchpads_conf']['mode'] = '0644'