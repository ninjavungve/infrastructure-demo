Vagrant.configure("2") do |config|
  config.vm.box = "trusty64"
  config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"

  # Increase VM memory to 1G
  config.vm.provider "virtualbox" do |v|
  	v.memory 1024
  end

  # Expose port 4243 so we can use a docker client directly on the host
  config.vm.network :forwarded_port, guest: 4243, host: 4243

  # Install docker
  config.vm.provision :shell, path: "install-docker.sh"
end
