#!/bin/bash
set -e


if ! test -e /etc/apt/sources.list.d/docker.list; then
	apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
	echo "deb http://get.docker.com/ubuntu docker main" >/etc/apt/sources.list.d/docker.list
	apt-get update -qq
fi

test -e /lib/modules/`uname -r`/kernel/ubuntu/aufs/aufs.ko || apt-get install -qy linux-image-extra-`uname -r`
test -x /usr/bin/auchk || apt-get install -qy aufs-tools
test -x /usr/bin/docker || apt-get install -qy lxc-docker
