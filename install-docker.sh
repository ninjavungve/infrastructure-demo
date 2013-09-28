#!/bin/bash
set -e

test -x /usr/bin/curl || apt-get install -qy curl

if ! test -e /etc/apt/sources.list.d/docker.list; then
	curl -s http://get.docker.io/gpg |apt-key add -
	echo "deb http://get.docker.io/ubuntu docker main" >/etc/apt/sources.list.d/docker.list
	apt-get update -qq
fi

test -e /lib/modules/`uname -r`/kernel/ubuntu/aufs/aufs.ko || apt-get install -qy linux-image-extra-`uname -r`
test -x /usr/bin/auchk || apt-get install -qy aufs-tools
test -x /usr/bin/docker || apt-get install -qy lxc-docker
