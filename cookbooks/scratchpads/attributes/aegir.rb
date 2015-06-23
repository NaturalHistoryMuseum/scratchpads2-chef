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
default['scratchpads']['aegir']['modules_to_install'] = [
  'beautytips_ui',
  'image_captcha',
  'less',
  'hosting_alias',
  'hosting_auto_pack',
  'hosting_clone',
  'hosting_cron',
  'hosting_migrate',
  'hosting_queued',
  'hosting_reinstall',
  'hosting_scratchpads',
  'hosting_signup',
  'hosting_task_gc',
  'hosting_web_pack',
  'scratchpads_eu'
]
default['scratchpads']['aegir']['modules_to_disable'] = [
  'betterlogin'
]
default['scratchpads']['aegir']['modules_to_download'] = [
  'beautytips',
  'captcha',
  'less',
  'libraries',
  'memcache',
  'varnish',
  'themekey'
]
# Hosting Reinstall module settings for aegir
default['scratchpads']['aegir']['hosting_reinstall']['repository'] = 'http://git.drupal.org/sandbox/ergonlogic/2386543.git'
default['scratchpads']['aegir']['hosting_reinstall']['revision'] = '7.x-3.x'
default['scratchpads']['aegir']['hosting_reinstall']['checkout_branch'] = '7.x-3.x'
# Hosting Auto Pack module settings for aegir
default['scratchpads']['aegir']['hosting_auto_pack']['repository'] = 'https://github.com/NaturalHistoryMuseum/hosting_auto_pack.git'
default['scratchpads']['aegir']['hosting_auto_pack']['checkout_branch'] = 'master'
# Hosting Scratchpads module settings for aegir
default['scratchpads']['aegir']['hosting_scratchpads']['repository'] = 'https://github.com/NaturalHistoryMuseum/hosting_scratchpads.git'
default['scratchpads']['aegir']['hosting_scratchpads']['checkout_branch'] = 'master'
# Scratchpads-master repository
default['scratchpads']['aegir']['scratchpads_master']['repository'] = 'https://github.com/NaturalHistoryMuseum/scratchpads2.git'
default['scratchpads']['aegir']['scratchpads_master']['checkout_branch'] = 'master'
default['scratchpads']['aegir']['scratchpads_master']['timeout'] = 3000
# Scratchpads.eu repository
default['scratchpads']['aegir']['scratchpads.eu']['repository'] = 'https://github.com/NaturalHistoryMuseum/scratchpads.eu.git'
default['scratchpads']['aegir']['scratchpads.eu']['checkout_branch'] = 'master'
default['scratchpads']['aegir']['scratchpads.eu']['timeout'] = 3000
# Files to create
default['scratchpads']['aegir']['cookbook_files']['create-aegir-platform'] = {
  'path' => '/usr/local/bin/create-aegir-platform',
  'source' => 'create-aegir-platform',
  'cookbook' => 'scratchpads',
  'owner' => 'root',
  'group' => 'root',
  'mode' => '0755'
}
default['scratchpads']['aegir']['cookbook_files']['aegir-patch'] = {
  'path' => '/var/chef/hosting_signup-form-fix-2507397-1.patch',
  'source' => 'hosting_signup-form-fix-2507397-1.patch',
  'cookbook' => 'scratchpads',
  'owner' => 'root',
  'group' => 'root',
  'mode' => '0755'
}
