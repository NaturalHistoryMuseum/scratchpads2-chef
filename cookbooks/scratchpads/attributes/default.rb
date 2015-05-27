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
default['scratchpads']['aegir']['hostmaster_folder'] = 'hostmaster'
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
default['scratchpads']['aegir']['modules_to_install'] = ['hosting_queued','hosting_alias','hosting_clone','hosting_cron','hosting_migrate','hosting_signup','hosting_task_gc','hosting_web_pack','hosting_reinstall']
default['scratchpads']['aegir']['modules_to_download'] = ['memcache','varnish']
# Hosting Reinstall module settings for aegir
default['scratchpads']['aegir']['hosting_reinstall']['repository'] = 'http://git.drupal.org/sandbox/ergonlogic/2386543.git'
default['scratchpads']['aegir']['hosting_reinstall']['revision'] = '7.x-3.x'
default['scratchpads']['aegir']['hosting_reinstall']['checkout_branch'] = '7.x-3.x'
# Scratchpads repository
default['scratchpads']['aegir']['scratchpads_master']['repository'] = 'https://git.scratchpads.eu/git/scratchpads-2.0.git'
default['scratchpads']['aegir']['scratchpads_master']['checkout_branch'] = 'master'
default['scratchpads']['aegir']['scratchpads_master']['timeout'] = 600