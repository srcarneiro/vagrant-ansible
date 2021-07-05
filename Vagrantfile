# -*- mode: ruby -*-
# vi: set ft=ruby :


Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/xenial64"
 
  config.vm.define "ansible" do |ansible|    
	ansible.vm.network "private_network", ip: "10.10.20.32" 
	
	ansible.vm.provider :virtualbox do |vbox|
		vbox.name = "vgt-ansible"
		vbox.memory = "512"
	end	
	
	ansible.vm.provision "shell",path: "manifests/bootstrap.sh"
	ansible.vm.provision "puppet" do |puppet|
		puppet.manifest_file = "ansible.pp"
	end
	
  end  
  
end