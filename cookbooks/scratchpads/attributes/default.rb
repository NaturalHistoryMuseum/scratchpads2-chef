# Encrypted data file path
default['scratchpads']['encrypted_data_bag_secret_file'] = '/etc/chef/encrypted_data_bag_secret'

# Passwords bag
default['scratchpads']['encrypted_data_bag'] = 'passwords'

# Registry IP address (currently running locally)
default['scratchpads']['additional_hosts']['gbrds.gbif.org'] = '157.140.126.246'

# FQDN of the control server (this probably shouldn't be set here)
default['scratchpads']['control']['aegir_url'] = 'get.scratchpads.eu'

# Roles 
default['scratchpads']['control']['role'] = 'scratchpads-role-control'
default['scratchpads']['app']['role'] = 'scratchpads-role-app'
default['scratchpads']['data']['role'] = 'scratchpads-role-data'
default['scratchpads']['search']['role'] = 'scratchpads-role-search'
default['scratchpads']['search-slave']['role'] = 'scratchpads-role-search-slave'

# Aegir database user
default['scratchpads']['control']['aegir']['dbuser'] = 'aegir'
default['scratchpads']['control']['aegir']['dbuserhost'] = '%'
#default['scratchpads']['control']['aegir']['host'] = 'sp-control-1'
default['scratchpads']['control']['aegir']['dbname'] = 'aegir'

# Aegir database server
default['scratchpads']['control']['dbserver'] = 'localhost'
default['scratchpads']['control']['dbuser'] = 'root'
default['scratchpads']['control']['admin_email'] = 's.rycroft@nhm.ac.uk'

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

# Deliver all mail template
default['scratchpads']['postfix']['deliver_mail_to_aegir_template'] = {
  'source' => 'canonical-redirect.erb',
  'path' => '/etc/postfix/canonical-redirect',
  'cookbook' => 'scratchpads',
  'owner' => 'root',
  'group' => 'root',
  'mode' => '0644'
}