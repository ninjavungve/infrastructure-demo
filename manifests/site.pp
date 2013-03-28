node default {
	include zargony::base
}

node 'vagrant.local' {
	include zargony::server
}
