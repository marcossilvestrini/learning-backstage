# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
  config.vm.box = "silvestrini-ol9"
  config.vm.box_download_insecure = true
  config.vbguest.auto_update = false
  config.vbguest.no_install = true
  config.vbguest.no_remote = true
  config.vm.network "public_network", nic_type: "virtio", ip: "192.168.0.150", netmask: "255.255.255.0", mode: "bridge", bridge: [
                                        "Intel(R) I211 Gigabit Network Connection",
                                        "MediaTek Wi-Fi 6 MT7921 Wireless LAN",
                                      ]
  config.vm.provider "virtualbox" do |vb|
    vb.linked_clone = true
    vb.name = "backstage"
    vb.memory = 4096
    vb.cpus = 3
  end
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.synced_folder "configs/", "/home/vagrant/configs"
  config.vm.synced_folder "scripts", "/home/vagrant/scripts"
  config.vm.synced_folder "security", "/home/vagrant/security"
  config.vm.synced_folder "backstage", "/home/vagrant/backstage"
  config.vm.synced_folder "ansible", "/home/vagrant/ansible"

  #Configure o provisionamento com Ansible
  config.vm.provision "ansible_local" do |ansible|
    ansible.install_mode = "pip3"
    ansible.compatibility_mode = "2.0"
    ansible.limit = "all"
    ansible.provisioning_path = "/home/vagrant/ansible"
    ansible.inventory_path = "hosts"
    ansible.playbook = "playbook.yaml"
  end

  # Copy private key to connect ssh
  script_path = File.expand_path("../scripts/copy-key.ps1", __FILE__)
  is_up_or_provisioning = ARGV.any? { |arg| arg == "up" || arg == "provision" }
  if Vagrant::Util::Platform.windows? && is_up_or_provisioning
    `powershell -ExecutionPolicy Bypass -File #{script_path}`
  end
end
