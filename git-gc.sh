#!/bin/bash
for dir in /srv/repositories/*/*.git; do
	echo "=== Optimizing repository $dir"
	uid=`stat --printf="%u" $dir`
	gid=`stat --printf="%g" $dir`
	sudo -H -u \#$uid -g \#$gid GIT_DIR=$dir git gc
done
