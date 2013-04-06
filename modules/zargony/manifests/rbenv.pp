class zargony::rbenv (
	$rbenv_root = '/opt/rbenv',
	$ruby_version = '1.9.3-p392',
) {
	$path = [$zargony::base::path, "${rbenv_root}/bin"]

	file { $rbenv_root:
		ensure  => directory,
		mode    => 0755, owner => 'root', group => 'root',
	}
	zargony::git::clone { $rbenv_root:
		url     => 'git://github.com/sstephenson/rbenv.git',
		require => File[$rbenv_root],
	}
	zargony::git::clone { "${rbenv_root}/plugins/ruby-build":
		url     => 'git://github.com/sstephenson/ruby-build.git',
		require => Exec[$rbenv_root],
	}

	file { '/etc/profile.d/rbenv.sh':
		ensure  => present,
		content => template('zargony/rbenv.sh.erb'),
		mode    => 0644, owner => 'root', group => 'root',
		require => Exec[$rbenv_root],
	}

	package { ['build-essential']:
		ensure => installed,
	}

	zargony::rbenv::ruby { $ruby_version: global => true }
}

define zargony::rbenv::ruby (
	$global = false,
) {
	exec { "rbenv install ${name}":
		path        => $zargony::rbenv::path,
		environment => "RBENV_ROOT=${zargony::rbenv::rbenv_root}",
		timeout     => 600,
		creates     => "${zargony::rbenv::rbenv_root}/versions/${name}/bin/ruby",
		require     => Exec["${zargony::rbenv::rbenv_root}/plugins/ruby-build"],
	}

	if ($global) {
		file { "${zargony::rbenv::rbenv_root}/version":
			ensure  => present,
			content => "${name}\n",
			mode    => 0644, owner => 'root', group => 'root',
			require => Exec["rbenv install ${name}"],
		}
	}
}
