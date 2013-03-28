node default {
	class { 'zargony::base': }
}

node 'vagrant.local' {
	class { 'zargony::server': }
}
