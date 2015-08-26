# Varnish
default['scratchpads']['monit']['conf']['varnish']['cookbook'] = 'monit-ng'
default['scratchpads']['monit']['conf']['varnish']['check_type'] = 'process'
default['scratchpads']['monit']['conf']['varnish']['check_id'] = '/var/run/varnishd.pid'
default['scratchpads']['monit']['conf']['varnish']['id_type'] = 'pidfile'
default['scratchpads']['monit']['conf']['varnish']['start'] = '/bin/systemctl restart varnish'
default['scratchpads']['monit']['conf']['varnish']['stop'] = '/bin/systemctl stop varnish'
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
default['scratchpads']['monit']['conf']['postfix']['start'] = '/bin/systemctl restart postfix'
default['scratchpads']['monit']['conf']['postfix']['stop'] = '/bin/systemctl stop postfix'
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
    'condition' => "failed host #{node['fqdn']} port 25 protocol smtp for 3 cycles",
    'action' => 'alert'
  }]
# Sandbox
default['scratchpads']['monit']['conf']['sandbox']['cookbook'] = 'monit-ng'
default['scratchpads']['monit']['conf']['sandbox']['check_type'] = 'host'
default['scratchpads']['monit']['conf']['sandbox']['check_id'] = 'sandbox.scratchpads.eu'
default['scratchpads']['monit']['conf']['sandbox']['id_type'] = 'address'
default['scratchpads']['monit']['conf']['sandbox']['group'] = 'web'
default['scratchpads']['monit']['conf']['sandbox']['role'] = node['scratchpads']['control']['role']
default['scratchpads']['monit']['conf']['sandbox']['depends'] = 'apache2'
default['scratchpads']['monit']['conf']['sandbox']['tests'] = [{
    'condition' => 'failed (url http://sandbox.scratchpads.eu/
    and content != \'Sandbox is rebuilding\')
    for 20 cycles',
    'action' => 'alert'}]
# MySQL/Percona
default['scratchpads']['monit']['conf']['mysql']['cookbook'] = 'monit-ng'
default['scratchpads']['monit']['conf']['mysql']['check_type'] = 'process'
default['scratchpads']['monit']['conf']['mysql']['check_id'] = '/var/run/mysqld/mysqld.pid'
default['scratchpads']['monit']['conf']['mysql']['id_type'] = 'pidfile'
default['scratchpads']['monit']['conf']['mysql']['start'] = '/bin/systemctl restart mysql'
default['scratchpads']['monit']['conf']['mysql']['stop'] = '/bin/systemctl stop mysql'
default['scratchpads']['monit']['conf']['mysql']['group'] = 'data'
default['scratchpads']['monit']['conf']['mysql']['role'] = node['scratchpads']['percona']['role']
default['scratchpads']['monit']['conf']['mysql']['tests'] = [{
    'condition' => 'cpu > 60% for 20 cycles',
    'action' => 'alert'
  },{
    'condition' => 'cpu > 80% for 5 cycles',
    'action' => 'alert'
  },{
    'condition' => 'totalmem > 16.0 GB for 5 cycles',
    'action' => 'alert'
  },{
    'condition' => 'children > 250',
    'action' => 'alert'
  },{
    'condition' => 'loadavg(5min) greater than 10 for 8 cycles',
    'action' => 'alert'
  },{
    'condition' => "failed host #{node['fqdn']} port 3306 protocol mysql for 3 cycles",
    'action' => 'alert'
  }]
# Memcached
default['scratchpads']['monit']['conf']['memcached']['cookbook'] = 'monit-ng'
default['scratchpads']['monit']['conf']['memcached']['check_type'] = 'process'
default['scratchpads']['monit']['conf']['memcached']['check_id'] = '/tmp/memcached.pid'
default['scratchpads']['monit']['conf']['memcached']['id_type'] = 'pidfile'
default['scratchpads']['monit']['conf']['memcached']['start'] = '/bin/systemctl restart memcached'
default['scratchpads']['monit']['conf']['memcached']['stop'] = '/bin/systemctl stop memcached'
default['scratchpads']['monit']['conf']['memcached']['group'] = 'data'
default['scratchpads']['monit']['conf']['memcached']['role'] = node['scratchpads']['data']['role']
default['scratchpads']['monit']['conf']['memcached']['tests'] = [{
    'condition' => 'cpu > 60% for 20 cycles',
    'action' => 'alert'
  },{
    'condition' => 'cpu > 80% for 5 cycles',
    'action' => 'alert'
  },{
    'condition' => 'totalmem > 6.0 GB for 5 cycles',
    'action' => 'alert'
  },{
    'condition' => 'children > 250',
    'action' => 'alert'
  },{
    'condition' => 'loadavg(5min) greater than 10 for 8 cycles',
    'action' => 'alert'
  },{
    'condition' => "failed host #{node['fqdn']} port 11211 for 3 cycles",
    'action' => 'alert'
  }]
