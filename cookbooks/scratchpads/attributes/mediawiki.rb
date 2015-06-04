# Mediawiki
default['scratchpads']['mediawiki']['version']['major'] = '1.25'
default['scratchpads']['mediawiki']['version']['minor'] = '1'
default['scratchpads']['mediawiki']['download']['path'] = '/var/chef'
default['scratchpads']['mediawiki']['download']['filename'] = "mediawiki-#{node['scratchpads']['mediawiki']['version']['major']}.#{node['scratchpads']['mediawiki']['version']['minor']}.tar.gz"
default['scratchpads']['mediawiki']['download']['download_url'] = "http://releases.wikimedia.org/mediawiki/#{node['scratchpads']['mediawiki']['version']['major']}/#{node['scratchpads']['mediawiki']['download']['filename']}"
default['scratchpads']['mediawiki']['download']['group'] = 'root'
default['scratchpads']['mediawiki']['download']['owner'] = 'root'
default['scratchpads']['mediawiki']['download']['mode'] = '0644'
default['scratchpads']['mediawiki']['install_location'] = '/var/www/mediawiki'