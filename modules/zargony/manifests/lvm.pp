class zargony::lvm {
	package { 'lvm2':
		ensure => installed,
	}
}

define zargony::lvm::group (
	$devices,
) {
	exec { "vgcreate_${name}":
		path    => $zargony::base::path,
		command => "vgcreate ${name} ${devices}",
		creates => "/dev/${name}",
		require => Package['lvm2'],
	}
}

define zargony::lvm::volume (
	$size,
	$group = 'vg0',
	$format = undef,
) {
	$device = "/dev/${group}/${name}"
	$mkfs = $format ? { undef => undef, 'swap' => 'mkswap', default => "mkfs.${format}" }

	exec { "lvcreate_${name}":
		path    => $zargony::base::path,
		command => "lvcreate -L ${size} -n ${name} ${group}",
		creates => $device,
		require => [Package['lvm2'], Exec["vgcreate_${group}"]],
		notify  => $mkfs ? { undef => undef, default => Exec["mkfs_${name}"] },
	}

	if ($mkfs) {
		exec { "mkfs_${name}":
			path        => $zargony::base::path,
			command     => "${mkfs} ${device}",
			creates     => $device,
			refreshonly => true,
		}
	}
}
