Vagrant.configure("2") do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  config.vm.hostname = "vagrant.local"
  #config.ssh.username = "root"
  #config.ssh.private_key_path = "~/.ssh/id_rsa"
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "manifests"
    puppet.manifest_file  = "site.pp"
    puppet.module_path = "modules"
    puppet.facter = { "vagrant" => true }
    puppet.options = "--verbose"
  end
end
