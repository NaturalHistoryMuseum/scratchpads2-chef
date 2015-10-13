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
