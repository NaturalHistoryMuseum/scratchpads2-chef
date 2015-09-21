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

New Scratchpads platforms can be created automatically also as the aegir user:

```bash
ssh sp-control-1.nhm.ac.uk
sudo su - aegir
create-aegir-platform [Scratchpads release, e.g. "2.9.9"]
```

The root user can take all sites offline to make maintenance easier and to 
advise users that the sites are being maintained.

```bash
ssh sp-control-1.nhm.ac.uk
sudo su -
varnish-maintenance
```
... and to make the sites live
```
ssh sp-control-1.nhm.ac.uk
sudo su -
systemctl restart varnish
```

