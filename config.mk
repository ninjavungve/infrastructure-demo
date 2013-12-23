# Default configuration. Settings here may be overridden or enhanced by
# host-specific configuration in config.<hostname>.mk

# Ubuntu raring is the default distribution
SUITE := raring

# Container run options
btsync_run_opts :=		-p 8888:8888 -p 14975:14975 \
						-v /srv/storage:/var/storage
gitserver_run_opts :=	-v /srv/repositories:/var/git
mailserver_run_opts :=	-v /srv/mail:/var/mail \
						-v /srv/log/mail:/var/log/mail
minecraft_run_opts :=	-p 25565:25565 \
						-v /srv/minecraft:/opt/minecraft
redmine_run_opts :=		-v /srv/redmine:/var/lib/redmine \
						-v /srv/web/redmine:/var/www/redmine \
						-v /srv/log/redmine:/var/log/redmine
webserver_run_opts :=	-p 80:80 -p 443:443 \
						-v /srv/web:/var/www \
						-v /srv/log/nginx:/var/log/nginx
