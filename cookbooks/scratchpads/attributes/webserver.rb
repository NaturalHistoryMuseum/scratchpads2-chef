passwords = ScratchpadsEncryptedData.new(node)
# Apache settings
default['scratchpads']['webserver']['apache']['templates']['fqdn'] = {
  'source' => 'empty.erb',
  'cookbook' => 'scratchpads',
  'documentroot' => '/var/www/empty',
  'servername' => node['fqdn'],
  'files' => {
    'cookbook' => 'scratchpads',
    'source' => 'empty.tar.gz'
  }
}
default['scratchpads']['webserver']['apache']['templates']['cc-mirror.scratchpads.eu'] = {
  'source' => 'cc-mirror.scratchpads.eu.erb',
  'cookbook' => 'scratchpads',
  'servername' => 'cc-mirror.scratchpads.eu',
  'documentroot' => '/var/www/cc-mirror.scratchpads.eu',
  'files' => {
    'cookbook' => 'scratchpads',
    'source' => 'cc-mirror.scratchpads.eu.tar.gz'
  }
}
# Note, additional files (cache and sites folders) need to be copied to this directory. These
# are handled outside of chef due to the size of the archive (GBs).
default['scratchpads']['webserver']['apache']['templates']['archived-sites'] = {
  'source' => 'archived-sites.erb',
  'cookbook' => 'scratchpads',
  'serveraliaseses' => ['able.myspecies.info','about.e-monocot.org','blackflies.info','nannotax.org','sasarcs.myspecies.info','scicoll.myspecies.info','gpi.myspecies.info'],
  'documentroot' => '/var/www/archived',
  'files' => {
    'cookbook' => 'scratchpads',
    'source' => 'archived-sites.tar.gz'
  }
}
default['scratchpads']['webserver']['apache']['templates']['redmine'] = {
  'source' => 'redmine-apache.erb',
  'cookbook' => 'scratchpads',
  'serveraliaseses' => ['support.scratchpads.eu'],
  'documentroot' => '/usr/share/redmine/public'
}
default['scratchpads']['webserver']['apache']['templates']['dungbeetle.co.uk'] = {
  'source' => 'dungbeetle.co.uk.erb',
  'cookbook' => 'scratchpads',
  'documentroot' => '/var/www/dungbeetle.co.uk',
  'servername' => 'dungbeetle.co.uk'
  # FILES - Due to the size of the files required, this will be handled outside of Chef.
}
help_scratchpads_eu_db_user = passwords.get_encrypted_data 'help.scratchpads.eu', 'user'
help_scratchpads_eu_db_password = passwords.get_encrypted_data 'help.scratchpads.eu', 'password'
help_scratchpads_eu_secretkey = passwords.get_encrypted_data 'help.scratchpads.eu', 'secretkey'
help_scratchpads_eu_upgradekey = passwords.get_encrypted_data 'help.scratchpads.eu', 'upgradekey'
default['scratchpads']['webserver']['apache']['templates']['help.scratchpads.eu'] = {
  'source' => 'help.scratchpads.eu.erb',
  'cookbook' => 'scratchpads',
  'servername' => 'help.scratchpads.eu',
  'documentroot' => '/var/www/mediawiki',
  'database' => {
    'user' => help_scratchpads_eu_db_user,
    'password' => help_scratchpads_eu_db_password,
    'database' => 'helpscratchpadseu',
    'host' => ''
  },
  'templates' =>  {
    'help.scratchpads.eu.LocalSettings.php' => {
      'source' => 'site.LocalSettings.php.erb',
      'cookbook' => 'scratchpads',
      'path' => '/var/www/mediawiki/help.scratchpads.eu.LocalSettings.php',
      'owner' => 'root',
      'group' => 'root',
      'mode' => '0644',
      'variables' => ({
        'sp_data_servers' => [],
        'sitename' => 'Scratchpads Help',
        'sitenamespace' => 'Scratchpads_Help',
        'servername' => 'help.scratchpads.eu',
        'email' => 'scratchpads@nhm.ac.uk',
        'user' => help_scratchpads_eu_db_user,
        'password' => help_scratchpads_eu_db_password,
        'database' => 'helpscratchpadseu',
        'host' => '',
        'secretkey' => help_scratchpads_eu_secretkey,
        'upgradekey' => help_scratchpads_eu_upgradekey
      })  
    }
  }
}
default['scratchpads']['webserver']['apache']['templates']['xhprof'] = {
  'source' => 'xhprof.erb',
  'cookbook' => 'scratchpads',
  'documentroot' => '/usr/share/php/xhprof_html',
  'servername' => "xhprof.#{node['fqdn']}"
}
default['scratchpads']['webserver']['apache']['templates']['aardvark-redirects'] = {
  'source' => 'apache-redirects.erb',
  'cookbook' => 'scratchpads',
  'documentroot' => '/var/www/empty',
  'servername' => ''
}
default['scratchpads']['webserver']['apache']['templates']['wiki.scratchpads.eu'] = {
  'source' => 'wiki.scratchpads.eu.erb',
  'cookbook' => 'scratchpads',
  'servername' => 'wiki.scratchpads.eu',
  'documentroot' => '/var/www/mediawiki'
}
default['scratchpads']['webserver']['apache']['templates']['backup.scratchpads.eu'] = {
  'source' => 'backup.scratchpads.eu.erb',
  'cookbook' => 'scratchpads',
  'servername' => 'backup.scratchpads.eu',
  'documentroot' => '/var/aegir/backups'
}
default['scratchpads']['webserver']['apache']['templates']['sandbox.scratchpads.eu'] = {
  'source' => 'sandbox.scratchpads.eu.erb',
  'cookbook' => 'scratchpads',
  'servername' => 'sandbox.scratchpads.eu',
  'documentroot' => '/var/www/sandbox.scratchpads.eu',
  'files' => {
    'source' => 'sandbox-files.tar.gz',
    'cookbook' => 'scratchpads'
  }
}
default['scratchpads']['webserver']['apache']['templates']['fencedine.myspecies.info'] = {
  'source' => 'fencedine.myspecies.info.erb',
  'cookbook' => 'scratchpads',
  'servername' => 'fencedine.myspecies.info',
  'documentroot' => '/var/www/fencedine.myspecies.info',
  'git' => 'https://github.com/NaturalHistoryMuseum/fencedine.git',
}
cite_scratchpads_eu_db_user = passwords.get_encrypted_data 'cite.scratchpads.eu', 'user'
cite_scratchpads_eu_db_password = passwords.get_encrypted_data 'cite.scratchpads.eu', 'password'
default['scratchpads']['webserver']['apache']['templates']['cite.scratchpads.eu'] = {
  'source' => 'cite.scratchpads.eu.erb',
  'cookbook' => 'scratchpads',
  'servername' => 'cite.scratchpads.eu',
  'documentroot' => '/var/www/cite.scratchpads.eu',
  'git' => 'https://github.com/NaturalHistoryMuseum/scratchpads-cite.git',
  'templates' => {
    'conf.php' => {
      'source' => 'conf.php.erb',
      'cookbook' => 'scratchpads',
      'path' => '/var/www/cite.scratchpads.eu/conf.php',
      'owner' => node['apache']['user'],
      'group' => node['apache']['group'],
      'mode' => '0755'
    },
  },
  'database' => {
    'user' => cite_scratchpads_eu_db_user,
    'password' => cite_scratchpads_eu_db_password,
    'host' => '',
    'database' => 'citescratchpadseu'
  }
}
apache = ScratchpadsEncryptedData.new(node, 'apache')
git_scratchpads_eu_crt_lines = apache.get_encrypted_data 'certificates', 'certificate'
git_scratchpads_eu_key_lines = apache.get_encrypted_data 'certificates', 'key'
git_scratchpads_eu_chain_lines = apache.get_encrypted_data 'certificates', 'chain'
default['scratchpads']['webserver']['apache']['templates']['git.scratchpads.eu'] = {
  'source' => 'git.scratchpads.eu.erb',
  'cookbook' => 'scratchpads',
  'servername' => 'git.scratchpads.eu',
  'documentroot' => '/var/www/git.scratchpads.eu',
  'templates' => {
    'git.scratchpads.eu.crt' => {
      'source' => 'empty-file.erb',
      'cookbook' => 'scratchpads',
      'path' => '/etc/ssl/certs/git.scratchpads.eu.crt',
      'owner' => 'root',
      'group' => 'root',
      'mode' => '0644',
      'all_servers' => true,
      'variables' => ({
        :lines => git_scratchpads_eu_crt_lines
      })  
    },
    'git.scratchpads.eu.key' => {
      'source' => 'empty-file.erb',
      'cookbook' => 'scratchpads',
      'path' => '/etc/ssl/private/git.scratchpads.eu.key',
      'owner' => 'root',
      'group' => 'root',
      'mode' => '0644',
      'all_servers' => true,
      'variables' => ({
        :lines => git_scratchpads_eu_key_lines
      })  
    },
    'git.scratchpads.eu.ca-bundle' => {
      'source' => 'empty-file.erb',
      'cookbook' => 'scratchpads',
      'path' => '/etc/ssl/certs/git.scratchpads.eu.ca-bundle',
      'owner' => 'root',
      'group' => 'root',
      'mode' => '0644',
      'all_servers' => true,
      'variables' => ({
        :lines => git_scratchpads_eu_chain_lines
      })  
    }
  }
}

