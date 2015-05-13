VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "scratchpads/debian8-2gb-chef"
  config.vm.network "public_network"
  config.vm.network "forwarded_port", guest: 80, host: 8888

#  # Virtualbox specific configuration
#  config.vm.provider "virtualbox" do |vb|
#    vb.customize ["modifyvm", :id, "--memory", "1024"]
#  end

  config.vm.provision "chef_solo" do |chef|
    chef.add_recipe "learn_chef_apache2"
  end
end
