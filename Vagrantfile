Vagrant.configure("2") do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  # Expose port 4243 so we can use a docker client directly on the host
  config.vm.network :forwarded_port, guest: 4243, host: 4243

  # Install docker
  config.vm.provision :shell, path: "install-docker.sh"
end
