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
