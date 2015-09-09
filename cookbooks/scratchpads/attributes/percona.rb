# Percona

# Extra SQL files (compressed or not)
default['scratchpads']['percona']['percona-functions-file'] = 'percona-functions.sql'
default['scratchpads']['percona']['secure-installation-file'] = 'secure-installation.sql'
default['scratchpads']['percona']['gm3_data_file'] = 'gm3.sql.gz'

# Cron functions for backup
# Rotate previous weeks backups before creating full backup.
default['scratchpads']['percona']['cron']['rotate_backups'] = {
  'minute' => 33,
  'hour' => 3,
  'day' => '*',
  'month' => '*',
  'weekday' => 0,
  'command' => "rm -rf /var/aegir/backups-databases/#{node['fqdn']}.3 ; mv /var/aegir/backups-databases/#{node['fqdn']}.2 /var/aegir/backups-databases/#{node['fqdn']}.3 ; mv /var/aegir/backups-databases/#{node['fqdn']}.1 /var/aegir/backups-databases/#{node['fqdn']}.2 ; mv /var/aegir/backups-databases/#{node['fqdn']} /var/aegir/backups-databases/#{node['fqdn']}.1",
  'environment' => {},
  'home' => '/root',
  'action' => 'create',
  'user' => 'root',
  'mailto' => node['scratchpads']['control']['admin_email'],
  'path' => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
}
# Prepare the full backup at the start of the week and the incremental backups
default['scratchpads']['percona']['cron']['weekly_prepare_backup'] = {
  'minute' => 33,
  'hour' => 4,
  'day' => '*',
  'month' => '*',
  'weekday' => 0,
  'command' => "xtrabackup --backup --target-dir=/var/aegir/backups-databases/#{node['fqdn']} 2> /var/log/xtrabackup.log",
  'environment' => {},
  'home' => '/root',
  'action' => 'create',
  'user' => 'root',
  'mailto' => node['scratchpads']['control']['admin_email'],
  'path' => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
}   
default['scratchpads']['percona']['cron']['incremental_backup_mon'] = {
  'minute' => 33,
  'hour' => 4,
  'day' => '*',
  'month' => '*',
  'weekday' => 1,
  'command' => "xtrabackup --backup --target-dir=/var/aegir/backups-databases/#{node['fqdn']}/mon --incremental-basedir=/var/aegir/backups-databases/#{node['fqdn']} 2>> /var/log/xtrabackup.log",
  'environment' => {},
  'home' => '/root',
  'action' => 'create',
  'user' => 'root',
  'mailto' => node['scratchpads']['control']['admin_email'],
  'path' => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
}
default['scratchpads']['percona']['cron']['incremental_backup_tue'] = {
  'minute' => 33,
  'hour' => 4,
  'day' => '*',
  'month' => '*',
  'weekday' => 2,
  'command' => "xtrabackup --backup --target-dir=/var/aegir/backups-databases/#{node['fqdn']}/tue --incremental-basedir=/var/aegir/backups-databases/#{node['fqdn']}/mon 2>> /var/log/xtrabackup.log",
  'environment' => {},
  'home' => '/root',
  'action' => 'create',
  'user' => 'root',
  'mailto' => node['scratchpads']['control']['admin_email'],
  'path' => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
}
default['scratchpads']['percona']['cron']['incremental_backup_wed'] = {
  'minute' => 33,
  'hour' => 4,
  'day' => '*',
  'month' => '*',
  'weekday' => 3,
  'command' => "xtrabackup --backup --target-dir=/var/aegir/backups-databases/#{node['fqdn']}/wed --incremental-basedir=/var/aegir/backups-databases/#{node['fqdn']}/tue 2>> /var/log/xtrabackup.log",
  'environment' => {},
  'home' => '/root',
  'action' => 'create',
  'user' => 'root',
  'mailto' => node['scratchpads']['control']['admin_email'],
  'path' => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
}
default['scratchpads']['percona']['cron']['incremental_backup_thu'] = {
  'minute' => 33,
  'hour' => 4,
  'day' => '*',
  'month' => '*',
  'weekday' => 4,
  'command' => "xtrabackup --backup --target-dir=/var/aegir/backups-databases/#{node['fqdn']}/thu --incremental-basedir=/var/aegir/backups-databases/#{node['fqdn']}/wed 2>> /var/log/xtrabackup.log",
  'environment' => {},
  'home' => '/root',
  'action' => 'create',
  'user' => 'root',
  'mailto' => node['scratchpads']['control']['admin_email'],
  'path' => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
}
default['scratchpads']['percona']['cron']['incremental_backup_fri'] = {
  'minute' => 33,
  'hour' => 4,
  'day' => '*',
  'month' => '*',
  'weekday' => 5,
  'command' => "xtrabackup --backup --target-dir=/var/aegir/backups-databases/#{node['fqdn']}/fri --incremental-basedir=/var/aegir/backups-databases/#{node['fqdn']}/thu 2>> /var/log/xtrabackup.log",
  'environment' => {},
  'home' => '/root',
  'action' => 'create',
  'user' => 'root',
  'mailto' => node['scratchpads']['control']['admin_email'],
  'path' => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
}
default['scratchpads']['percona']['cron']['incremental_backup_sat'] = {
  'minute' => 33,
  'hour' => 4,
  'day' => '*',
  'month' => '*',
  'weekday' => 6,
  'command' => "xtrabackup --backup --target-dir=/var/aegir/backups-databases/#{node['fqdn']}/sat --incremental-basedir=/var/aegir/backups-databases/#{node['fqdn']}/fri 2>> /var/log/xtrabackup.log",
  'environment' => {},
  'home' => '/root',
  'action' => 'create',
  'user' => 'root',
  'mailto' => node['scratchpads']['control']['admin_email'],
  'path' => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
}

# Additional settings for the my.cnf file.
#
# Note, additional settings can be added easily (or can they - need to check).
default['scratchpads']['percona']['row_format'] = 'COMPRESSED'
default['scratchpads']['percona']['collation'] = 'utf8mb4_unicode_ci'
default['scratchpads']['percona']['charset'] = 'utf8mb4'