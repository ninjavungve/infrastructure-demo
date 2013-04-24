class zargony::server (
	$ubuntu_area = undef,
	$ubuntu_distribution = undef,
	$ubuntu_components = undef,
	$timezone = undef,
) {
	class { 'zargony::base':
		ubuntu_area         => $ubuntu_area,
		ubuntu_distribution => $ubuntu_distribution,
		ubuntu_components   => $ubuntu_components,
		timezone            => $timezone,
	}

	# Configure system for unattended upgrades
	package { 'unattended-upgrades':
		ensure => installed,
	}
	file { '/etc/apt/apt.conf.d/20auto-upgrades':
		ensure => present,
		source => 'puppet:///modules/zargony/apt_20auto-upgrades',
		mode   => 0644, owner => 'root', group => 'root',
		notify => Exec['aptget_update'],
	}
	file { '/etc/apt/apt.conf.d/50unattended-upgrades':
		ensure => present,
		source => 'puppet:///modules/zargony/apt_50unattended-upgrades',
		mode   => 0644, owner => 'root', group => 'root',
		notify => Exec['aptget_update'],
	}

	# Set up ruby
	class { 'zargony::rbenv': }
}
