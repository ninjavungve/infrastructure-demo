#!/bin/bash

test -x /usr/bin/wget || apt-get install -qy wget

if ! test -d /etc/apt/sources.list.d/docker.list; then
	wget -q -O- http://get.docker.io/gpg |apt-key add -
	echo "deb http://get.docker.io/ubuntu docker main" >/etc/apt/sources.list.d/docker.list
	apt-get update -qq
fi

test -x /usr/bin/docker || apt-get install -qy lxc-docker
