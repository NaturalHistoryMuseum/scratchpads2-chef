# PhantomJS source
default['scratchpads']['phantomjs']['download']['source'] = 'https://phantomjs.googlecode.com/files/phantomjs-1.9.2-linux-x86_64.tar.bz2'
default['scratchpads']['phantomjs']['download']['destination'] = '/var/chef/phantomjs.tar.bz2'
default['scratchpads']['phantomjs']['download']['owner'] = 'root'
default['scratchpads']['phantomjs']['download']['group'] = 'root'
default['scratchpads']['phantomjs']['download']['mode'] = '0600'
default['scratchpads']['phantomjs']['download']['action'] = :create