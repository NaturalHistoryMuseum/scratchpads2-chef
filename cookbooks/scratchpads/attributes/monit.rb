# Varnish
default['scratchpads']['monit']['varnish']['cookbook'] = 'monit-ng'
default['scratchpads']['monit']['varnish']['check_type'] = 'process'
default['scratchpads']['monit']['varnish']['check_id'] = '/var/run/varnishd.pid'
default['scratchpads']['monit']['varnish']['id_type'] = 'pidfile'
default['scratchpads']['monit']['varnish']['start'] = 'systemctl restart varnish'
default['scratchpads']['monit']['varnish']['stop'] = 'systemctl stop varnish'
default['scratchpads']['monit']['varnish']['group'] = 'web'
default['scratchpads']['monit']['varnish']['role'] = node['scratchpads']['control']['role']
default['scratchpads']['monit']['varnish']['tests'] = [
  {
    'condition' => 'cpu > 60% for 20 cycles',
    'action' => 'alert'
  },
  {
    'condition' => 'cpu > 80% for 5 cycles',
    'action' => 'alert'
  },
  {
    'condition' => 'totalmem > 6.0 GB for 5 cycles',
    'action' => 'alert'
  },
  {
    'condition' => 'totalmem > 7.0 GB',
    'action' => 'alert'
  },
  {
    'condition' => 'children > 250',
    'action' => 'alert'
  },
  {
    'condition' => 'loadavg(5min) greater than 10 for 8 cycles',
    'action' => 'alert'
  }
  #,
  # {
  #   'condition' => 'failed host quartz.nhm.ac.uk port 80
  #     send "GET / HTTP/1.1\r\nHost: scratchpads.eu\r\n\r\n"
  #     expect "HTTP/[0-9\.]{3} 200 .*\r\n" 
  #     for 3 cycles',
  #   'action' => 'alert'
  # }
]
# Sandbox
default['scratchpads']['monit']['apache2']['cookbook'] = 'monit-ng'
default['scratchpads']['monit']['apache2']['check_type'] = 'host'
default['scratchpads']['monit']['apache2']['check_id'] = '/var/run/apache2/apache2.pid'
default['scratchpads']['monit']['apache2']['id_type'] = 'pidfile'
default['scratchpads']['monit']['apache2']['start'] = 'systemctl restart apache2'
default['scratchpads']['monit']['apache2']['stop'] = 'systemctl stop apache2'
default['scratchpads']['monit']['apache2']['group'] = 'web'
default['scratchpads']['monit']['varnish']['role'] = node['scratchpads']['control']['role']
default['scratchpads']['monit']['apache2']['tests'] = [
  {
    'condition' => 'failed (url http://sandbox.scratchpads.eu/
    and content != \'Sandbox is rebuilding\')
    for 20 cycles',
    'action' => 'alert'
  }
]
check host Sandbox with address sandbox.scratchpads.eu
   group web
   depends on apache2
# Apache
default['scratchpads']['monit']['apache2']['cookbook'] = 'monit-ng'
default['scratchpads']['monit']['apache2']['check_type'] = 'process'
default['scratchpads']['monit']['apache2']['check_id'] = '/var/run/apache2/apache2.pid'
default['scratchpads']['monit']['apache2']['id_type'] = 'pidfile'
default['scratchpads']['monit']['apache2']['start'] = 'systemctl restart apache2'
default['scratchpads']['monit']['apache2']['stop'] = 'systemctl stop apache2'
default['scratchpads']['monit']['apache2']['group'] = 'web'
default['scratchpads']['monit']['varnish']['role'] = node['scratchpads']['apache']['role']
default['scratchpads']['monit']['apache2']['tests'] = [
  {
    'condition' => 'cpu > 60% for 20 cycles',
    'action' => 'alert'
  },
  {
    'condition' => 'cpu > 80% for 5 cycles',
    'action' => 'alert'
  },
  {
    'condition' => 'totalmem > 9.0 GB for 5 cycles',
    'action' => 'alert'
  },
  {
    'condition' => 'totalmem > 10.0 GB',
    'action' => 'alert'
  },
  {
    'condition' => 'children > 250',
    'action' => 'alert'
  },
  {
    'condition' => 'loadavg(5min) greater than 10 for 8 cycles',
    'action' => 'alert'
  },
  {
    'condition' => 'failed host 127.0.0.1 port 80
      send "GET / HTTP/1.1\r\nHost: 127.0.0.1\r\n\r\n"
      expect "HTTP/[0-9\.]{3} 200 .*\r\n" 
      for 3 cycles',
    'action' => 'alert'
  }
]