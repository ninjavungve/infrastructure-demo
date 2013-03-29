class zargony::logrotate {
	package { 'logrotate':
		ensure => installed,
	}

	file { '/etc/logrotate.conf':
		ensure => present,
		source => 'puppet:///modules/zargony/logrotate.conf',
		mode   => 0644, owner => 'root', group => 'root',
	}
}
