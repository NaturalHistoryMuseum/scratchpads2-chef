# Percona

# Extra SQL files (compressed or not)
default['scratchpads']['percona']['percona-functions-file'] = 'percona-functions.sql'
default['scratchpads']['percona']['secure-installation-file'] = 'secure-installation.sql'
default['scratchpads']['percona']['gm3_data_file'] = 'gm3.sql.gz'

# Additional settings for the my.cnf file.
#
# Note, additional settings can be added easily (or can they - need to check).
default['scratchpads']['percona']['row_format'] = 'COMPRESSED'
default['scratchpads']['percona']['collation'] = 'utf8mb4_unicode_ci'
default['scratchpads']['percona']['charset'] = 'utf8mb4'