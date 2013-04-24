define zargony::bootstrap (
	$root_dev,
	$swap_dev,
	$ubuntu_arch = 'amd64',
	$ubuntu_area = 'de',
	$ubuntu_distribution = 'precise',
	$ubuntu_kernel = 'linux-server',
	$target_fqdn = $name,
	$target_ipaddress = undef,
	$target_netmask = 24,
	$target_gateway = undef,
	$target_pointopoint = undef,
	$target_ipaddress6 = undef,
	$target_netmask6 = 64,
	$target_gateway6 = undef,
) {
	$ubuntu_components = 'main,restricted'
	$ubuntu_include = "${ubuntu_kernel},mdadm,lvm2,openssh-server"
	$ubuntu_url = $ubuntu_area ? {
		'hetzner' => 'http://mirror.hetzner.de/ubuntu/packages',
		default => "http://${ubuntu_area}.archive.ubuntu.com/ubuntu",
	}

	$root_dir = "/mnt/${name}"

	if (!defined(Package['debootstrap'])) {
		package { 'debootstrap':
			ensure => installed,
		}
	}

	file { $root_dir:
		ensure => directory,
		mode   => 0755, owner => 'root', group => 'root',
	}
	exec { "mount_${root_dir}":
		path    => $zargony::base::path,
		command => "mount ${root_dev} ${root_dir}",
		creates => "${root_dir}/lost+found",
		require => File[$root_dir],
	}
	exec { "debootstrap_${root_dir}":
		path    => $zargony::base::path,
		command => "debootstrap --arch=${ubuntu_arch} --components=${ubuntu_components} --include=${ubuntu_include} ${ubuntu_distribution} ${root_dir} http://${ubuntu_area}.archive.ubuntu.com/ubuntu",
		creates => "${root_dir}/etc/lsb-release",
		require => Exec["mount_${root_dir}"],
	}

	file { "${root_dir}/etc/fstab":
		ensure  => present,
		content => template('zargony/bootstrap_fstab.erb'),
		mode    => 0644, owner => 'root', group => 'root',
		require => Exec["debootstrap_${root_dir}"],
		before  => Exec["unmount_${root_dir}"],
	}
	file { "${root_dir}/etc/hostname":
		ensure  => present,
		content => "${target_fqdn}\n",
		mode    => 0644, owner => 'root', group => 'root',
		require => Exec["debootstrap_${root_dir}"],
		before  => Exec["unmount_${root_dir}"],
	}
	file { "${root_dir}/etc/network/interfaces":
		ensure  => present,
		content => template("zargony/bootstrap_interfaces.erb"),
		mode    => 0644, owner => 'root', group => 'root',
		require => Exec["debootstrap_${root_dir}"],
		before  => Exec["unmount_${root_dir}"],
	}
	file { "${root_dir}/etc/resolv.conf":
		ensure  => present,
		content => template("zargony/bootstrap_resolv.conf.erb"),
		mode    => 0644, owner => 'root', group => 'root',
		require => Exec["debootstrap_${root_dir}"],
		before  => Exec["unmount_${root_dir}"],
	}
	file { "${root_dir}/root/.ssh":
		ensure  => directory,
		mode    => 0755, owner => 'root', group => 'root',
		require => Exec["debootstrap_${root_dir}"],
		before  => Exec["unmount_${root_dir}"],
	}
	file { "${root_dir}/root/.ssh/authorized_keys":
		ensure  => present,
		source  => 'puppet:///modules/zargony/authorized_keys',
		mode    => 0644, owner => 'root', group => 'root',
		require => File["${root_dir}/root/.ssh"],
		before  => Exec["unmount_${root_dir}"],
	}

	# TODO: Configure target to run puppet once on first boot

	exec { "unmount_${root_dir}":
		path    => $zargony::base::path,
		command => "umount ${root_dir}",
		onlyif  => "test -e ${root_dir}/usr",
	}
}
