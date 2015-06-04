# Apache settings
default['scratchpads']['webserver']['apache']['additional_modules'] = ['expires']
default['scratchpads']['webserver']['apache']['templates']['cc-mirror.scratchpads.eu'] = {
    'path' => "#{node['apache']['dir']}/sites-available/cc-mirror.scratchpads.eu",
    'source' => 'cc-mirror.scratchpads.eu.erb',
    'cookbook' => 'scratchpads',
    'owner' => 'root',
    'group' => 'root',
    'mode' => '0644',
    'servername' => 'cc-mirror.scratchpads.eu',
    'documentroot' => '/var/www/cc-mirror.scratchpads.eu'
}

# PHP settings
default['scratchpads']['webserver']['php']['php5enmod_command'] = '/usr/sbin/php5enmod'

# Pear settings
default['scratchpads']['webserver']['php']['pear']['pecl_or_pear_modules_custom_channels'] = {'drush' => 'pear.drush.org'}
default['scratchpads']['webserver']['php']['pear']['pecl_or_pear_modules'] = ['uploadprogress','mailparse','propro','raphf','pecl_http']