#!/bin/bash
set -e

TARGET="${1}"
SUITE="${2:-raring}"
MIRROR="${3:-http://archive.ubuntu.com/ubuntu}"

# Display usage if arguments are missing
if [ -z "${TARGET}" -o -z "${SUITE}" -o -z "${MIRROR}" ]; then
	exec 1>&2
	echo ""
	echo "Usage: $0 <target-dir> [suite] [mirror-url]"
	echo ""
	echo "  Default Ubuntu archive : http://archive.ubuntu.com/ubuntu"
	echo "  German Ubuntu mirror   : http://de.archive.ubuntu.com/ubuntu"
	echo "  Hetzner Ubuntu mirror  : http://mirror.hetzner.de/ubuntu/packages"
	echo "  Local apt-cacher mirror: http://localhost:3142/ubuntu"
	echo "  Boxed apt-cacher mirror: http://172.17.42.1:3142/ubuntu"
	echo ""
	exit 1
fi

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

# Always install these packages
PACKAGES="apparmor,vim"

# If the target should be bootable, include packages required for booting
# and some useful system and security packages
if [ -n "${BOOTABLE}" ]; then
	PACKAGES="${PACKAGES},grub-pc,linux-server,mdadm,lvm2,openssh-server"
	PACKAGES="${PACKAGES},ufw,acpid,ntp,unattended-upgrades"
fi

# Always install these useful tools
PACKAGES="${PACKAGES},bash-completion,iptraf,lftp,curl,lsof,pciutils"
PACKAGES="${PACKAGES},psmisc,rsync,screen,tcpdump,usbutils,wget"

# Install the base system (ubuntu-minimal)
debootstrap --arch=amd64 --components=main --include=${PACKAGES} ${SUITE} ${TARGET} ${MIRROR}

# Configure APT sources
cat >${TARGET}/etc/apt/sources.list <<-EOF
	deb ${MIRROR} ${SUITE} main restricted universe multiverse
	deb ${MIRROR} ${SUITE}-updates main restricted universe multiverse
	deb ${MIRROR} ${SUITE}-security main restricted universe multiverse
	deb http://security.ubuntu.com/ubuntu ${SUITE}-security main restricted universe multiverse
EOF

# Set timezone to Europe/Berlin
ln -sf /usr/share/zoneinfo/Europe/Berlin ${TARGET}/etc/localtime

# Configure SSH access if installed
if test -x ${TARGET}/usr/sbin/sshd; then
	mkdir -p ${TARGET}/root/.ssh
	cat >${TARGET}/root/.ssh/authorized_keys <<-EOF
		ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAsSt+5Ennalg+GM7+0/37ukXuYR523DEWHTygpuGH1CI3GG0vMKHquG2lUEOKJ2mh4Pt5OBXxNfKxl3mmaPxyUStcMBwS25AQQhyLkFGp2sRFKpZQrEYozJ1galkPwdG4OsdtZXDdeDodsttDjIKchPPOSh0bHoXvIkA+zzWBu9wxZKc4EhQHN2+cI268NT+mZYFCFLcL2Zpr+eBW1OvnQ5MdG9kh4jYBc2kORXR4CzzCEVnkoibLLM7cczV96jugouVGTpDIYValBERWOM2aUFEbyRo3vAlveAfoFrYWFmvOgT2ynq1wHG6AcbsOOeAeCLO8slimmmgExhxtTEOGzQ== zargony@lina
		ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCwFQFH9XgcgJ2l43yr69sAkql39VKOCVSMfv6jH/ml0WyD0FP2GO1mMoW/teCuRbWqWxXr7fF0QhOi60g1e4xE766Rkll9xBmx+ckPuSj3xmKOUpnn/Z/rjFzwAQ452lJtIGySSNUbfxM00usDF0+kc5wMR1ugnR3S3y2loVN38RzVgUVMm7r1qhnttsUi/HeXFTw1j7Gaqbmz5PEyMKXeI9fvml1wAzf14JMvxjHSQBBvwLuvAAGMPbdd136bIpY+Vpvc3+zXyODLoFOuyl5cuAHULg0thrpifmgrtkLdD2TpKJqqio2kMrS7A0L5Hg+OXD3qlYPFaMl9tZb0QgBl zargony@priya
		ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCzz9mVFVI6HLTYxV352Q2/9M6pjaWWHXFDJ3+f7j6LceI596rLL2ITgqhxtfN8S2yHWi/8UsBy0xykwsyS7BRmh76/m0nCG+djrqPidG8uZPasicRZyIz/5LxYsi6i9gw/FGv8oL8MvCqilB/zpAqy0/FQEC9wWysbvbB33+q0eJ4wa2FVGm2KW19WkPOysC4jKrc99FcX2pZld5QhU3f6FocTNH4Baq6opzf65SfV40Rp6mERn3FuVrZivcmGt8K7t6rvidQEPxfnoFuuCxN6ZnXAZIOxbFcjqadjI9XaVFPkrtR/5a5xyyOEGDuzN0crxNI8Wd9gYUcbpgCH+R1l zargony@ios
	EOF
fi

# Configure shell input
cat >${TARGET}/root/.inputrc <<-EOF
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

# Configure shell
cp ${TARGET}/etc/skel/.bashrc ${TARGET}/root/.bashrc
sed -i "s/xterm-color/xterm-color|xterm-265color/" ${TARGET}/root/.bashrc
echo "" >>${TARGET}/root/.bashrc
echo "alias l='ls -la'" >>${TARGET}/root/.bashrc

# Configure VIM
cat >${TARGET}/root/.vimrc <<-EOF
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
