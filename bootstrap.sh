#!/bin/bash
#
# Usage: bootstrap <destination> <area> [box]
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
	box) TARGET="box" ;;
	*) TARGET="host" ;;
esac

# When an archive was given as the destination, install to an temporary directory
case "${DESTINATION}" in
	*.tar.gz) BUILDDIR=`mktemp -d` ;;
	*) BUILDDIR="${DESTINATION}" ;;
esac

# Add some required and useful packages if installing a host, none if creating the base box
case "${TARGET}" in
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
		ARGS="--components=main,universe --include vim"
		# Some useful tools
		ARGS="${ARGS},bash-completion,htop,iptraf,lftp,curl,lsof,pciutils,psmisc,rsync,screen,tcpdump,usbutils,wget"
		;;
esac

# Install base system (ubuntu-minimal)
debootstrap --arch amd64 ${ARGS} ${DISTRIBUTION} ${BUILDDIR} ${URL}

# Configure APT sources
cat >${BUILDDIR}/etc/apt/sources.list <<EOF
deb ${URL} ${DISTRIBUTION} main restricted universe multiverse
deb ${URL} ${DISTRIBUTION}-updates main restricted universe multiverse
deb http://security.ubuntu.com/ubuntu ${DISTRIBUTION}-security main restricted universe multiverse
EOF

# Set timezone to Europe/Berlin
ln -sf /usr/share/zoneinfo/Europe/Berlin ${BUILDDIR}/etc/localtime

# When an archive was given as the destination, create it and remove the temporary build directory
case "${DESTINATION}" in
	*.tar.gz)
		tar -C "${BUILDDIR}" -zcf "${DESTINATION}" .
		rm -rf "${BUILDDIR}"
		;;
esac
