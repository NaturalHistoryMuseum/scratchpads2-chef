# Varnish
default['scratchpads']['varnish']['first_byte_timeout'] = '600s'
default['scratchpads']['varnish']['between_bytes_timeout'] = '600s'
default['scratchpads']['varnish']['connect_timeout'] = '600s'
default['scratchpads']['varnish']['probe']['url'] = '/'
default['scratchpads']['varnish']['probe']['timeout'] = '2s'
default['scratchpads']['varnish']['probe']['interval'] = '6s'
default['scratchpads']['varnish']['probe']['window'] = 10
default['scratchpads']['varnish']['probe']['threshold'] = 7
default['scratchpads']['varnish']['selenium']['host'] = 'selenium.nhm.ac.uk'
default['scratchpads']['varnish']['selenium']['port'] = 80
default['scratchpads']['varnish']['selenium']['max_connections'] = 50
default['scratchpads']['varnish']['selenium']['domains'] = ['qa.scratchpads.eu']
default['scratchpads']['varnish']['redmine']['host'] = 'web-scratchpad-solr.nhm.ac.uk'
default['scratchpads']['varnish']['redmine']['port'] = 3000
default['scratchpads']['varnish']['redmine']['max_connections'] = 50
default['scratchpads']['varnish']['redmine']['domains'] = ['support.scratchpads.eu']
default['scratchpads']['varnish']['monit']['host'] = '127.0.0.1'
default['scratchpads']['varnish']['monit']['port'] = 8080
default['scratchpads']['varnish']['monit']['max_connections'] = 50
default['scratchpads']['varnish']['monit']['domains'] = ['monit.scratchpads.eu']
default['scratchpads']['varnish']['search']['domains'] = ['search.scratchpads.eu']
default['scratchpads']['varnish']['control']['host'] = '127.0.0.1'
default['scratchpads']['varnish']['control']['port'] = 80
default['scratchpads']['varnish']['control']['max_connections'] = 10
default['scratchpads']['varnish']['control']['domains'] = ['get.scratchpads.eu', node['scratchpads']['control']['fqdn']]
default['scratchpads']['varnish']['sp_app_server_port'] = 80
default['scratchpads']['varnish']['trusted_network'] = '"157.140.0.0"/16'
default['scratchpads']['varnish']['no_cache_domains'] = ['zooemu.nhm.ac.uk','edit.nhm.ac.uk']
default['scratchpads']['varnish']['no_cache_paths'] = ['^/status\.php$','^/modules/statistics/statistics\.php$','^/admin','^/uwho','^/admin/.*$','^/user','^/user/.*$','^/users/.*$','^/info/.*$','^/flag/.*$','^.*/ajax/.*$','^.*/ahah/.*$']
default['scratchpads']['varnish']['trusted_network_only_domain_paterns'] = ['^dev.','^dev-']
default['scratchpads']['varnish']['error_message'] = '<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
   <head>
     <title>"} + beresp.status + " " + beresp.reason + {"</title>
   </head>
   <body>
  <h1 class="title">Page Unavailable</h1>
  <p>The page you requested is temporarily unavailable.</p>
  <p>Error "} + beresp.status + " " + beresp.reason + {"</p>
  <p>"} + beresp.reason + {"</p>
   </body>
</html>'