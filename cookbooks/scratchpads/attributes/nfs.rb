# List of hosts to always allow to mount
default['scratchpads']['nfs']['default_hosts'] = []
# NFS
default['scratchpads']['nfs']['exports']['/var/www'] = {
  'writeable' => true,
  'sync' => true,
  'options' => ['root_squash','no_subtree_check'],
  'unique' => true,
  'mount_options' => 'rw,noacl,nocto,bg,ac,noatime,nodiratime,intr,hard'
}
default['scratchpads']['nfs']['exports']['/var/aegir/platforms'] = {
  'writeable' => true,
  'sync' => true,
  'options' => ['root_squash','no_subtree_check'],
  'unique' => true,
  'mount_options' => 'rw,noacl,nocto,bg,ac,noatime,nodiratime,intr,hard'
}
default['scratchpads']['nfs']['exports']['/var/aegir/backups'] = {
  'writeable' => false,
  'sync' => true,
  'options' => ['root_squash','no_subtree_check'],
  'unique' => true,
  'mount_options' => 'ro,noacl,nocto,bg,ac,noatime,nodiratime,intr,hard'
}
default['scratchpads']['nfs']['exports']['/var/aegir/backups-databases'] = {
  'writeable' => true,
  'sync' => true,
  'options' => ['no_root_squash','no_subtree_check'],
  'unique' => true,
  'mount_options' => 'rw,noacl,nocto,bg,ac,noatime,nodiratime,intr,hard'
}
default['scratchpads']['nfs']['exports']['/var/lib/redmine/default'] = {
  'writeable' => true,
  'sync' => true,
  'options' => ['no_root_squash','no_subtree_check'],
  'unique' => true,
  'mount_options' => 'rw,noacl,nocto,bg,ac,noatime,nodiratime,intr,hard'
}
# Bash template
default['scratchpads']['nfs']['templates']['clients']['copy-control.bash.erb'] = {
  'path' => '/usr/local/sbin/copy-control',
  'cookbook' => 'scratchpads',
  'owner' => 'root',
  'group' => 'root',
  'mode' => '0755'
}