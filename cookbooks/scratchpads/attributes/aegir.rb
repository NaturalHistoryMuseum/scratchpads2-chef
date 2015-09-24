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
# Solanaceae source repository
default['scratchpads']['aegir']['solanaceae_source']['repository'] = 'https://github.com/NaturalHistoryMuseum/solanaceaesource-2.0.git'
default['scratchpads']['aegir']['solanaceae_source']['checkout_branch'] = 'master'
default['scratchpads']['aegir']['solanaceae_source']['timeout'] = 300
# Templates
default['scratchpads']['aegir']['templates']['femail_procmail_drush'] = {
  'path' => '/usr/local/bin/femail_procmail_drush',
  'source' => 'femail_procmail_drush.erb',
  'cookbook' => 'scratchpads',
  'owner' => 'root',
  'group' => 'root',
  'mode' => '0755'
}
default['scratchpads']['aegir']['templates']['.procmailrc'] = {
  'path' => '/var/aegir/.procmailrc',
  'source' => 'procmailrc.erb',
  'cookbook' => 'scratchpads',
  'owner' => 'aegir',
  'group' => 'www-data',
  'mode' => '0644'
}
default['scratchpads']['aegir']['templates']['create_scratchpads_backups'] = {
  'path' => '/usr/local/bin/create_scratchpads_backups',
  'source' => 'create_scratchpads_backups.erb',
  'cookbook' => 'scratchpads',
  'owner' => 'root',
  'group' => 'root',
  'mode' => '0755'
}
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

# Cron functions
# # Standard Aegir CRON functions.
# * * * * * drush '@hostmaster' hosting-dispatch 2>/dev/null
# * * * * * drush '@hostmaster' hosting-cron 2>/dev/null
#
# # Clear the ViBRANT site caches
# */5 * * * * drush @vbrant.eu cc all >/dev/null 2>/dev/null
#
# # Rebuild the Sandbox and delete the backups every six hours
# # Also ensure Drush commands work for the sandbox by updating the drushrc.php file with the new password
# 1 */6 * * * rm -rf /var/aegir/backups/sandbox*
# 2 */6 * * * drush '@sandbox.scratchpads.eu' provision-reinstall >/dev/null 2>/dev/null
# 15 */6 * * * sed "s/db_passwd'] = '[a-z0-9A-Z]*'/db_passwd'] = '`grep db_passwd config/server_master/apache/vhost.d/sandbox.scratchpads.eu | sed "s/.*\s//"`'/" /var/aegir/platforms/scratchpads-master/sites/sandbox.scratchpads.eu/drushrc.php -i
#
# # Run the updates on testing sites every day
# @daily for i in $(ls -1d /var/aegir/platforms/scratchpads*/sites/* | grep -v "scratchpads-1-stable" | grep -v "scratchpads-2\.[0-9]*\.[0-9]*" | sed "s|.*/||" | grep -v "php$" | grep "\." | grep -v "scratchpads.eu" | grep -vi "txt$" | sort -R); do drush @$i updatedb -y; done
#
# - Run updates on testing sites once a day
# - Clear vbrant.eu site caches (every five minutes)

# Aegir cron task
default['scratchpads']['aegir']['cron']['hosting_cron'] = {
  'minute' => '*',
  'hour' => '*',
  'day' => '*',
  'month' => '*',
  'weekday' => '*',
  'command' => 'drush @hm hosting-cron',
  'environment' => {},
  'home' => '/var/aegir',
  'action' => 'create',
  'user' => 'aegir',
  'mailto' => node['scratchpads']['control']['admin_email'],
  'path' => '/usr/local/bin:/usr/bin:/bin'
}
# Aegir garbage collection task
default['scratchpads']['aegir']['cron']['hosting_cron_garbage_collection'] = {
  'minute' => '*',
  'hour' => '*',
  'day' => '*',
  'month' => '*',
  'weekday' => '*',
  'command' => 'drush @hm hosting-task_gc',
  'environment' => {},
  'home' => '/var/aegir',
  'action' => 'create',
  'user' => 'aegir',
  'mailto' => node['scratchpads']['control']['admin_email'],
  'path' => '/usr/local/bin:/usr/bin:/bin'
}
# Rebuild the sandbox task
default['scratchpads']['aegir']['cron']['rebuild_sandbox_every_six_hours'] = {
  'minute' => '0',
  'hour' => '1,7,13,19',
  'day' => '*',
  'month' => '*',
  'weekday' => '*',
  'command' => "drush @sandbox.scratchpads.eu provision-delete && \
                drush provision-save --context_type='site' --db_server='@server_spdata2nhmacuk' --platform='@platform_scratchpadsmaster' --server='@server_automaticpack' --uri='sandbox.scratchpads.eu' --root='/var/aegir/platforms/scratchpads-master' --profile='scratchpad_2_sandbox' --client_name='admin' sandbox.scratchpads.eu && \
                drush @sandbox.scratchpads.eu provision-install && \
                drush @hm provision-verify @platform_scratchpadsmaster",
  'environment' => {},
  'home' => '/var/aegir',
  'action' => 'create',
  'user' => 'aegir',
  'mailto' => node['scratchpads']['control']['admin_email'],
  'path' => '/usr/local/bin:/usr/bin:/bin'
}
# Build the Backup archives users have requested
default['scratchpads']['aegir']['cron']['create_requested_backup_archives'] = {
  'minute' => '*',
  'hour' => '*',
  'day' => '*',
  'month' => '*',
  'weekday' => '*',
  'command' => "flock -n /tmp/create_scratchpads_backups -c /usr/local/bin/create_scratchpads_backups",
  'environment' => {},
  'home' => '/var/aegir',
  'action' => 'create',
  'user' => 'aegir',
  'mailto' => node['scratchpads']['control']['admin_email'],
  'path' => '/usr/local/bin:/usr/bin:/bin'
}
# Harvest the Scratchpads stats every four hours
default['scratchpads']['aegir']['cron']['harvest_scratchpads_stats'] = {
  'minute' => '22',
  'hour' => '*/4',
  'day' => '*',
  'month' => '*',
  'weekday' => '*',
  'command' => "drush '@scratchpads.eu' stats-aggregate >/dev/null 2>/dev/null",
  'environment' => {},
  'home' => '/var/aegir',
  'action' => 'create',
  'user' => 'aegir',
  'mailto' => node['scratchpads']['control']['admin_email'],
  'path' => '/usr/local/bin:/usr/bin:/bin'
}
# Delete backups older than one week
default['scratchpads']['aegir']['cron']['delete_week_old_backups'] = {
  'minute' => '30',
  'hour' => '1',
  'day' => '*',
  'month' => '*',
  'weekday' => '*',
  'command' => 'find /var/aegir/backups -mmin +10080 | xargs rm 2>/dev/null',
  'environment' => {},
  'home' => '/var/aegir',
  'action' => 'create',
  'user' => 'aegir',
  'mailto' => node['scratchpads']['control']['admin_email'],
  'path' => '/usr/local/bin:/usr/bin:/bin'
}