class zargony::git {
	package { 'git':
		ensure => installed,
	}
}

define zargony::git::clone (
	$url,
	$ref = 'master',
) {
	exec { $name:
		path    => $zargony::base::path,
		command => "git clone -b ${ref} ${url} ${name}",
		creates => "${name}/.git",
		require => Package['git'],
	}
}
