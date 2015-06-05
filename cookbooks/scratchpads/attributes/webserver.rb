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
default['scratchpads']['webserver']['apache']['templates']['cite.scratchpads.eu'] = {
  'source' => 'cite.scratchpads.eu.erb',
  'cookbook' => 'scratchpads',
  'servername' => 'cite.scratchpads.eu',
  'documentroot' => '/var/www/cite.scratchpads.eu',
  'git' => 'https://git.scratchpads.eu/git/cite.scratchpads.eu.git',
  'templates' => {
    'source' => 'conf.php.erb',
    'cookbook' => 'scratchpads',
    'path' => "#{node['scratchpads']['webserver']['apache']['templates']['cite.scratchpads.eu']['documentroot']}/conf.php",
    'owner' => node['apache']['user'],
    'group' => node['apache']['group'],
    'mode' => '0755'
  },
  'database' => {
    'user' => '',
    'password' => '',
    'host' => '',
    'database' => 'citescratchpadseu'
  }
}

# PHP settings
default['scratchpads']['webserver']['php']['php5enmod_command'] = '/usr/sbin/php5enmod'
default['scratchpads']['webserver']['php']['session_save_path'] = '/var/www/php-sessions'

# Pear settings
default['scratchpads']['webserver']['php']['pear']['pear_modules_custom_channels'] = {'drush' => 'pear.drush.org'}
default['scratchpads']['webserver']['php']['pear']['pecl_modules'] = ['uploadprogress','mailparse']