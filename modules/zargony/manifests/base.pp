class zargony::base {

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
}
