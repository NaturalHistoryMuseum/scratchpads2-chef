# Scratchpads Vagrant file.
#
# Requirements:
#
# - The vagrant-omnibus plugin is required. This can be installed using the
#   following command:
#   $ vagrant plugin install vagrant-omnibus

VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.omnibus.chef_version = :latest
  # Control VM - Aegir, Varnish
  config.vm.define "control" do |control|
    control.vm.box = "scratchpads/debian8"
    control.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--memory", "2048"]
    end
    control.vm.network "public_network"
    control.vm.network "forwarded_port", guest: 80, host: 8888
    control.vm.provision "chef_solo" do |chef|
      chef.add_recipe "control"
    end
  end
  # App VM - Apache
  config.vm.define "app1", autostart: false do |app1|
    app1.vm.box = "scratchpads/debian8"
    app1.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--memory", "512"]
    end
    app1.vm.network "public_network"
    app1.vm.provision "chef_solo" do |chef|
      chef.add_recipe "learn_chef_apache2"
    end
  end
  # Data VM - Percona/MySQL, Memcached
  config.vm.define "data1", autostart: false do |data1|
    data1.vm.box = "scratchpads/debian8"
    data1.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--memory", "512"]
    end
    data1.vm.network "public_network"
    data1.vm.provision "chef_solo" do |chef|
      chef.add_recipe "learn_chef_apache2"
    end
  end
end
