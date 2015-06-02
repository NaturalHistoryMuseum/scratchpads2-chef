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

# Varnish
default['scratchpads']['varnish']['first_byte_timeout'] = '600s'
default['scratchpads']['varnish']['between_bytes_timeout'] = '600s'
default['scratchpads']['varnish']['connect_timeout'] = '600s'
default['scratchpads']['varnish']['selenium']['host'] = 'selenium.nhm.ac.uk'
default['scratchpads']['varnish']['selenium']['port'] = 80
default['scratchpads']['varnish']['selenium']['max_connections'] = 50
default['scratchpads']['varnish']['selenium']['domains'] = ['qa.scratchpads.eu']
default['scratchpads']['varnish']['redmine']['host'] = 'web-scratchpad-solr.nhm.ac.uk'
default['scratchpads']['varnish']['redmine']['port'] = 3000
default['scratchpads']['varnish']['redmine']['max_connections'] = 50
default['scratchpads']['varnish']['redmine']['domains'] = ['support.scratchpads.eu']
default['scratchpads']['varnish']['monit']['host'] = '127.0.0.1'
default['scratchpads']['varnish']['monit']['port'] = 8080
default['scratchpads']['varnish']['monit']['max_connections'] = 50
default['scratchpads']['varnish']['monit']['domains'] = ['monit.scratchpads.eu']
default['scratchpads']['varnish']['search']['domains'] = ['search.scratchpads.eu']
default['scratchpads']['varnish']['control']['host'] = '127.0.0.1'
default['scratchpads']['varnish']['control']['port'] = 80
default['scratchpads']['varnish']['control']['max_connections'] = 10
default['scratchpads']['varnish']['control']['domains'] = ['get.scratchpads.eu', node['scratchpads']['control']['fqdn']]
default['scratchpads']['varnish']['sp_app_server_port'] = 80
default['scratchpads']['varnish']['trusted_network'] = '"157.140.0.0"/16'
default['scratchpads']['varnish']['no_cache_domains'] = ['zooemu.nhm.ac.uk','edit.nhm.ac.uk']
default['scratchpads']['varnish']['no_cache_paths'] = ['^/status\.php$','^/modules/statistics/statistics\.php$','^/admin','^/uwho','^/admin/.*$','^/user','^/user/.*$','^/users/.*$','^/info/.*$','^/flag/.*$','^.*/ajax/.*$','^.*/ahah/.*$']
default['scratchpads']['varnish']['trusted_network_only_domain_paterns'] = ['^dev.','^dev-']
default['scratchpads']['varnish']['error_message'] = '<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
   <head>
     <title>"} + beresp.status + " " + beresp.reason + {"</title>
   </head>
   <body>
  <h1 class="title">Page Unavailable</h1>
  <p>The page you requested is temporarily unavailable.</p>
  <p>Error "} + beresp.status + " " + beresp.reason + {"</p>
  <p>"} + beresp.reason + {"</p>
   </body>
