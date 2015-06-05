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
# Files to create
default['scratchpads']['aegir']['cookbook_files']['create-aegir-platform']['path'] = '/usr/local/sbin/create-aegir-platform'
default['scratchpads']['aegir']['cookbook_files']['create-aegir-platform']['source'] = 'create-aegir-platform'
default['scratchpads']['aegir']['cookbook_files']['create-aegir-platform']['cookbook'] = 'scratchpads'
default['scratchpads']['aegir']['cookbook_files']['create-aegir-platform']['owner'] = 'root'
default['scratchpads']['aegir']['cookbook_files']['create-aegir-platform']['group'] = 'root'
default['scratchpads']['aegir']['cookbook_files']['create-aegir-platform']['mode'] = '0755'