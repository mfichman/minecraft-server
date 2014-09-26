# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.provider :digital_ocean do |provider, override|
    override.vm.box = 'digital_ocean'
    override.vm.box_url = 'https://github.com/smdahlen/vagrant-digitalocean/raw/master/box/digital_ocean.box'
    override.ssh.private_key_path = 'C:\Users\Matt\.ssh\id_rsa'

    provider.token = ENV['DIGITAL_OCEAN_TOKEN']
    provider.image = 'Debian 7.0 x64'
    provider.region = 'nyc2'
    provider.size = '2gb'
  end

  config.vm.provider :virtualbox do |provider, override|
    override.vm.box = 'chef/debian-7.4'
    override.vm.network 'public_network'
    #provider.gui = true
    provider.memory = 2048
    provider.cpus = 2
  end

  $script = `automaton`

  config.vm.provision :shell, inline: $script
end
