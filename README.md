Scratchpads Chef Repository
===========================
This repository contains all of the scripts and settings required to setup an 
instance of a Scratchpads server network. The network will consist of a load 
balancer, 1 or many application servers, 1 or many database servers, and a 
search server. We intend to use this repository to manage the Scratchpads 
instance at the Natural History Museum, London, and have therefore included 
passwords in encrypted data bags. If maintaining the servers at the museum, 
please contact Simon Rycroft, or Vince Smith for the encryption key.

Vagrant
-------
The repository contains a Vagrant script for testing the Chef setup. Simply 
running

    vagrant up

from within the chef repository should be enough to create four servers 
(control, app1, data1 and search1), which will allow you to test the 
Scratchpads installation. If you would like to test load balancing then you'll 
need to bring up the second application server

    vagrant up app2

and if you'd like to test how multiple data hosts (MySQL and memcache) are 
handled, you'll need to bring up the second data server.

    vagrant up data2

Note, there is currently no replication configured between any of the database 
servers on the data hosts - they effectively act independently of each other.

Chef server
-----------
Most of the code within the Scratchpads cookbook expects you to be using 
chef-server, rather than chef-solo. The code will automatically configure 
services based on the role of the node, and will search for other nodes for 
additional configuration (e.g. the NFS configuration looks for the NFS server 
(control role), and configures the NFS client accordingly). I hope to fix the 
code so that it does not break completely if using chef-solo, but for now, 
please use chef-server (you can use a hosted version at http://manage.chef.io/).

Up and provision
----------------
Note, because of circular dependencies (e.g. the NFS server allows access to 
specific clients, but the clients are created after the server), it is 
necessary to run

    vagrant provision
    vagrant provision

after bringing up each of the boxes (i.e. run "vagrant provision" twice). Once 
that has completed, you should be left with a full Aegir installation which 
will have been automatically configured with each of the database and 
application servers, and will also have a "pack" server configured, which in 
turn will contain a scratchpads-master platform. New Scratchpads can easily be 
created on the scratchpads-master platform.
