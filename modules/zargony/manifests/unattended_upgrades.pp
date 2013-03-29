class zargony::unattended_upgrades (
	$automatic = false,
) {
	package { 'unattended-upgrades':
		ensure => installed,
	}

	file { '/etc/apt/apt.conf.d/20auto-upgrades':
		ensure => $automatic ? { true => present, default => absent },
		source => 'puppet:///modules/zargony/apt_20auto-upgrades',
		mode   => 0644, owner => 'root', group => 'root',
		before => Exec['aptget_update'],
		notify => Exec['aptget_update'],
	}
	file { '/etc/apt/apt.conf.d/50unattended-upgrades':
		ensure => present,
		source => 'puppet:///modules/zargony/apt_50unattended-upgrades',
		mode   => 0644, owner => 'root', group => 'root',
		before => Exec['aptget_update'],
		notify => Exec['aptget_update'],
	}
}