</html>'

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
default['scratchpads']['solr-undertow']['options'] = "-Xms#{node['scratchpads']['solr-undertow']['memory']['xms']} -Xmx#{node['scratchpads']['solr-undertow']['memory']['xmx']} -XX:MaxPermSize=#{node['scratchpads']['solr-undertow']['memory']['maxpermsize']} -XX:PermSize=#{node['scratchpads']['solr-undertow']['memory']['permsize']}"
# Init script
default['scratchpads']['solr-undertow']['templates']['bash_script']['path'] = '/usr/local/sbin/solr-undertow'
default['scratchpads']['solr-undertow']['templates']['bash_script']['cookbook'] = 'scratchpads'
default['scratchpads']['solr-undertow']['templates']['bash_script']['source'] = 'solr-undertow.bash.erb'
default['scratchpads']['solr-undertow']['templates']['bash_script']['owner'] = 'root'
default['scratchpads']['solr-undertow']['templates']['bash_script']['group'] = 'root'
default['scratchpads']['solr-undertow']['templates']['bash_script']['mode'] = '0755'
# Configuration file
default['scratchpads']['solr-undertow']['templates']['conf_file']['path'] = '/var/lib/solr-undertow/solr-undertow.conf'
default['scratchpads']['solr-undertow']['templates']['conf_file']['cookbook'] = 'scratchpads'
default['scratchpads']['solr-undertow']['templates']['conf_file']['source'] = 'solr-undertow.conf.erb'
default['scratchpads']['solr-undertow']['templates']['conf_file']['owner'] = 'root'
default['scratchpads']['solr-undertow']['templates']['conf_file']['group'] = 'root'
default['scratchpads']['solr-undertow']['templates']['conf_file']['mode'] = '0755'
# Configuration xml file
default['scratchpads']['solr-undertow']['templates']['conf_xml']['path'] = '/var/lib/solr-undertow/solr-home/solr.xml'
default['scratchpads']['solr-undertow']['templates']['conf_xml']['cookbook'] = 'scratchpads'
default['scratchpads']['solr-undertow']['templates']['conf_xml']['source'] = 'solr.xml.erb'
default['scratchpads']['solr-undertow']['templates']['conf_xml']['owner'] = 'root'
default['scratchpads']['solr-undertow']['templates']['conf_xml']['group'] = 'root'
default['scratchpads']['solr-undertow']['templates']['conf_xml']['mode'] = '0755'
# Configuration zoo file
default['scratchpads']['solr-undertow']['templates']['cfg_file']['path'] = '/var/lib/solr-undertow/solr-home/zoo.cfg'
default['scratchpads']['solr-undertow']['templates']['cfg_file']['cookbook'] = 'scratchpads'
default['scratchpads']['solr-undertow']['templates']['cfg_file']['source'] = 'zoo.cfg.erb'
default['scratchpads']['solr-undertow']['templates']['cfg_file']['owner'] = 'root'
default['scratchpads']['solr-undertow']['templates']['cfg_file']['group'] = 'root'
default['scratchpads']['solr-undertow']['templates']['cfg_file']['mode'] = '0755'
# Service file
default['scratchpads']['solr-undertow']['templates']['systemd_service']['path'] = '/etc/systemd/system/solr-undertow.service'
default['scratchpads']['solr-undertow']['templates']['systemd_service']['source'] = 'solr-undertow.service.erb'
default['scratchpads']['solr-undertow']['templates']['systemd_service']['cookbook'] = 'scratchpads'
default['scratchpads']['solr-undertow']['templates']['systemd_service']['owner'] = 'root'
default['scratchpads']['solr-undertow']['templates']['systemd_service']['group'] = 'root'
default['scratchpads']['solr-undertow']['templates']['systemd_service']['mode'] = '0644'
# core properties file
default['scratchpads']['solr-undertow']['templates']['core_properties']['path'] = '/var/lib/solr-undertow/solr-home/scratchpads2/core.properties'
default['scratchpads']['solr-undertow']['templates']['core_properties']['source'] = 'core.properties.erb'
default['scratchpads']['solr-undertow']['templates']['core_properties']['cookbook'] = 'scratchpads'
default['scratchpads']['solr-undertow']['templates']['core_properties']['owner'] = 'solrundertow'
default['scratchpads']['solr-undertow']['templates']['core_properties']['group'] = 'solrundertow'
default['scratchpads']['solr-undertow']['templates']['core_properties']['mode'] = '0644'
# Scratchpads configuration archive
default['scratchpads']['solr-undertow']['scratchpads_conf']['path'] = '/var/lib/solr-undertow/solr-home/scratchpads2/conf.tar.gz'
default['scratchpads']['solr-undertow']['scratchpads_conf']['source'] = 'conf.tar.gz'
default['scratchpads']['solr-undertow']['scratchpads_conf']['cookbook'] = 'scratchpads'
default['scratchpads']['solr-undertow']['scratchpads_conf']['owner'] = 'root'
default['scratchpads']['solr-undertow']['scratchpads_conf']['group'] = 'root'
default['scratchpads']['solr-undertow']['scratchpads_conf']['mode'] = '0644'