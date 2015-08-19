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
