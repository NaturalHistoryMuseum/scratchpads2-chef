# Scratchpads Vagrant file.
VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Control VM - Aegir, Varnish
  config.vm.define "control" do |control|
    control.vm.hostname = "sp-control-1.nhm.ac.uk"
    control.vm.box = "scratchpads/debian8"
    control.vm.network "public_network"
    control.vm.network "forwarded_port", guest: 80, host: 8888
    control.vm.provision "chef_client" do |chef|
      chef.chef_server_url = "https://chef.nhm.ac.uk/organizations/nhm"
      chef.validation_key_path = ".chef/user.pem"
      chef.validation_client_name = "simor"
    end
  end
  # App VM - Apache
  config.vm.define "app1" do |app1|
    app1.vm.hostname = "sp-app-1.nhm.ac.uk"
    app1.vm.box = "scratchpads/debian8"
    app1.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--memory", "512"]
    end
    app1.vm.network "public_network"
    app1.vm.provision "chef_client" do |chef|
      chef.chef_server_url = "https://chef.nhm.ac.uk/organizations/nhm"
      chef.validation_key_path = ".chef/user.pem"
      chef.validation_client_name = "simor"
    end
  end
  # Data VM - Percona/MySQL, Memcached
  config.vm.define "data1", autostart: false do |data1|
    data1.vm.hostname = "sp-data-1.nhm.ac.uk"
    data1.vm.box = "scratchpads/debian8"
    data1.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--memory", "512"]
    end
    data1.vm.network "public_network"
    data1.vm.provision "chef_client" do |chef|
      chef.chef_server_url = "https://chef.nhm.ac.uk/organizations/nhm"
      chef.validation_key_path = ".chef/user.pem"
      chef.validation_client_name = "simor"
    end
  end
end
