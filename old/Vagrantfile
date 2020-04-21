# -*- mode: ruby -*-
# vi: set ft=ruby :
ENV['VAGRANT_DEFAULT_PROVIDER'] = 'digital_ocean'

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.
  config.vm.synced_folder '.', '/vagrant', disabled: true

  config.vm.provider :digital_ocean do |provider, override|
    provider.name = 'minecraft'
    provider.token = ENV['DIGITAL_OCEAN_TOKEN']
    provider.image = 'docker'
    provider.region = 'nyc3'
    provider.size = '2GB'
    provider.ssh_key_name = 'Desktop' 

    override.vm.hostname = 'minecraft'
    override.vm.box = "digital_ocean"
    override.ssh.private_key_path = 'C:\\Users\\Matt\\.ssh\\id_rsa'
  end

  config.vm.provision 'docker' do |docker|
    docker.run 'mfichman/minecraft', args: [
        "-e PASSWORD_HASH='#{ENV['PASSWORD_HASH']}'",
        "-e S3_ACCESS_KEY='#{ENV['S3_ACCESS_KEY']}'",
        "-e S3_SECRET_KEY='#{ENV['S3_SECRET_KEY']}'",
        "-p 443:443",
        "-p 25565:25565",
    ].join(' ')
  end 

end
