SUITE :=
MIRROR :=
PROXY :=

btsync_run_opts :=		-lxc-conf="lxc.network.ipv6 = 2a01:4f8:100:546f::4:40/112" \
						-lxc-conf="lxc.network.ipv6.gateway = 2a01:4f8:100:546f::4:1" \
						-p 8888:8888 -p 14975:14975 \
						-v /srv/storage:/var/storage
gitserver_run_opts :=	-lxc-conf="lxc.network.ipv6 = 2a01:4f8:100:546f::4:30/112" \
						-lxc-conf="lxc.network.ipv6.gateway = 2a01:4f8:100:546f::4:1" \
						-v /srv/repositories:/var/git
mailserver_run_opts :=	-lxc-conf="lxc.network.ipv6 = 2a01:4f8:100:546f::4:50/112" \
						-lxc-conf="lxc.network.ipv6.gateway = 2a01:4f8:100:546f::4:1" \
						-v /srv/mail:/var/mail \
						-v /srv/log/mail:/var/log/mail
minecraft_run_opts :=	-lxc-conf="lxc.network.ipv6 = 2a01:4f8:100:546f::4:10/112" \
						-lxc-conf="lxc.network.ipv6.gateway = 2a01:4f8:100:546f::4:1" \
						-p 25565:25565 \
						-v /srv/minecraft:/opt/minecraft
redmine_run_opts :=		-v /srv/redmine:/var/lib/redmine \
						-v /srv/web/redmine:/var/www/redmine \
						-v /srv/log/redmine:/var/log/redmine
webserver_run_opts :=	-lxc-conf="lxc.network.ipv6 = 2a01:4f8:100:546f::4:20/112" \
						-lxc-conf="lxc.network.ipv6.gateway = 2a01:4f8:100:546f::4:1" \
						-p 80:80 -p 443:443 \
						-v /srv/web:/var/www \
						-v /srv/log/nginx:/var/log/nginx

#----------------------------------------------------------------------------

IMAGES := $(patsubst %/Dockerfile,%,$(wildcard */Dockerfile))
CONTAINERS := $(filter-out base,$(IMAGES))

help:
	@echo ""
	@echo "  base-image       create a new base image by bootstrapping from scratch"
	@echo "  <name>           build and start the named container"
	@echo "  <name>-image     build the image for the named container (see <name>/Dockerfile)"
	@echo "  <name>-start     start a fresh instance of the named container"
	@echo "  all              build and start all containers"
	@echo "  shell            run an interactive shell in a fresh container"
	@echo ""
	@echo "  Container names: $(CONTAINERS)"
	@echo ""

#----------------------------------------------------------------------------

$(patsubst %,%-image,$(IMAGES)): %-image: %/Dockerfile
	docker build -rm -t zargony/$* $(dir $<)

base-image: base/bootstrap.tar.gz base/apt-proxy.conf

base/apt-proxy.conf:
	echo "$(if $(PROXY),Acquire::http { Proxy \"$(PROXY)\"; };)" >$@

base/bootstrap.tar.gz:
	$(if $(PROXY),http_proxy=$(PROXY)) ./bootstrap.sh $@ $(SUITE) $(MIRROR)

.PHONY: $(patsubst %,%-image,$(IMAGES))

#----------------------------------------------------------------------------

$(CONTAINERS): %: %-image %-start

$(patsubst %,%-start,$(CONTAINERS)): %-start:
	-docker stop $* && docker rm $*
	docker run -name=$* -d $($*_run_opts) zargony/$*

.PHONY: $(CONTAINERS) $(patsubst %,%-start,$(CONTAINERS))

#----------------------------------------------------------------------------

all: $(CONTAINERS)

shell:
	docker run -i -t zargony/base /bin/bash

rm:
	docker ps -a |grep -E "Exit -?[0-9]+" |awk '{print $$1}' |xargs -r docker rm

rmi:
	docker images |grep "^<none>" |awk '{print $$3}' |xargs -r docker rmi

clean: rmi

distclean: clean
	rm -f base/bootstrap.tar.gz base/apt-proxy.conf

.PHONY: all shell rm rmi clean distclean

#----------------------------------------------------------------------------

# Files that are not excluded by the main .gitignore but by a .gitignore in
# a subdirectory are considered private files
DIRS_WITH_PRIVATE_FILES=$(patsubst %/.gitignore,%,$(wildcard */.gitignore))
PRIVATE_FILES=$(foreach d,$(DIRS_WITH_PRIVATE_FILES),$(addprefix $(d),$(shell cat $(d)/.gitignore)))

pack:
	tar -c $(PRIVATE_FILES) |gzip -c9 |openssl aes-256-cbc -a -e -salt >private.dat

unpack:
	cat private.dat |openssl aes-256-cbc -a -d |gzip -dc |tar -x
	chmod 600 $(PRIVATE_FILES)

.PHONY: pack unpack
