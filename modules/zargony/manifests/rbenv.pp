class zargony::rbenv (
	$rbenv_root = '/opt/rbenv',
	$ruby_version = '1.9.3-p392',
) {
	$path = [$zargony::base::path, "${rbenv_root}/shims", "${rbenv_root}/bin"]

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

	exec { 'rbenv_rehash':
		path        => $path,
		command     => 'rbenv rehash',
		environment => ["RBENV_ROOT=${rbenv_root}"],
		require     => Exec[$rbenv_root],
		refreshonly => true,
	}

	zargony::rbenv::ruby { $ruby_version: global => true }
}

define zargony::rbenv::ruby (
	$global = false,
) {
	exec { "rbenv_install_${name}":
		path        => $zargony::rbenv::path,
		command     => "rbenv install ${name}",
		environment => "RBENV_ROOT=${zargony::rbenv::rbenv_root}",
		timeout     => 600,
		creates     => "${zargony::rbenv::rbenv_root}/versions/${name}/bin/ruby",
		require     => Exec["${zargony::rbenv::rbenv_root}/plugins/ruby-build"],
		notify      => Exec['rbenv_rehash'],
	}
	file { "${zargony::rbenv::rbenv_root}/versions/${name}/etc":
		ensure  => directory,
		mode    => 0755, owner => 'root', group => 'root',
		require => Exec["rbenv_install_${name}"],
	}
	file { "${zargony::rbenv::rbenv_root}/versions/${name}/etc/gemrc":
		ensure  => present,
		source  => 'puppet:///modules/zargony/gemrc',
		mode    => 0644, owner => 'root', group => 'root',
		require => File["${zargony::rbenv::rbenv_root}/versions/${name}/etc"],
	}

	zargony::rbenv::gem { 'bundler': command => 'bundle' }

	if ($global) {
		file { "${zargony::rbenv::rbenv_root}/version":
			ensure  => present,
			content => "${name}\n",
			mode    => 0644, owner => 'root', group => 'root',
			require => Exec["rbenv_install_${name}"],
			notify  => Exec['rbenv_rehash'],
		}
	}
}

define zargony::rbenv::gem (
	$command,
	$ruby_version = $zargony::rbenv::ruby_version,
) {
	exec { "rbenv_${ruby_version}_gem_install_${name}":
		path        => $zargony::rbenv::path,
		command     => "gem install ${name}",
		environment => ["RBENV_ROOT=${zargony::rbenv::rbenv_root}", "RBENV_VERSION=${ruby_version}"],
		creates     => "${zargony::rbenv::rbenv_root}/versions/${ruby_version}/bin/${command}",
		require     => [Exec["rbenv_install_${ruby_version}"], File["${zargony::rbenv::rbenv_root}/versions/${ruby_version}/etc/gemrc"]],
		notify      => Exec["rbenv_rehash"],
	}
}
