node default {
	class { 'zargony::base': }
}

# Local testing VM
node 'vagrant.local' {
	class { 'zargony::server': }

	zargony::lvm::group { 'precise64':
		devices => '/dev/sda5',
	}
	zargony::bootstrap::lvm { 'vm':
		lvm_group        => 'precise64',
		target_ipaddress => '10.0.2.99',
		target_gateway   => '10.0.2.2',
	}
}

# Physical server, virtualization host
node 'callisto.dc.zargony.com' {
	class { 'zargony::server': }

	# class { 'zargony::lvm': }
	# zargony::lvm::group { 'vg0':
	# 	devices => '/dev/sda1 /dev/sdb1',
	# }

	# class { 'zargony::vm': }
	# zargony::vm::network { 'default':
	# 	ensure => autostart,
	# 	description => 'Default guest network',
	# 	forward_mode => 'nat',
	# 	bridge => 'virbr0',
	# 	macaddress => '52:54:00:0E:71:D3',
	# 	ipaddress => '192.168.122.1',
	# 	netmask => '24',
	# 	ipaddress6 => '2a01:4f8:150:20a3::4:1',
	# 	netmask6 => '112',
	# }

	# zargony::bootstrap::lvm { 'janus':
	# 	target_domain => 'dc.zargony.com',
	# 	target_ipaddress => '192.168.122.10',
	# 	target_gateway => '192.168.122.1',
	# }
	# zargony::vm::domain { 'janus':
	# 	ensure => autostart,
	# 	description => 'Storage server',
	# 	memory => 2621440,
	# 	cpus => 2,
	# 	root_dev => '/dev/vg0/janus_root',
	# 	swap_dev => '/dev/vg0/janus_swap',
	# 	disk_devs => ['/dev/vg0/janus_games'],
	# 	macaddress => '52:54:00:13:09:56',
	# 	netdevice => 'vnet1',
	# }
}

# Virtualized storage server
node 'gaia.dc.zargony.com' {
	class { 'zargony::server': }

	# TODO: storage stuff
}

# Virtualized web/app server
node 'rhea.dc.zargony.com' {
	class { 'zargony::server': }

	# TODO: web/app server stuff
}

# Virtualized game server
node 'janus.dc.zargony.com' {
	class { 'zargony::server': }

	# TODO: gaming stuff
}
