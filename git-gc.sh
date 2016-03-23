#!/bin/bash
for dir in /var/lib/docker/volumes/infrastructure_gitlab/_data/repositories/*/*.git; do
	echo "=== Optimizing repository $dir"
	uid=`stat --printf="%u" $dir`
	gid=`stat --printf="%g" $dir`
	sudo -H -u \#$uid -g \#$gid GIT_DIR=$dir git gc
done
