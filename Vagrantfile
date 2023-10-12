# -*- mode: ruby -*-
# vi: set ft=ruby :

# unless Vagrant.has_plugin?("vagrant-hostsupdater")
#   puts 'Installing vagrant-hostsupdater Plugin...'
#   system('vagrant plugin install vagrant-hostsupdater')
# end

Vagrant.configure("2") do |config|  
  config.vm.box = "silvestrini-ol9"
  config.vm.box_download_insecure=true   
  config.vbguest.auto_update = false
  config.vbguest.no_install  = true  
  config.vbguest.no_remote   = true 
  config.vm.network "public_network",nic_type: "virtio", ip: "192.168.0.150", netmask: "255.255.255.0", mode: "bridge",bridge:[
    "Intel(R) I211 Gigabit Network Connection",
    "MediaTek Wi-Fi 6 MT7921 Wireless LAN"
  ]  
  config.vm.provider "virtualbox" do |vb|
    vb.linked_clone = true
    vb.name ="backstage"
    vb.memory = 4096
    vb.cpus = 3
  end
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.synced_folder "configs/", "/home/vagrant/configs"  
  config.vm.synced_folder "scripts", "/home/vagrant/scripts"
  config.vm.synced_folder "security", "/home/vagrant/security"  
  config.vm.synced_folder "backstage", "/home/vagrant/backstage"      
  config.vm.synced_folder "ansible", "/home/vagrant/ansible"        
  # config.vm.provision "shell", name: "[SCRIPT CLOUD-INIT.SH]", path: "../scripts/cloud-init.sh"
  # config.vm.provision "shell", name: "[SCRIPT NGINX.SH]", path: "../scripts/nginx.sh"
  # config.vm.provision "shell", name: "[SCRIPT POSTGRESQL.SH]", path: "../scripts/postgresql.sh"
  # config.vm.provision "shell", name: "[SCRIPT REDIS.SH]", path: "../scripts/redis.sh"
  # config.vm.provision "shell", name: "[SCRIPT BACKSTAGE.SH]", privileged: false, path: "../scripts/backstage.sh"
  # config.vm.provision "shell", name: "[SCRIPT SYNC-BACKSTAGE.SH]", privileged: false, path: "../scripts/sync-backstage.sh"
  
  # Configure o provisionamento com Ansible
#  config.hostsupdater.aliases = ["backstage"]
  config.vm.provision "ansible_local" do |ansible|    
    ansible.install_mode = "pip3"
    ansible.provisioning_path="/home/vagrant/ansible"
    ansible.playbook = "playbook.yaml"
    ansible.inventory_path = "hosts"

    # Se você precisar passar variáveis para o playbook, descomente e ajuste o seguinte bloco
    #ansible.extra_vars = {
    #  var_name: "var_value"
    #}
  end

end

