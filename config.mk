# Container run options

elasticsearch_run_opts :=	-v /srv/elasticsearch:/usr/share/elasticsearch/data

gitlab_run_opts :=			-v /srv/gitlab:/var/lib/gitlab \
							-v /srv/web/gitlab:/var/www/gitlab \
							-v /srv/log/gitlab:/var/log/gitlab \
							--link postgresql:postgresql --link redis:redis

mailserver_run_opts :=		-v /srv/mail:/var/mail \
							-v /srv/log/mailserver:/var/log/mail \
							-p 993:993

minecraft_run_opts :=		-v /srv/minecraft:/var/lib/minecraft \
							-v /srv/web/minecraft:/var/www/minecraft \
							-p 25565:25565

owncloud_run_opts :=		-v /srv/owncloud:/var/lib/owncloud \
							-v /srv/web/owncloud:/var/www/owncloud \
							-v /srv/log/owncloud:/var/log/owncloud \
							--link postgresql:postgresql

postgresql_run_opts :=		-v /srv/postgresql:/var/lib/postgresql/data \
							-p 127.0.0.1:5432:5432

syncthing_run_opts :=		-v /srv/storage/.syncthing:/home/user/.config/syncthing \
							-v /srv/storage:/var/storage \
							-p 127.0.0.1:8384:8384 -p 14975:14975

webserver_run_opts :=		-v /srv/web:/var/www \
							-v /srv/log/webserver:/var/log/nginx \
							-p 80:80 -p 443:443
