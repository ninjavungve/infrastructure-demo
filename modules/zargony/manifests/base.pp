class zargony::base (
	$ubuntu_area = 'de',
	$ubuntu_distribution = 'precise',
	$ubuntu_components = 'main restricted universe multiverse',
	$timezone = 'Europe/Berlin',
) {
	$path = ['/sbin', '/bin', '/usr/sbin', '/usr/bin']

	# Ensure that the root password is disabled
	user { 'root':
		ensure   => present,
		password => '*',
	}

	# Configure user profile for root, allow ssh access
	zargony::profile { 'root':
		ssh => true,
	}

	# Configure hosts file
	file { '/etc/hosts':
		ensure  => present,
		content => template('zargony/hosts.erb'),
		mode    => 0644, owner => 'root', group => 'root',
	}

	# Configure and update APT
	file { '/etc/apt/sources.list':
		ensure  => present,
		content => template('zargony/sources.list.erb'),
		mode    => 0644, owner => 'root', group => 'root',
		notify  => Exec['aptget_update'],
	}
	exec { 'aptget_update':
		path        => $zargony::base::path,
		command     => 'apt-get -qq update',
		logoutput   => false,
		refreshonly => true,
	}

	# Make sure to update before installing any package
	Package <| |> {
		require +> Exec['aptget_update'],
	}

	# Set timezone
	file { '/etc/localtime':
		ensure => link,
		target => "/usr/share/zoneinfo/${timezone}",
	}

	# Make sure required system services are installed and running
	package { ['acpid', 'apparmor', 'aptitude', 'logrotate', 'ntp', 'openssh-server']:
		ensure => installed,
	}
	file { '/etc/logrotate.conf':
		ensure  => present,
		source  => 'puppet:///modules/zargony/logrotate.conf',
		mode    => 0644, owner => 'root', group => 'root',
		require => Package['logrotate'],
	}
	service { 'acpid':    ensure => running, enable => true, require => Package['acpid'] }
	service { 'apparmor': ensure => running, enable => true, require => Package['apparmor'] }
	service { 'ntp':      ensure => running, enable => true, require => Package['ntp'] }
	service { 'ssh':      ensure => running, enable => true, require => Package['openssh-server'] }

	# Install useful tools
	package { ['bash-completion', 'curl', 'htop', 'iotop', 'iptraf', 'lftp', 'lsof', 'pciutils', 'psmisc', 'rsync', 'screen', 'tcpdump', 'usbutils', 'vim', 'wget']:
		ensure => installed,
	}
}
