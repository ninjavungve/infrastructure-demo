define zargony::profile (
	$homedir = $name ? { 'root' => '/root', default => "/home/${name}" },
	$ssh = true,
) {
	file { "${homedir}/.inputrc":
		ensure => present,
		source => 'puppet:///modules/zargony/inputrc',
		mode   => 0644, owner => $name, group => $name,
	}
	file { "${homedir}/.bashrc":
		ensure => present,
		source => 'puppet:///modules/zargony/bashrc',
		mode   => 0644, owner => $name, group => $name,
	}
	file { "${homedir}/.vimrc":
		ensure => present,
		source => 'puppet:///modules/zargony/vimrc',
		mode   => 0644, owner => $name, group => $name,
	}

	# Install authorized ssh keys if desired
	if ($ssh) {
		file { "${homedir}/.ssh":
			ensure => directory,
			mode   => 0755, owner => $name, group => $name,
		}
		file { "${homedir}/.ssh/authorized_keys":
			ensure  => present,
			source  => ["puppet:///modules/zargony/authorized_keys_${name}", 'puppet:///modules/zargony/authorized_keys'],
			mode    => 0644, owner => $name, group => $name,
			require => File["${homedir}/.ssh"],
		}
	}
}
