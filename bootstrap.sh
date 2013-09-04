#!/bin/bash
#
# Usage: bootstrap <destination> <area> <distribution> [box]
#
# <destination> : empty directory or name of a tar.gz file where to
#                 install the base system to
# <area>        : "de", "us", etc to use the official Ubuntu servers,
#                 "hetzner" to use the mirror inside Hetzner datacenters
# <distribution>: distribution name, e.g. "precise", "quantal" or "raring"
# [box]         : "box" to only include a minimum set of packages (for
#                 creating a box template). Otherwise more packages
#                 (like a kernel and a bootloader) will be included
#
set -e

DESTINATION="${1:?missing destination}"
case "${2:?missing download server area}" in
	local) URL="http://localhost:3142/ubuntu" ;;
	hetzner) URL="http://mirror.hetzner.de/ubuntu/packages" ;;
	*) URL="http://${2}.archive.ubuntu.com/ubuntu" ;;
esac
DISTRIBUTION="${3:?missing distribution name}"
case "${4}" in
	box) TYPE="box" ;;
	*) TYPE="host" ;;
esac

# When an archive was given as the destination, install to an temporary directory
case "${DESTINATION}" in
	*.tar.gz) TARGET=`mktemp -d` ;;
	*) TARGET="${DESTINATION}" ;;
esac

# Add install arguments based on wether installing a host or the base box
case "${TYPE}" in
	host)
		ARGS="--components=main,universe"
		# Packages required for booting and running a host
		ARGS="${ARGS} --include grub-pc,linux-server,mdadm,lvm2,openssh-server"
		# Required system and security packages
		ARGS="${ARGS},ufw,apparmor,acpid,ntp,unattended-upgrades,monit,vim"
		# Some useful tools
		ARGS="${ARGS},bash-completion,htop,iptraf,lftp,curl,lsof,pciutils,psmisc,rsync,screen,tcpdump,usbutils,wget"
		;;
	box)
		# We could use --variant=minbase here to make it even smaller, but a box is supposed
		# to provide a shared base for boxes created on top of it
		ARGS="--components=main,universe --include apparmor,vim"
		# Some useful tools
		ARGS="${ARGS},bash-completion,htop,iptraf,lftp,curl,lsof,pciutils,psmisc,rsync,screen,tcpdump,usbutils,wget"
		;;
esac

# Install base system (ubuntu-minimal)
debootstrap --arch amd64 ${ARGS} ${DISTRIBUTION} ${TARGET} ${URL}

# Configure APT sources
cat >${TARGET}/etc/apt/sources.list <<-EOF
	deb ${URL} ${DISTRIBUTION} main restricted universe multiverse
	deb ${URL} ${DISTRIBUTION}-updates main restricted universe multiverse
	deb ${URL} ${DISTRIBUTION}-security main restricted universe multiverse
	deb http://security.ubuntu.com/ubuntu ${DISTRIBUTION}-security main restricted universe multiverse
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
	colorscheme smyck
	set showcmd showmatch
	set nowrap
	set ignorecase smartcase hlsearch
	if has("autocmd")
	  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
	  filetype plugin indent on
	endif
EOF

# When an archive was given as the destination, create it and remove the temporary build directory
case "${DESTINATION}" in
	*.tar.gz)
		tar -C "${TARGET}" -zcf "${DESTINATION}" .
		rm -rf "${TARGET}"
		;;
esac
