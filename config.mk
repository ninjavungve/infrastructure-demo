# Default configuration. Settings here may be overridden or enhanced by
# host-specific configuration in config.<hostname>.mk

# Ubuntu trusty is the default distribution
SUITE := trusty

# Container run options
gitlab_run_opts :=		--link redis:redis \
						-v /srv/gitlab:/var/lib/gitlab \
						-v /srv/web/gitlab:/var/www/gitlab \
						-v /srv/log/gitlab:/var/log/gitlab
mailserver_run_opts :=	-v /srv/mail:/var/mail \
						-v /srv/log/mail:/var/log/mail
minecraft_run_opts :=	-p 25565:25565 \
						-v /srv/minecraft:/var/lib/minecraft
owncloud_run_opts :=	-v /srv/owncloud:/var/lib/owncloud \
						-v /srv/web/owncloud:/var/www/owncloud \
						-v /srv/log/owncloud:/var/log/owncloud
redmine_run_opts :=		-v /srv/redmine:/var/lib/redmine \
						-v /srv/web/redmine:/var/www/redmine \
						-v /srv/log/redmine:/var/log/redmine
webserver_run_opts :=	-p 80:80 -p 443:443 \
						-v /srv/web:/var/www \
						-v /srv/log/nginx:/var/log/nginx
