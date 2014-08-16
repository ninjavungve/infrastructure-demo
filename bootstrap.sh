#!/bin/bash
set -e

# Print help text and quit
print_help () {
	exec 1>&2
	echo ""
	echo "Usage: $0 [-b] <target> [suite] [mirror]"
	echo ""
	echo "  Bootstraps a base system to the given target. Target may be"
	echo "  either an empty directory or a name of an archive (.tar.gz)"
	echo "  file. Mirror may be given as a URL or one of the shortcuts"
	echo "  'de', 'hetzner' or 'local'."
	echo ""
	echo "  Useful URLs:"
	echo "    Default Ubuntu archive : http://archive.ubuntu.com/ubuntu"
	echo "    German Ubuntu mirror   : http://de.archive.ubuntu.com/ubuntu"
	echo "    Hetzner Ubuntu mirror  : http://mirror.hetzner.de/ubuntu/packages"
	echo "    Local apt-cacher mirror: http://localhost:3142/ubuntu"
	echo "    Boxed apt-cacher mirror: http://172.17.42.1:3142/ubuntu"
	echo ""
	exit 1
}

# Parse options
while true; do
	case "${1}" in
		-h|--help) print_help;;
		-b|--bootable) BOOTABLE="y"; shift;;
		--) shift; break;;
		-*) echo "Error: Unknown option: $1" >&2; print_help;;
		*) break;;
	esac
done

# Parse arguments
TARGET="${1}"
shift || print_help
SUITE="${1:-trusty}"
shift || true
MIRROR="${1:-http://archive.ubuntu.com/ubuntu}"
shift || true
if [ -n "${1}" ]; then print_help; fi

# Install to a temporary directory if an archive is specified as the target
case "${TARGET}" in
	*.tar.gz|*.tgz)
		ARCHIVE="${TARGET}"
		TARGET=`mktemp -d`
		trap "umount ${TARGET}/proc; umount ${TARGET}/sys; rm -rf ${TARGET}" ERR INT TERM
		;;
esac

# Provide shortcuts for mirror-urls
case "${MIRROR}" in
	de) MIRROR="http://de.archive.ubuntu.com/ubuntu" ;;
	hetzner) MIRROR="http://mirror.hetzner.de/ubuntu/packages" ;;
	local) MIRROR="http://localhost:3142/ubuntu" ;;
esac

# Check if a given proxy address works and use it
check_and_set_proxy () {
	if curl --max-time 5 --proxy "${1}" "${MIRROR}/dists/${SUITE}/Release.gpg" 2>/dev/null >/dev/null; then
		http_proxy="${1}"
	fi
}

# Try to auto-detect proxy on host machine when running inside VirtualBox or Docker
if [ -z "${http_proxy}" ]; then
	if grep -q "VBOX HARDDISK" /sys/block/sda/device/model; then
		check_and_set_proxy "http://10.0.2.2:3142/"
	elif [ -x /.dockerinit ]; then
		check_and_set_proxy "http://172.17.42.1:3142/"
	fi
fi

# Always install these packages
PACKAGES="apparmor,vim"

# If the target should be bootable, include packages required for booting
# and some useful system and security packages
if [ -n "${BOOTABLE}" ]; then
	PACKAGES="${PACKAGES},grub-pc,linux-server,mdadm,lvm2,openssh-server"
	PACKAGES="${PACKAGES},ufw,acpid,ntp,unattended-upgrades"
fi

# Always install these useful tools
PACKAGES="${PACKAGES},bash-completion,ca-certificates,curl,iptraf,lftp,lsof,ltrace"
PACKAGES="${PACKAGES},pciutils,psmisc,rsync,screen,strace,tcpdump,tmux,usbutils,wget"

# Install the base system (ubuntu-minimal)
debootstrap --arch=amd64 --components=main --include=${PACKAGES} ${SUITE} ${TARGET} ${MIRROR}

