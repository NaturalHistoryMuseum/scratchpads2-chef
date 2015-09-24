Overview
========

Servers
-------

The Natural History Museum Scratchpads consist of six different servers. There 
are four distinct roles across the six servers, with two of the roles having 
duplicate servers. The six servers are:

| Hostname     | Role                           | IP Address    |
|--------------|--------------------------------|---------------|
| sp-control-1 | Load balancer and aegir server | 157.140.2.181 |
| sp-app-1     | Application server             | 157.140.2.182 |
| sp-app-2     | Application server             | 157.140.2.183 |
| sp-data-1    | Database and memcache server   | 157.140.2.184 |
| sp-data-2    | Database and memcache server   | 157.140.2.185 |
| sp-search-1  | Apache Solr server             | 157.140.2.186 |

The servers are not associated with the Natural History Museum (NHM) NIS/LDAP 
server and therefore require users to be managed across them. The servers 
should be managed using Chef only, but it may be necessary to access each 
server to aid with debugging and other maintenance tasks.

We also have an additional server (```web-scratchpad-solr```) which runs 
Redmine. This server should be replaced by the application servers above, but 
it will require the installation of Ruby/Ruby-on-rails which is not within the 
skills of the author of this document.

Useful commands
---------------

### sp-control-1.nhm.ac.uk

This server should be the first point of access for the Scratchpads and for 
debugging issues with any site. The aegir user on this machine has access, via 
Drush, to all sites.

```bash
ssh sp-control-1.nhm.ac.uk
sudo su - aegir
drush @site-domain-name.com help
```

#### Create platform
New Scratchpads platforms can be created automatically also as the aegir user:

```bash
ssh sp-control-1.nhm.ac.uk
sudo su - aegir
create-aegir-platform [Scratchpads release, e.g. "2.9.9"]
```

Sites should be upgraded by migrating between platforms. This process should be 
performed via the Aegir user interface, as the user interface will provide full 
feedback on the upgrade/migration process.

#### Drush commands
Specific Drush commands can be run on specific sites:

```bash
ssh sp-control-1.nhm.ac.uk
sudo su - aegir
# Access MySQL CLI for a site
drush @[domain-name] sqlc
# Clear a sites cache
drush @[domain-name] cc all
# Run Cron on a site
drush @[domain-name] cron
# Execute the PHP commands in a file (useful for executing various commands on
# a site)
drush @[domain-name] scr /path/to/php/file.php
```

#### Maintenance mode
The root user can take all sites offline to make maintenance easier and to 
advise users that the sites are being maintained:

```bash
ssh sp-control-1.nhm.ac.uk
sudo su -
varnish-maintenance
```

... and to make the sites live again:

```bash
ssh sp-control-1.nhm.ac.uk
sudo su -
systemctl restart varnish
```

#### Sandbox
The Sandbox site is rebuilt automatically by a cron command which runs every 
six hours (01:00, 07:00, 13:00, 19:00). The site should not be managed through 
the Aegir front end, but instead should be managed using Drush commands. If 
there is a problem with the site, the easiest thing to do is to delete all 
remnants of the current sandbox, and then rebuild it:

```bash
ssh sp-control-1.nhm.ac.uk
sudo su -
find /var/aegir/config | grep "/sandbox.scratchpads.eu" | xargs rm
rm -rf /var/aegir/platforms/scratchpads-master/sites/sandbox.scratchpads.eu
logout
logout
ssh sp-data-2.nhm.ac.uk
sudo su -
mysql
```
```sql
-- Delete sandbox databases
SHOW DATABASES LIKE 'sandboxscratch%';
DROP DATABASE [...];
-- Delete sandbox users
DELETE FROM mysql.user WHERE User LIKE 'sandboxscratchpad%';
FLUSH PRIVILEGES;
```
```bash
ssh sp-control-1.nhm.ac.uk
sudo su - aegir
drush provision-save --context_type='site' --db_server='@server_spdata2nhmacuk'\
 --platform='@platform_scratchpadsmaster' --server='@server_automaticpack'\
 --uri='sandbox.scratchpads.eu'\
 --root='/var/aegir/platforms/scratchpads-master'\
 --profile='scratchpad_2_sandbox' --client_name='admin' sandbox.scratchpads.eu
drush @sandbox.scratchpads.eu provision-install
drush @hm provision-verify @platform_scratchpadsmaster
```

### sp-data-{1|2}.nhm.ac.uk

There shouldn't be any need to access the database servers directly, especially 
given the Aegir/Drush command "sql-cli" which provides access to a sites 
database. If access to the database is still required, the root user has a 
~/.my.cnf that allows easy access to all databases.

```bash
ssh sp-data-{1|2}.nhm.ac.uk
sudo su -
mysql
```
