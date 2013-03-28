class zargony::server (
	$ubuntu_area = undef,
	$ubuntu_distribution = undef,
	$ubuntu_components = undef,
	$timezone = undef,
) {
	class { 'zargony::base':
		ubuntu_area         => $ubuntu_area,
		ubuntu_distribution => $ubuntu_distribution,
		ubuntu_components   => $ubuntu_components,
		timezone            => $timezone,
	}
}
