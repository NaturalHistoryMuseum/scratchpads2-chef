# List of hosts to always allow to mount
default['scratchpads']['nfs']['default_hosts'] = []
# NFS
default['scratchpads']['nfs']['exports']['/var/www'] = {
  'writeable' => true,
  'sync' => true,
  'options' => ['root_squash','no_subtree_check'],
  'unique' => true
}
default['scratchpads']['nfs']['exports']['/var/aegir/platforms'] = {
  'writeable' => true,
  'sync' => true,
  'options' => ['root_squash','no_subtree_check'],
  'unique' => true
}
default['scratchpads']['nfs']['exports']['/var/aegir/backups'] = {
  'writeable' => true,
  'sync' => true,
  'options' => ['root_squash','no_subtree_check'],
  'unique' => true
}
default['scratchpads']['nfs']['exports']['/var/aegir/backups-databases'] = {
  'writeable' => true,
  'sync' => true,
  'options' => ['no_root_squash','no_subtree_check'],
  'unique' => true
}
# Bash template
default['scratchpads']['nfs']['templates']['clients']['copy-control.bash.erb'] = {
  'path' => '/usr/local/sbin/copy-control',
  'cookbook' => 'scratchpads',
  'owner' => 'root',
  'group' => 'root',
  'mode' => '0755'
}