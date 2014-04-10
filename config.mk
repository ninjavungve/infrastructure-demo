# Default configuration. Settings here may be overridden or enhanced by
# host-specific configuration in config.<hostname>.mk

# Ubuntu trusty is the default distribution
SUITE := trusty

# VirtualBox testing machines do have apt-cacher running on the real host
ifeq ($(strip $(shell cat /sys/block/sda/device/model)),VBOX HARDDISK)
	PROXY := http://10.0.2.2:3142/
endif

# Container run options
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
