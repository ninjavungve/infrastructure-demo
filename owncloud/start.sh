#!/bin/bash
echo "Starting php5-fpm"
/usr/sbin/php5-fpm --daemonize --fpm-config /opt/owncloud/php-fpm.conf
echo "Starting nginx"
rm -f /var/www/owncloud/backend.sock
/usr/sbin/nginx -c /opt/owncloud/nginx.conf
