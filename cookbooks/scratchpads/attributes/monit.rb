default['scratchpads']['monit']['varnish']['cookbook'] = 'scratchpads'
default['scratchpads']['monit']['varnish']['check_type'] = 'process'
default['scratchpads']['monit']['varnish']['check_id'] = '/var/run/varnishd.pid'
default['scratchpads']['monit']['varnish']['id_type'] = 'pidfile'
default['scratchpads']['monit']['varnish']['start'] = 'systemctl restart varnish'
default['scratchpads']['monit']['varnish']['stop'] = 'systemctl stop varnish'
default['scratchpads']['monit']['varnish']['group'] = 'web'
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
  },
  {
    'condition' => 'failed host quartz.nhm.ac.uk port 80
      send "GET / HTTP/1.1\r\nHost: scratchpads.eu\r\n\r\n"
      expect "HTTP/[0-9\.]{3} 200 .*\r\n" 
      for 3 cycles',
    'action' => 'alert'
  }
]