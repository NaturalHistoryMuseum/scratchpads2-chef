# Desktop machines that we will allow to SSH and access privileged ports on each machine
default['scratchpads']['trusted_ip_addresses'] = [
  '157.140.3.192/26',
  '157.140.121.33/32',
  '157.140.126.0/24',
  '192.168.0.0/16',
  '10.0.0.0/16'
]
# Permanently blocked IP addresses (rude Bots or spammers)
default['scratchpads']['blocked_ip_addresses'] = [
  '185.38.251.209',
  '98.159.241.2',
  '5.9.32.222'
]
# The following will be populated during a Chef run.
default['scratchpads']['all_ip_addresses'] = []

# Encrypted data file path
default['scratchpads']['encrypted_data_bag_secret_file'] = '/etc/chef/encrypted_data_bag_secret'

# Passwords bag
default['scratchpads']['encrypted_data_bag'] = 'passwords'

# Default host prefix needs to be set to the empty string
default['scratchpads']['hostname_prefix'] = ''

# URL of the Aegir instance
default['scratchpads']['control']['aegir_url'] = 'get.scratchpads.eu'

# search/domain for the servers.
default['scratchpads']['domain'] = 'nhm.ac.uk'
default['scratchpads']['nameservers'] = ['157.140.15.233', '157.140.15.86']

# Roles
# Note, ensure you do not use an attribute named 'roles' which contains an array
# of these role names. It will totally screw with all searches on the chef-server,
# and will therefore ruin the whole server configuration.
default['scratchpads']['control']['role'] = 'scratchpads-role-control'
default['scratchpads']['app']['role'] = 'scratchpads-role-app'
default['scratchpads']['data']['role'] = 'scratchpads-role-data'
default['scratchpads']['search']['role'] = 'scratchpads-role-search'
default['scratchpads']['monit']['role'] = 'scratchpads-role-monit'
default['scratchpads']['ntp']['role'] = 'scratchpads-role-ntp'
default['scratchpads']['percona']['role'] = 'scratchpads-role-percona'
default['scratchpads']['apache']['role'] = 'scratchpads-role-apache'
default['scratchpads']['search-slave']['role'] = 'scratchpads-role-search-slave'

# Aegir database user
default['scratchpads']['control']['aegir']['dbuser'] = 'aegir'
default['scratchpads']['control']['aegir']['dbuserhost'] = '%'
default['scratchpads']['control']['aegir']['dbname'] = 'aegir'

# Aegir database server
default['scratchpads']['control']['dbserver'] = 'localhost'
default['scratchpads']['control']['dbuser'] = 'root'
default['scratchpads']['control']['admin_email'] = 'data@nhm.ac.uk'

# Drush config folder
default['scratchpads']['control']['drush_config_folder'] = '.drush'
default['scratchpads']['control']['drush_command'] = '/usr/bin/drush'

# gkrellmd template
default['scratchpads']['gkrellmd'] = {
  'source' => 'gkrellmd.conf.erb',
  'path' => '/etc/gkrellmd.conf',
  'cookbook' => 'scratchpads',
  'owner' => 'root',
  'group' => 'root',
  'mode' => '0644'
}

# hosts template
default['scratchpads']['hosts'] = {
  'source' => 'hosts.erb',
  'path' => '/etc/hosts',
  'cookbook' => 'scratchpads',
  'owner' => 'root',
  'group' => 'root',
  'mode' => '0644',
  'variables' => {
    'hosts' => {}
  }
}

# resolv.conf template
default['scratchpads']['resolv.conf'] = {
  'source' => 'resolv.conf.erb',
  'path' => '/etc/resolv.conf',
  'cookbook' => 'scratchpads',
  'owner' => 'root',
  'group' => 'root',
  'mode' => '0644',
  'variables' => {}
}
