# Encrypted data file path
default['scratchpads']['encrypted_data_secret_file_path'] = '/vagrant/.chef/encrypted_data_bag_secret'

# Passwords bag
default['scratchpads']['encrypted_data_bag'] = 'passwords'

# Registry IP address (currently running locally)
default['scratchpads']['additional_hosts']['gbrds.gbif.org'] = '157.140.126.246'

# FQDN of the control server (this probably shouldn't be set here)
default['scratchpads']['control']['fqdn'] = 'sp-control-1.nhm.ac.uk'

# Role of the control server
default['scratchpads']['control']['role'] = 'control'

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

# Apache settings
default['scratchpads']['apache']['additional_modules'] = ['expires']

# PHP settings
default['scratchpads']['php']['php5enmod_command'] = '/usr/sbin/php5enmod'
default['scratchpads']['php']['pecl_or_pear_modules'] = ['uploadprogress','mailparse','propro','raphf','pecl_http']