# Apache
default['scratchpads']['monit']['conf']['apache2']['cookbook'] = 'monit-ng'
default['scratchpads']['monit']['conf']['apache2']['check_type'] = 'process'
default['scratchpads']['monit']['conf']['apache2']['check_id'] = '/var/run/apache2/apache2.pid'
default['scratchpads']['monit']['conf']['apache2']['id_type'] = 'pidfile'
default['scratchpads']['monit']['conf']['apache2']['start'] = '/bin/systemctl restart apache2'
default['scratchpads']['monit']['conf']['apache2']['stop'] = '/bin/systemctl stop apache2'
default['scratchpads']['monit']['conf']['apache2']['group'] = 'web'
default['scratchpads']['monit']['conf']['apache2']['role'] = node['scratchpads']['apache']['role']
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
##### SYSTEMS #####
default['scratchpads']['monit']['conf'][node['fqdn']]['cookbook'] = 'monit-ng' # ~FC047
default['scratchpads']['monit']['conf'][node['fqdn']]['check_type'] = 'system' # ~FC047
default['scratchpads']['monit']['conf'][node['fqdn']]['check_id'] = node['fqdn'] # ~FC047
default['scratchpads']['monit']['conf'][node['fqdn']]['role'] = node['scratchpads']['ntp']['role'] # ~FC047
default['scratchpads']['monit']['conf'][node['fqdn']]['tests'] = [{ # ~FC047
    'condition' => 'loadavg (5min) > 6 for 15 cycles',
    'action' => 'alert'
  },{
    'condition' => 'memory usage > 90% for 15 cycles',
    'action' => 'alert'
  },{
    'condition' => 'swap usage > 25%',
    'action' => 'alert'
  },{
    'condition' => 'cpu usage (user) > 70% for 15 cycles',
    'action' => 'alert'
  },{
    'condition' => 'cpu usage (system) > 30% for 15 cycles',
    'action' => 'alert'
  },{
    'condition' => 'cpu usage (wait) > 20% for 15 cycles',
    'action' => 'alert'
  }]
##### File systems #####
# sp-control-1 /var
default['scratchpads']['monit']['conf']['var-partition']['cookbook'] = 'monit-ng'
default['scratchpads']['monit']['conf']['var-partition']['check_type'] = 'filesystem'
default['scratchpads']['monit']['conf']['var-partition']['check_id'] = '/var'
default['scratchpads']['monit']['conf']['var-partition']['id_type'] = 'path'
default['scratchpads']['monit']['conf']['var-partition']['role'] = node['scratchpads']['control']['role']
default['scratchpads']['monit']['conf']['var-partition']['tests'] = [{
    'condition' => 'space > 800 GB for 10 cycles',
    'action' => 'alert'
  }]
# Servers with 50GB root directories.
default['scratchpads']['monit']['conf']['50gb-root-partition']['cookbook'] = 'monit-ng'
default['scratchpads']['monit']['conf']['50gb-root-partition']['check_type'] = 'filesystem'
default['scratchpads']['monit']['conf']['50gb-root-partition']['check_id'] = '/'
default['scratchpads']['monit']['conf']['50gb-root-partition']['id_type'] = 'path'
default['scratchpads']['monit']['conf']['50gb-root-partition']['role'] = node['scratchpads']['apache']['role']
default['scratchpads']['monit']['conf']['50gb-root-partition']['tests'] = [{
    'condition' => 'space > 30 GB for 10 cycles',
    'action' => 'alert'
  }]
# Servers with 100GB root directories.
default['scratchpads']['monit']['conf']['100gb-root-partition-1']['cookbook'] = 'monit-ng'
default['scratchpads']['monit']['conf']['100gb-root-partition-1']['check_type'] = 'filesystem'
default['scratchpads']['monit']['conf']['100gb-root-partition-1']['check_id'] = '/'
default['scratchpads']['monit']['conf']['100gb-root-partition-1']['id_type'] = 'path'
default['scratchpads']['monit']['conf']['100gb-root-partition-1']['role'] = node['scratchpads']['data']['role']
default['scratchpads']['monit']['conf']['100gb-root-partition-1']['tests'] = [{
    'condition' => 'space > 80 GB for 10 cycles',
    'action' => 'alert'
  }]
# Servers with 100GB root directories.
default['scratchpads']['monit']['conf']['100gb-root-partition-2']['cookbook'] = 'monit-ng'
default['scratchpads']['monit']['conf']['100gb-root-partition-2']['check_type'] = 'filesystem'
default['scratchpads']['monit']['conf']['100gb-root-partition-2']['check_id'] = '/'
default['scratchpads']['monit']['conf']['100gb-root-partition-2']['id_type'] = 'path'
default['scratchpads']['monit']['conf']['100gb-root-partition-2']['role'] = node['scratchpads']['search']['role']
default['scratchpads']['monit']['conf']['100gb-root-partition-2']['tests'] = [{
    'condition' => 'space > 80 GB for 10 cycles',
    'action' => 'alert'
  }]
# Boot partition (all servers)
default['scratchpads']['monit']['conf']['boot-partition']['cookbook'] = 'monit-ng'
default['scratchpads']['monit']['conf']['boot-partition']['check_type'] = 'filesystem'
default['scratchpads']['monit']['conf']['boot-partition']['check_id'] = '/boot'
default['scratchpads']['monit']['conf']['boot-partition']['id_type'] = 'path'
default['scratchpads']['monit']['conf']['boot-partition']['role'] = node['scratchpads']['ntp']['role']
default['scratchpads']['monit']['conf']['boot-partition']['tests'] = [{
    'condition' => 'space > 500 MB for 10 cycles',
    'action' => 'alert'
  }]
