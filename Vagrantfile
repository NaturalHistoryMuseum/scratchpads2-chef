# Scratchpads Vagrant file.
VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Control VM - Aegir, Varnish
  config.vm.define "control" do |v|
    v.vm.hostname = "sp-control-1.nhm.ac.uk"
    v.vm.box = "scratchpads/debian8"
    v.vm.network "public_network"
    v.vm.provision "chef_client" do |chef|
      chef.chef_server_url = "https://chef.nhm.ac.uk/organizations/nhm"
      chef.validation_key_path = ".chef/simor.pem"
      chef.validation_client_name = "simor"
      chef.add_role "scratchpads-role-control"
      chef.environment = "development"
    end
  end
  # App VM - Apache
  config.vm.define "app1" do |v|
    v.vm.hostname = "sp-app-1.nhm.ac.uk"
    v.vm.box = "scratchpads/debian8"
    v.vm.network "public_network"
    v.vm.provision "chef_client" do |chef|
      chef.chef_server_url = "https://chef.nhm.ac.uk/organizations/nhm"
      chef.validation_key_path = ".chef/simor.pem"
      chef.validation_client_name = "simor"
      chef.add_role "scratchpads-role-app"
      chef.environment = "development"
    end
    config.vm.provider "virtualbox" do |vb|
      vb.memory = 512
    end
  end
  config.vm.define "app2", autostart: false do |v|
    v.vm.hostname = "sp-app-2.nhm.ac.uk"
    v.vm.box = "scratchpads/debian8"
    v.vm.network "public_network"
    v.vm.provision "chef_client" do |chef|
      chef.chef_server_url = "https://chef.nhm.ac.uk/organizations/nhm"
      chef.validation_key_path = ".chef/simor.pem"
      chef.validation_client_name = "simor"
      chef.add_role "scratchpads-role-app"
      chef.environment = "development"
    end
    config.vm.provider "virtualbox" do |vb|
      vb.memory = 512
    end
  end
  # Data VM - Percona/MySQL, Memcached
  config.vm.define "data1" do |v|
    v.vm.hostname = "sp-data-1.nhm.ac.uk"
    v.vm.box = "scratchpads/debian8"
    v.vm.network "public_network"
    v.vm.provision "chef_client" do |chef|
      chef.chef_server_url = "https://chef.nhm.ac.uk/organizations/nhm"
      chef.validation_key_path = ".chef/simor.pem"
      chef.validation_client_name = "simor"
      chef.add_role "scratchpads-role-data"
      chef.environment = "development"
    end
    config.vm.provider "virtualbox" do |vb|
      vb.memory = 512
      vb.cpus = 1
    end
  end
  config.vm.define "data2", autostart: false do |v|
    v.vm.hostname = "sp-data-2.nhm.ac.uk"
    v.vm.box = "scratchpads/debian8"
    v.vm.network "public_network"
    v.vm.provision "chef_client" do |chef|
      chef.chef_server_url = "https://chef.nhm.ac.uk/organizations/nhm"
      chef.validation_key_path = ".chef/simor.pem"
      chef.validation_client_name = "simor"
      chef.add_role "scratchpads-role-data"
      chef.environment = "development"
    end
    config.vm.provider "virtualbox" do |vb|
      vb.memory = 512
      vb.cpus = 1
    end
  end
  config.vm.define "search1" do |v|
    v.vm.hostname = "sp-search-1.nhm.ac.uk"
    v.vm.box = "scratchpads/debian8"
    v.vm.network "public_network"
    v.vm.provision "chef_client" do |chef|
      chef.chef_server_url = "https://chef.nhm.ac.uk/organizations/nhm"
      chef.validation_key_path = ".chef/simor.pem"
      chef.validation_client_name = "simor"
      chef.add_role "scratchpads-role-search"
      chef.environment = "development"
    end
    config.vm.provider "virtualbox" do |vb|
      vb.memory = 512
      vb.cpus = 1
    end
  end
end
