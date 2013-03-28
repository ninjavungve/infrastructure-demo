class zargony::base (
	$ubuntu_area = 'de',
	$ubuntu_distribution = 'precise',
	$ubuntu_components = 'main restricted universe multiverse',
) {

	# Ensure that the root password is disabled
	user { 'root':
		ensure   => present,
		password => '*',
	}

	# Install authorized ssh keys
	file { '/root/.ssh':
		ensure => directory,
		mode   => 0644, owner => 'root', group => 'root',
	}
	file { '/root/.ssh/authorized_keys':
		ensure  => present,
		source  => 'puppet:///modules/zargony/authorized_keys',
		mode    => 0644, owner => 'root', group => 'root',
		require => File['/root/.ssh'],
	}

	# Configure and update APT
	file { '/etc/apt/sources.list':
		ensure  => present,
		content => template("zargony/sources.list.erb"),
		mode    => 0644, owner => 'root', group => 'root',
		before  => Exec['aptget_update'],
		notify  => Exec['aptget_update'],
	}
	exec { 'aptget_update':
		command     => '/usr/bin/apt-get -qq update',
		logoutput   => false,
		refreshonly => true,
	}

	# Make sure to update before installing any package
	Package <| |> {
		require +> Exec['aptget_update'],
	}
}
