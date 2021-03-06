Vagrant
=======

Before doing anything, you will need to add entries to your hosts file for 
`get.scratchpads.eu` and each of the configured Vagrant VMs. You will also need 
to add entries for any site you will create on the aegir platform. Note, the 
Vagrantfile automatically adds 'dev-' and the hostname of the host machine, so 
replace 'dev-monkey' with dev- and the hostname of your machine.

    192.168.0.2     development.get.scratchpads.eu
    192.168.0.2     dev-monkey-sp-control-1.nhm.ac.uk
    192.168.0.3     dev-monkey-sp-app-1.nhm.ac.uk
    192.168.0.4     dev-monkey-sp-data-1.nhm.ac.uk
    192.168.0.5     dev-monkey-sp-app-2.nhm.ac.uk
    192.168.0.6     dev-monkey-sp-data-2.nhm.ac.uk
    192.168.0.7     dev-monkey-sp-search-1.nhm.ac.uk

The above example assumes you have left NUMBER_OF_DATA_AND_APP_SERVERS set to 
2. If you increase or reduce it, then you will need to adjust the IPs 
accordingly. e.g. if set to 1, then the entries should be:

    192.168.0.2     development.get.scratchpads.eu
    192.168.0.2     dev-monkey-sp-control-1.nhm.ac.uk
    192.168.0.3     dev-monkey-sp-app-1.nhm.ac.uk
    192.168.0.4     dev-monkey-sp-data-1.nhm.ac.uk
    192.168.0.5     dev-monkey-sp-search-1.nhm.ac.uk

And make the corresponding changes to [environments/development.json](../environments/development.json)

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

An easy way of finding the IP address of the server, is to SSH into it 

    vagrant ssh control

and then to execute the hostname command

    hostname -I

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

Preparing nodes
---------------
If using this setup in your production environment, you will need to create the 
nodes prior to bootstrapping them. I would recommend installing Debian using 
the Netinstallation disc, and then:
- Install the following packages:
  - sudo
  - openssh-server
  - ca-certificates
  - lsb-release
- Add the user to the sudo group and configure sudo to not require passwords for the sudo group (ssh keys are recommended instead).
- Copy your ssh keys from your chef workstation (ssh-copy-id).
- Copy the encrypted_data_bag_secret file to /etc/chef/encrypted_data_bag_secret.
- Bootstrap with `knife bootstrap sp-control-1.nhm.ac.uk -x simor -i ~/.ssh/id_rsa --sudo -r 'role[scratchpads-role-control]'`

For those installing NHM nodes, you can use the pre-chef-node-setup.bash script 
included in the Chef repository. The following should work with the NHM:

    wget http://monkey.nhm.ac.uk/pre-chef-node-setup.bash.gpg
    gpg --passphrase <ENTER PASSWORD> pre-chef-node-setup.bash.gpg
    chmod +x pre-chef-node-setup.bash
    ./pre-chef-node-setup.bash [hostname]

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
