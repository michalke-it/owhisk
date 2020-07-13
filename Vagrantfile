# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"
  config.vm.hostname = "openwhisk"
  config.disksize.size = '50GB'
  config.vm.network "public_network", bridge: "enp5s0f0"
  config.vm.provider "virtualbox" do |v|
    v.name = "openwhisk"
    v.memory = 4096
    v.cpus = 2
    v.gui = false
  end
# default router
#  config.vm.provision "shell",
#    run: "always",
#    inline: "route add default gw 192.168.31.1"

# delete the default NAT route to avoid issues with 'docker pull'
  config.vm.provision "shell",
    run: "always",
    inline: "route del default enp0s3"
#disable all the annoying beeps
  config.vm.provision :shell, inline: "echo 'set bell-style none' >> /etc/inputrc && echo 'set visualbell' >> /home/vagrant/.vimrc"
  config.vm.provision :shell, inline: "sudo apt update && sudo apt install docker.io build-essential --yes"
  config.vm.provision :shell, path: "install.sh"
end
