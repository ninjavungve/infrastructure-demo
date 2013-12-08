#!/bin/bash
echo "Starting sshd"
/usr/sbin/sshd
echo "Starting sidekiq"
sudo -u git -H RAILS_ENV=production /opt/gitlab/bin/background_jobs start
echo "Starting gitlab"
rm -f /var/www/gitlab/backend.sock
exec sudo -u git -H /usr/local/bin/unicorn --env production --config-file /opt/gitlab/config/unicorn.rb
