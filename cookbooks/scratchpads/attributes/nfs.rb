# List of hosts to always allow to mount
default['scratchpads']['nfs']['default_hosts'] = []
# NFS
default['scratchpads']['nfs']['exports'] = ['/var/www', '/var/aegir/platforms', '/var/aegir/backups', '/var/aegir/backups-databases']