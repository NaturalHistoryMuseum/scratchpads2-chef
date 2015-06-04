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
default['scratchpads']['solr-undertow']['templates']['bash_script'] = {
  'path' => '/usr/local/sbin/solr-undertow',
  'cookbook' => 'scratchpads',
  'source' => 'solr-undertow.bash.erb',
  'owner' => 'root',
  'group' => 'root',
  'mode' => '0755'
}
# Configuration file
default['scratchpads']['solr-undertow']['templates']['conf_file'] = {
  'path' => '/var/lib/solr-undertow/solr-undertow.conf',
  'cookbook' => 'scratchpads',
  'source' => 'solr-undertow.conf.erb',
  'owner' => 'root',
  'group' => 'root',
  'mode' => '0755'
}
# Configuration xml file
default['scratchpads']['solr-undertow']['templates']['conf_xml'] = {
  'path' => '/var/lib/solr-undertow/solr-home/solr.xml',
  'cookbook' => 'scratchpads',
  'source' => 'solr.xml.erb',
  'owner' => 'root',
  'group' => 'root',
  'mode' => '0755'
}
# Configuration zoo file
default['scratchpads']['solr-undertow']['templates']['cfg_file'] = {
  'path' => '/var/lib/solr-undertow/solr-home/zoo.cfg',
  'cookbook' => 'scratchpads',
  'source' => 'zoo.cfg.erb',
  'owner' => 'root',
  'group' => 'root',
  'mode' => '0755'
}
# Service file
default['scratchpads']['solr-undertow']['templates']['systemd_service'] = {
  'path' => '/etc/systemd/system/solr-undertow.service',
  'source' => 'solr-undertow.service.erb',
  'cookbook' => 'scratchpads',
  'owner' => 'root',
  'group' => 'root',
  'mode' => '0644'
}
# core properties file
default['scratchpads']['solr-undertow']['templates']['core_properties'] = {
  'path' => '/var/lib/solr-undertow/solr-home/scratchpads2/core.properties',
  'source' => 'core.properties.erb',
  'cookbook' => 'scratchpads',
  'owner' => 'solrundertow',
  'group' => 'solrundertow',
  'mode' => '0644'
}
# Scratchpads configuration archive
default['scratchpads']['solr-undertow']['scratchpads_conf'] = {
  'path' => '/var/lib/solr-undertow/solr-home/scratchpads2/conf.tar.gz',
  'source' => 'conf.tar.gz',
  'cookbook' => 'scratchpads',
  'owner' => 'root',
  'group' => 'root',
  'mode' => '0644'
}