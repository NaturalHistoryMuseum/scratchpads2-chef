Virtual Machine Setup
=====================

Installation
------------
The current configuration uses Debain 8 for all machines. A basic Debian 8 
setup should be installed without any optional extras. A note of the root 
password should be made, along with an additional user (which can be used by 
Chef). A suitable hostname should be provided for each machine during 
installation (or it can be edited afterwards if using clones of a single VM).

### Install essential packages

```bash
apt-get install sudo lsb-release openssh-server ca-certificates -y &&
```

### Enable login without passwords
```bash
ssh-copy-id hostname
```

### Add user to sudo group
Add the user to the sudo group
```bash
usermod -a -G sudo user
```
Ensure that sudo is passwordless (this is not required and is perhaps a small 
security hole).
```bash
sed "s|^%sudo.*$|%sudo ALL=(ALL:ALL) NOPASSWD:ALL|" /etc/sudoers -i
```

### Copy the encrypted_data_bag_secret file
```
ssh hostname sudo mkdir /etc/chef
scp chef-repo/.chef/encrypted_data_bag_secret hostname:
ssh hostname sudo mv ~user/encrypted_data_bag_secret /etc/chef
```

Adding another application/database server
------------------------------------------

The process of adding another application or database server should be pretty 
seamless. One potential issue though, is the NFS server needs to know about the 
new server before it is setup. This can be done by adding the domain name of 
the new server to the `default['scratchpads']['nfs']['default_hosts']` 
attribute in the `cookbooks/scratchpads/attributes/nfs.rb` file. Once that has 
been done, the chef-client should be run on the control server, which should 
add the new domain name to the /etc/exports file. Once that has been done, the 
new server can be bootstrapped.

```ruby
default['scratchpads']['nfs']['default_hosts'] = []
```
becomes...
```ruby
default['scratchpads']['nfs']['default_hosts'] = ['sp-app-3.nhm.ac.uk']
```