# Clean up cached stuff
rm -rf ${TARGET}/var/lib/apt/lists/*
rm -rf ${TARGET}/var/cache/apt/archives/*

# Configure APT sources
cat >${TARGET}/etc/apt/sources.list <<-EOF
	deb ${MIRROR} ${SUITE} main restricted universe multiverse
	deb ${MIRROR} ${SUITE}-updates main restricted universe multiverse
	deb ${MIRROR} ${SUITE}-security main restricted universe multiverse
	deb http://security.ubuntu.com/ubuntu ${SUITE}-security main restricted universe multiverse
EOF

# Configure APT proxy if set
if [ -n "${http_proxy}" ]; then
	echo "Configuring APT proxy: ${http_proxy}"
	echo "Acquire::http { Proxy \"${http_proxy}\"; };" >${TARGET}/etc/apt/apt.conf.d/02proxy
fi

# Set timezone to Europe/Berlin
ln -sf ../usr/share/zoneinfo/Europe/Berlin ${TARGET}/etc/localtime

# Configure SSH access if installed
if [ -x ${TARGET}/usr/sbin/sshd ]; then
	mkdir -p ${TARGET}/root/.ssh
	cat >${TARGET}/root/.ssh/authorized_keys <<-EOF
		ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAsSt+5Ennalg+GM7+0/37ukXuYR523DEWHTygpuGH1CI3GG0vMKHquG2lUEOKJ2mh4Pt5OBXxNfKxl3mmaPxyUStcMBwS25AQQhyLkFGp2sRFKpZQrEYozJ1galkPwdG4OsdtZXDdeDodsttDjIKchPPOSh0bHoXvIkA+zzWBu9wxZKc4EhQHN2+cI268NT+mZYFCFLcL2Zpr+eBW1OvnQ5MdG9kh4jYBc2kORXR4CzzCEVnkoibLLM7cczV96jugouVGTpDIYValBERWOM2aUFEbyRo3vAlveAfoFrYWFmvOgT2ynq1wHG6AcbsOOeAeCLO8slimmmgExhxtTEOGzQ== zargony@lina
		ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCwFQFH9XgcgJ2l43yr69sAkql39VKOCVSMfv6jH/ml0WyD0FP2GO1mMoW/teCuRbWqWxXr7fF0QhOi60g1e4xE766Rkll9xBmx+ckPuSj3xmKOUpnn/Z/rjFzwAQ452lJtIGySSNUbfxM00usDF0+kc5wMR1ugnR3S3y2loVN38RzVgUVMm7r1qhnttsUi/HeXFTw1j7Gaqbmz5PEyMKXeI9fvml1wAzf14JMvxjHSQBBvwLuvAAGMPbdd136bIpY+Vpvc3+zXyODLoFOuyl5cuAHULg0thrpifmgrtkLdD2TpKJqqio2kMrS7A0L5Hg+OXD3qlYPFaMl9tZb0QgBl zargony@priya
		ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC7pgiTaTRJT6tloLnQqFeUQrA9GmG6VuaLVdlS0aDzrc84V0dXO3hrcJFTEIK4MCYr0WKTbIKXJt/pzYQqP5Z5mCpxXrGXelH98/oekiVpYnPXdVRyJtKoJ5GIhEQsJRqQG8JdwWsdK3OWpwruNT7e2MIIgdGEtIbvlrDrRm3h+QtWeA/nCMhltyWjfKE2DZ77JMG/6MOMcLB6l+XhUh7ouFaHHaFJv0JBpdLvNVN3eciHn64oA/A+Pesp9JZi23+ocW0tzGGOO0qG/WUycGYRm7DQieWj8BXu6A0muLt0s9WN7n8rbiDcBeynv6ocxTVv5m5IU2Q1wtu1dHIjnpTj zargony@ragna
	EOF
fi

# Configure shell
cat >>${TARGET}/etc/bash.bashrc <<-EOF
	force_color_prompt=yes
	. /etc/skel/.bashrc
	alias l='ls -la'
EOF

# Configure shell input
cp -a ${TARGET}/etc/inputrc ${TARGET}/etc/inputrc.orig
cat >${TARGET}/etc/inputrc <<-EOF
	set input-meta on
	set output-meta on
	set show-all-if-ambiguous on
	set completion-ignore-case on
	"\e[1~": beginning-of-line
	"\e[2~": quoted-insert
	"\e[3~": delete-char
	"\e[4~": end-of-line
	"\e[A": history-search-backward
	"\e[B": history-search-forward
	"\e[1;5C": forward-word
	"\e[1;5D": backward-word
	"\e[5C": forward-word
	"\e[5D": backward-word
	"\e\e[C": forward-word
	"\e\e[D": backward-word
EOF

# Configure VIM
cat >${TARGET}/etc/vim/vimrc.local <<-EOF
	syntax on
	set background=dark
	colorscheme elflord
	set showcmd showmatch
	set nowrap
	set ignorecase smartcase hlsearch
	if has("autocmd")
	  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
	  filetype plugin indent on
	endif
EOF

# Build archive if specified
if [ -n "${ARCHIVE}" ]; then
	tar -C ${TARGET} -zcpf ${ARCHIVE} .
	rm -rf ${TARGET}
fi
