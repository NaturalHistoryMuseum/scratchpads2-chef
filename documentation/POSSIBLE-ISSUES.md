Possible issues
===============

Aegir not deleting platform cleanly
-----------------------------------
After deleting the Scratchpads 2.7.3 platform on sp-control-1, following the 
completion of the migration to Scratchpads 2.8.0, the platform Apache 
configuration was not deleted cleanly. This is likely to be an issue with Aegir 
and needs looking into. The next time a platform is deleted, it will be 
necessary to run ```$ apache2ctl configtest``` to ascertain whether or not an 
Aegir configuration file needs deleting.

Sites not migrated due to tar errors
------------------------------------
During the migration from Scratchpads 2.7.3 to Scratchpads 2.8.0 a number of 
sites were not upgraded due to tar errors during the backup process. These tar 
errors were mainly caused by files changing whilst they were being read, 
although some of theme were caused by files not being readable (in particular 
sites/*/private/temp). Simply clicking "Retry" on the migration task would 
re-run the task and usually result in a successful migration. This should be 
reported to the Aegir developers.

Memory usage on data servers
----------------------------
Both sp-data-1 and sp-data-2 use close to (and occasionally more than) their 
memory allocation of 20GB. This appears to be due to MySQL/Percona, although I 
am not sure why as MySQL/Percona is configured to use a maximum of ~6GB.

Tivoli installation
-------------------
I added some code to get Tivoli installed, but it's pretty pointless as the 
process required a lot of interaction with IT and Techtrade (the NHM's backup 
provider). The backup is also specific for a single server (sp-control-1), and 
is not required on any other machine or for the Scratchpads to function.
Logrotate
Systemd init script

Upgrade of Mediawiki
--------------------
The http://help.scratchpads.eu and http://wiki.scratchpads.eu sites are both 
running on an old version of Mediawiki and could do with being upgraded. I 
attempted this during the Chef setup, but unfortunately was unable to resolve 
issues with plugins/extensions installed on the Help wiki. It may be easier to 
create a new wiki and migrate the content from the old wiki.

Chef-client version
-------------------
I have had to pin the chef-client version to 12.4.1 in the Vagrantfile due to 
possible issues with chef-client 12.5. This needs investigating further, as it 
could be an issue if additional application or database servers are provisioned 
for production.
