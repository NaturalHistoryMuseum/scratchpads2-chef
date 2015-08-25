# Varnish
default['scratchpads']['monit']['conf']['varnish']['cookbook'] = 'monit-ng'
default['scratchpads']['monit']['conf']['varnish']['check_type'] = 'process'
default['scratchpads']['monit']['conf']['varnish']['check_id'] = '/var/run/varnishd.pid'
default['scratchpads']['monit']['conf']['varnish']['id_type'] = 'pidfile'
default['scratchpads']['monit']['conf']['varnish']['start'] = 'systemctl restart varnish'
default['scratchpads']['monit']['conf']['varnish']['stop'] = 'systemctl stop varnish'
default['scratchpads']['monit']['conf']['varnish']['group'] = 'web'
default['scratchpads']['monit']['conf']['varnish']['role'] = node['scratchpads']['control']['role']
default['scratchpads']['monit']['conf']['varnish']['tests'] = [{
    'condition' => 'cpu > 60% for 20 cycles',
    'action' => 'alert'
  },{
    'condition' => 'cpu > 80% for 5 cycles',
    'action' => 'alert'
  },{
    'condition' => 'totalmem > 6.0 GB for 5 cycles',
    'action' => 'alert'
  },{
    'condition' => 'totalmem > 7.0 GB',
    'action' => 'alert'
  },{
    'condition' => 'children > 250',
    'action' => 'alert'
  },{
    'condition' => 'loadavg(5min) greater than 10 for 8 cycles',
    'action' => 'alert'
  }]
  #,
  # {
  #   'condition' => 'failed host quartz.nhm.ac.uk port 80
  #     send "GET / HTTP/1.1\r\nHost: scratchpads.eu\r\n\r\n"
  #     expect "HTTP/[0-9\.]{3} 200 .*\r\n" 
  #     for 3 cycles',
  #   'action' => 'alert'
  # }
# Postfix
default['scratchpads']['monit']['conf']['postfix']['cookbook'] = 'monit-ng'
default['scratchpads']['monit']['conf']['postfix']['check_type'] = 'process'
default['scratchpads']['monit']['conf']['postfix']['check_id'] = '/var/spool/postfix/pid/master.pid'
default['scratchpads']['monit']['conf']['postfix']['id_type'] = 'pidfile'
default['scratchpads']['monit']['conf']['postfix']['start'] = 'systemctl restart postfix'
default['scratchpads']['monit']['conf']['postfix']['stop'] = 'systemctl stop postfix'
default['scratchpads']['monit']['conf']['postfix']['group'] = 'mail'
default['scratchpads']['monit']['conf']['postfix']['role'] = node['scratchpads']['ntp']['role']
default['scratchpads']['monit']['conf']['postfix']['tests'] = [{
    'condition' => 'cpu > 60% for 20 cycles',
    'action' => 'alert'
  },{
    'condition' => 'cpu > 80% for 5 cycles',
    'action' => 'alert'
  },{
    'condition' => 'children > 250',
    'action' => 'alert'
  },{
    'condition' => 'loadavg(5min) greater than 10 for 8 cycles',
    'action' => 'alert'
  },{
    'condition' => 'failed host quartz.nhm.ac.uk port 25 protocol smtp for 3 cycles',
    'action' => 'alert'
  }]
# Sandbox
default['scratchpads']['monit']['conf']['apache2']['cookbook'] = 'monit-ng'
default['scratchpads']['monit']['conf']['apache2']['check_type'] = 'host'
default['scratchpads']['monit']['conf']['apache2']['check_id'] = '/var/run/apache2/apache2.pid'
default['scratchpads']['monit']['conf']['apache2']['id_type'] = 'pidfile'
default['scratchpads']['monit']['conf']['apache2']['start'] = 'systemctl restart apache2'
default['scratchpads']['monit']['conf']['apache2']['stop'] = 'systemctl stop apache2'
default['scratchpads']['monit']['conf']['apache2']['group'] = 'web'
default['scratchpads']['monit']['conf']['varnish']['role'] = node['scratchpads']['control']['role']
default['scratchpads']['monit']['conf']['apache2']['tests'] = [{
    'condition' => 'failed (url http://sandbox.scratchpads.eu/
    and content != \'Sandbox is rebuilding\')
    for 20 cycles',
    'action' => 'alert'}]
# Apache
default['scratchpads']['monit']['conf']['apache2']['cookbook'] = 'monit-ng'
default['scratchpads']['monit']['conf']['apache2']['check_type'] = 'process'
default['scratchpads']['monit']['conf']['apache2']['check_id'] = '/var/run/apache2/apache2.pid'
default['scratchpads']['monit']['conf']['apache2']['id_type'] = 'pidfile'
default['scratchpads']['monit']['conf']['apache2']['start'] = 'systemctl restart apache2'
default['scratchpads']['monit']['conf']['apache2']['stop'] = 'systemctl stop apache2'
default['scratchpads']['monit']['conf']['apache2']['group'] = 'web'
default['scratchpads']['monit']['conf']['varnish']['role'] = node['scratchpads']['apache']['role']
default['scratchpads']['monit']['conf']['apache2']['tests'] = [{
    'condition' => 'cpu > 60% for 20 cycles',
    'action' => 'alert'
  },{
    'condition' => 'cpu > 80% for 5 cycles',
    'action' => 'alert'
  },{
    'condition' => 'totalmem > 9.0 GB for 5 cycles',
    'action' => 'alert'
  },{
    'condition' => 'totalmem > 10.0 GB',
    'action' => 'alert'
  },{
    'condition' => 'children > 250',
    'action' => 'alert'
  },{
    'condition' => 'loadavg(5min) greater than 10 for 8 cycles',
    'action' => 'alert'
  },{
    'condition' => 'failed host 127.0.0.1 port 80
      send "GET / HTTP/1.1\r\nHost: 127.0.0.1\r\n\r\n"
      expect "HTTP/[0-9\.]{3} 200 .*\r\n" 
      for 3 cycles',
    'action' => 'alert'
  }]