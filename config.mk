# Default configuration. Settings here may be overridden or enhanced by
# host-specific configuration in config.<hostname>.mk

# Container run options
btsync_run_opts :=			-v /srv/storage:/var/storage \
							-v /srv/log/btsync:/var/log/btsync \
							-p 8888:8888 -p 14975:14975
elasticsearch_run_opts :=	-v /srv/elasticsearch:/usr/share/elasticsearch/data
gitlab_run_opts :=			--link postgresql:postgresql --link redis:redis \
							-v /srv/gitlab:/var/lib/gitlab \
							-v /srv/web/gitlab:/var/www/gitlab \
							-v /srv/log/gitlab:/var/log/gitlab
mailserver_run_opts :=		-v /srv/mail:/var/mail \
							-v /srv/log/mailserver:/var/log/mail
minecraft_run_opts :=		-p 25565:25565 \
							-v /srv/minecraft:/var/lib/minecraft \
							-v /srv/web/minecraft:/var/www/minecraft
owncloud_run_opts :=		-v /srv/owncloud:/var/lib/owncloud \
							-v /srv/web/owncloud:/var/www/owncloud \
							-v /srv/log/owncloud:/var/log/owncloud
postgresql_run_opts :=		-v /srv/postgresql:/var/lib/postgresql
webserver_run_opts :=		-p 80:80 -p 443:443 \
							-v /srv/web:/var/www \
							-v /srv/log/webserver:/var/log/nginx
