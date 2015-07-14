# Scratchpads Vagrant file.
VAGRANTFILE_API_VERSION = "2"
# Note, if changing this number, the IP addresses assigned in /etc/hosts
# will need changing too.
NUMBER_OF_DATA_AND_APP_SERVERS = 2
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Control VM - Aegir, Varnish
  ip_address_end = 2
  config.vm.define "control" do |v|
    v.vm.hostname = "sp-control-1.nhm.ac.uk"
    v.vm.box = "scratchpads/debian8"
    v.vm.network "private_network", ip: "192.168.0.#{ip_address_end}"
    v.vm.network "forwarded_port", guest: 80, host: 8080
    ip_address_end = ip_address_end + 1
    v.vm.provision "chef_client" do |chef|
      chef.chef_server_url = "https://chef.nhm.ac.uk/organizations/nhm"
      chef.validation_key_path = ".chef/simor.pem"
      chef.validation_client_name = "simor"
      chef.add_role "scratchpads-role-control"
      chef.environment = "development"
    end
    config.vm.provider "virtualbox" do |vb|
      vb.memory = 4096
      vb.cpus = 1
    end
  end
  (1..NUMBER_OF_DATA_AND_APP_SERVERS).each do |i|
    config.vm.define "app#{i}" do |v|
      v.vm.hostname = "sp-app-#{i}.nhm.ac.uk"
      v.vm.box = "scratchpads/debian8"
      v.vm.network "private_network", ip: "192.168.0.#{ip_address_end}"
      ip_address_end = ip_address_end + 1
      v.vm.provision "chef_client" do |chef|
        chef.chef_server_url = "https://chef.nhm.ac.uk/organizations/nhm"
        chef.validation_key_path = ".chef/simor.pem"
        chef.validation_client_name = "simor"
        chef.add_role "scratchpads-role-app"
        chef.environment = "development"
      end
      config.vm.provider "virtualbox" do |vb|
        vb.memory = 4096
        vb.cpus = 1
      end
    end
    config.vm.define "data#{i}" do |v|
      v.vm.hostname = "sp-data-#{i}.nhm.ac.uk"
      v.vm.box = "scratchpads/debian8"
      v.vm.network "private_network", ip: "192.168.0.#{ip_address_end}"
      ip_address_end = ip_address_end + 1
      v.vm.provision "chef_client" do |chef|
        chef.chef_server_url = "https://chef.nhm.ac.uk/organizations/nhm"
        chef.validation_key_path = ".chef/simor.pem"
        chef.validation_client_name = "simor"
        chef.add_role "scratchpads-role-data"
        chef.environment = "development"
      end
      config.vm.provider "virtualbox" do |vb|
        vb.memory = 4096
        vb.cpus = 1
      end
    end
  end
  config.vm.define "search1" do |v|
    v.vm.hostname = "sp-search-1.nhm.ac.uk"
    v.vm.box = "scratchpads/debian8"
    v.vm.network "private_network", ip: "192.168.0.#{ip_address_end}"
    ip_address_end = ip_address_end + 1
    v.vm.provision "chef_client" do |chef|
      chef.chef_server_url = "https://chef.nhm.ac.uk/organizations/nhm"
      chef.validation_key_path = ".chef/simor.pem"
      chef.validation_client_name = "simor"
      chef.add_role "scratchpads-role-search"
      chef.environment = "development"
    end
    config.vm.provider "virtualbox" do |vb|
      vb.memory = 4096
      vb.cpus = 1
    end
  end
end