# PHP settings
default['scratchpads']['webserver']['php']['php5enmod_command'] = '/usr/sbin/php5enmod'
default['scratchpads']['webserver']['php']['session_save_path'] = '/var/www/php-sessions'

# Pear settings
default['scratchpads']['webserver']['php']['pear']['pear_modules_custom_channels'] = {'drush' => 'pear.drush.org'}
default['scratchpads']['webserver']['php']['pear']['pecl_modules'] = {
  'uploadprogress' => {'preferred_state' => 'stable'},
  'mailparse' => {'preferred_state' => 'stable'},
  'xhprof' => {'preferred_state' => 'beta'}
}

# Redmine settings
redmine_db_user = passwords.get_encrypted_data 'redmine', 'user'
redmine_db_password = passwords.get_encrypted_data 'redmine', 'password'
default['scratchpads']['redmine']['database']['adapter'] = 'mysql2'
default['scratchpads']['redmine']['database']['database'] = 'redmine'
default['scratchpads']['redmine']['database']['host'] = 'sp-data-2.nhm.ac.uk'
default['scratchpads']['redmine']['database']['port'] = 3306
default['scratchpads']['redmine']['database']['username'] = redmine_db_user
default['scratchpads']['redmine']['database']['password'] = redmine_db_password
default['scratchpads']['redmine']['database']['encoding'] = 'utf8mb4'
# Session key
redmine_session_key = passwords.get_encrypted_data 'redmine', 'session'
default['scratchpads']['redmine']['session']['key'] = redmine_session_key
# Redmine database template
default['scratchpads']['redmine']['templates']['database.yml'] = {
  'source' => 'redmine-database.yml.erb',
  'cookbook' => 'scratchpads',
  'path' => '/etc/redmine/default/database.yml',
  'owner' => 'root',
  'group' => 'www-data',
  'mode' => '0640'
}
# Redmine session template
default['scratchpads']['redmine']['templates']['session.yml'] = {
  'source' => 'redmine-session.yml.erb',
  'cookbook' => 'scratchpads',
  'path' => '/etc/redmine/default/session.yml',
  'owner' => 'root',
  'group' => 'www-data',
  'mode' => '0640'
}
# Configuration template
default['scratchpads']['redmine']['templates']['configuration.yml'] = {
  'source' => 'redmine-configuration.yml.erb',
  'cookbook' => 'scratchpads',
  'path' => '/etc/redmine/default/configuration.yml',
  'owner' => 'root',
  'group' => 'www-data',
  'mode' => '0640'
}
default['scratchpads']['redmine']['cookbook_file']['plugins'] = {
  'source' => 'redmine-plugins.tar.gz',
  'cookbook' => 'scratchpads',
  'path' => '/usr/share/redmine/redmine-plugins.tar.gz',
  'owner' => 'root',
  'group' => 'root',
  'mode' => '0644'
}
# Cookbook file
default['scratchpads']['redmine']['cookbook_file']['theme'] = {
  'source' => 'redmine-theme.tar.gz',
  'cookbook' => 'scratchpads',
  'path' => '/usr/share/redmine/public/themes/redmine-theme.tar.gz',
  'owner' => 'root',
  'group' => 'root',
  'mode' => '0644'
}
# Redmine favicon
default['scratchpads']['redmine']['cookbook_file']['favicon'] = {
  'source' => 'redmine-favicon.ico',
  'cookbook' => 'scratchpads',
  'path' => '/usr/share/redmine/public/favicon.ico',
  'owner' => 'root',
  'group' => 'root',
  'mode' => '0644'
}