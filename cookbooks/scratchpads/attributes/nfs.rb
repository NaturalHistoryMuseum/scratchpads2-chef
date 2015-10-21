# List of hosts to always allow to mount.
# This attribute can be used when adding an additional server (e.g. a new application server) to the setup.
# The new machine should be temporarily added, the chef-client should be run on the control server, and
# finally the new server should be bootstrapped. Once that has been done, the default_hosts attribute can
# be restored to what it was before. Full instructions for this are included in the documentation.
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