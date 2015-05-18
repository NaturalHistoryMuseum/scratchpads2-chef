# Passwords bag
default["scratchpads"]["encrypted_data_bag"] = "passwords"

# FQDN of the control server (this probably shouldn't be set here)
default["scratchpads"]["control"]["fqdn"] = "sp-control-1.nhm.ac.uk"

# Aegir database user
default["scratchpads"]["control"]["aegir"]["dbuser"] = "aegir"
default["scratchpads"]["control"]["aegir"]["dbuserhost"] = "%"
#default["scratchpads"]["control"]["aegir"]["host"] = "sp-control-1"
default["scratchpads"]["control"]["aegir"]["dbname"] = "aegir"

# Aegir database server
default["scratchpads"]["control"]["dbserver"] = "localhost"
default["scratchpads"]["control"]["dbuser"] = "root"

# Extra SQL files
default["scratchpads"]["percona"]["percona-functions-file"] = "/tmp/percona-functions.sql"
default["scratchpads"]["percona"]["secure-installation-file"] = "/tmp/secure-installation.sql"
