# List of hosts to always allow to mount
default['scratchpads']['nfs']['default_hosts'] = []
# NFS
default['scratchpads']['nfs']['exports'] = {
  '/var/www' => '/var/www',
  '/var/aegir/platforms' => '/var/aegir/platforms-remote',
  '/var/aegir/backups' => '/var/aegir/backups',
  '/var/aegir/backups-databases' => '/var/aegir/backups-databases'
}
# Bash template
default['scratchpads']['nfs']['templates']['clients']['copy-control.bash.erb'] = {
  'path' => '/usr/local/sbin/copy-control',
  'cookbook' => 'scratchpads',
  'owner' => 'root',
  'group' => 'root',
  'mode' => '0755'
}