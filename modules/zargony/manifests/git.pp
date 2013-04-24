define zargony::git::clone (
	$url,
	$ref = 'master',
) {
	if (!defined(Package['git'])) {
		package { 'git':
			ensure => installed,
		}
	}

	exec { $name:
		path    => $zargony::base::path,
		command => "git clone -b ${ref} ${url} ${name}",
		creates => "${name}/.git",
		require => Package['git'],
	}
}
