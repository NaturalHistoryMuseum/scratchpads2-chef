# Apache settings
default['scratchpads']['webserver']['apache']['additional_modules'] = ['expires']
default['scratchpads']['webserver']['apache']['templates']['cc-mirror.scratchpads.eu'] = {
  'source' => 'cc-mirror.scratchpads.eu.erb',
  'cookbook' => 'scratchpads',
  'servername' => 'cc-mirror.scratchpads.eu',
  'documentroot' => '/var/www/cc-mirror.scratchpads.eu',
  'files' => {
    'cookbook' => 'scratchpads',
    'source' => 'cc-mirror.scratchpads.eu.tar.gz'
  }
}
default['scratchpads']['webserver']['apache']['templates']['help.scratchpads.eu'] = {
  'source' => 'help.scratchpads.eu.erb',
  'cookbook' => 'scratchpads',
  'servername' => 'help.scratchpads.eu',
  'documentroot' => '/var/www/mediawiki'
}
default['scratchpads']['webserver']['apache']['templates']['backup.scratchpads.eu'] = {
  'source' => 'backup.scratchpads.eu.erb',
  'cookbook' => 'scratchpads',
  'servername' => 'backup.scratchpads.eu',
  'documentroot' => '/var/aegir/backups'
}
passwords = ScratchpadsEncryptedPasswords.new(node, node['scratchpads']['encrypted_data_bag'])
if Chef::Config[:solo]
  data_host = {'fqdn' => 'sp-data-1'}
else
  data_hosts = search(:node, 'flags:UP AND roles:data')
  data_host = data_hosts.first
end
cite_scratchpads_eu_db_user = passwords.find_password 'cite.scratchpads.eu', 'user'
cite_scratchpads_eu_db_password = passwords.find_password 'cite.scratchpads.eu', 'password'
default['scratchpads']['webserver']['apache']['templates']['cite.scratchpads.eu'] = {
  'source' => 'cite.scratchpads.eu.erb',
  'cookbook' => 'scratchpads',
  'servername' => 'cite.scratchpads.eu',
  'documentroot' => '/var/www/cite.scratchpads.eu',
  'git' => 'https://git.scratchpads.eu/git/cite.scratchpads.eu.git',
  'templates' => {
    'conf.php' => {
      'source' => 'conf.php.erb',
      'cookbook' => 'scratchpads',
      'path' => '/var/www/cite.scratchpads.eu/conf.php',
      'owner' => node['apache']['user'],
      'group' => node['apache']['group'],
      'mode' => '0755'
    },
  },
  'database' => {
    'user' => cite_scratchpads_eu_db_user,
    'password' => cite_scratchpads_eu_db_password,
    'host' => data_host['fqdn'],
    'database' => 'citescratchpadseu'
  }
}
apache = ScratchpadsEncryptedPasswords.new(node, 'apache')
git_scratchpads_eu_crt_lines = apache.find_password 'certificates', 'certificate'
git_scratchpads_eu_key_lines = apache.find_password 'certificates', 'key'
git_scratchpads_eu_chain_lines = apache.find_password 'certificates', 'chain'
default['scratchpads']['webserver']['apache']['templates']['git.scratchpads.eu'] = {
  'source' => 'git.scratchpads.eu.erb',
  'cookbook' => 'scratchpads',
  'servername' => 'git.scratchpads.eu',
  'documentroot' => '/var/www/git.scratchpads.eu',
  'templates' => {
    'git.scratchpads.eu.crt' => {
      'source' => 'empty-file.erb',
      'cookbook' => 'scratchpads',
      'path' => '/etc/ssl/certs/git.scratchpads.eu.crt',
      'owner' => 'root',
      'group' => 'root',
      'mode' => '0644',
      'variables' => ({
        :lines => git_scratchpads_eu_crt_lines
      })  
    },
    'git.scratchpads.eu.key' => {
      'source' => 'empty-file.erb',
      'cookbook' => 'scratchpads',
      'path' => '/etc/ssl/private/git.scratchpads.eu.key',
      'owner' => 'root',
      'group' => 'root',
      'mode' => '0644',
      'variables' => ({
        :lines => git_scratchpads_eu_key_lines
      })  
    },
    'git.scratchpads.eu.ca-bundle' => {
      'source' => 'empty-file.erb',
      'cookbook' => 'scratchpads',
      'path' => '/etc/ssl/certs/git.scratchpads.eu.ca-bundle',
      'owner' => 'root',
      'group' => 'root',
      'mode' => '0644',
      'variables' => ({
        :lines => git_scratchpads_eu_chain_lines
      })  
    }
  }
}

# PHP settings
default['scratchpads']['webserver']['php']['php5enmod_command'] = '/usr/sbin/php5enmod'
default['scratchpads']['webserver']['php']['session_save_path'] = '/var/www/php-sessions'

# Pear settings
default['scratchpads']['webserver']['php']['pear']['pear_modules_custom_channels'] = {'drush' => 'pear.drush.org'}
default['scratchpads']['webserver']['php']['pear']['pecl_modules'] = ['uploadprogress','mailparse']