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
