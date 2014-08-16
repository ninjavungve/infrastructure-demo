SUITE :=
MIRROR :=
PROXY :=

-include config.mk
-include config.$(shell hostname -s).mk

#----------------------------------------------------------------------------

IMAGES := $(patsubst %/Dockerfile,%,$(wildcard */Dockerfile))
CONTAINERS := $(filter-out base,$(IMAGES))

help:
	@echo ""
	@echo "  Configuration:   suite: $(if $(SUITE),$(SUITE),default), mirror: $(if $(MIRROR),$(MIRROR),none), proxy: $(if $(PROXY),$(PROXY),none)"
	@echo ""
	@echo "  base-image       create a new base image by bootstrapping from scratch"
	@echo "  <name>           build and start the named container"
	@echo "  <name>-image     build the image for the named container (see <name>/Dockerfile)"
	@echo "  <name>-start     start a fresh instance of the named container"
	@echo "  <name>-shell     run an interactive shell in a fresh instance of the named image"
	@echo "  all              build and start all containers"
	@echo "  shell            run an interactive shell in a fresh instance of the base image"
	@echo ""
	@echo "  Container names: $(CONTAINERS)"
	@echo ""

#----------------------------------------------------------------------------

$(patsubst %,%-image,$(IMAGES)): %-image: %/Dockerfile
	docker build -t zargony/$* $(dir $<)

base-image: base/bootstrap.tar.gz

base/bootstrap.tar.gz:
	$(if $(PROXY),http_proxy=$(PROXY)) ./bootstrap.sh $@ $(SUITE) $(MIRROR)

.PHONY: $(patsubst %,%-image,$(IMAGES))

#----------------------------------------------------------------------------

$(CONTAINERS): %: %-image %-start

$(patsubst %,%-start,$(CONTAINERS)): %-start:
	-docker stop $* 2>/dev/null
	-docker rm $* 2>/dev/null
	docker run --name=$* -d $($*_run_opts) zargony/$*

$(patsubst %,%-shell,$(CONTAINERS)): %-shell:
	docker run -i -t $($*_run_opts) zargony/$* /bin/bash

.PHONY: $(CONTAINERS) $(patsubst %,%-start,$(CONTAINERS)) $(patsubst %,%-shell,$(CONTAINERS))

#----------------------------------------------------------------------------

all: $(CONTAINERS)

shell:
	docker run -i -t zargony/base /bin/bash

rm:
	docker ps -a |grep -E "Exited .* ago" |awk '{print $$1}' |xargs -r docker rm

rmi:
	docker images |grep "^<none>" |awk '{print $$3}' |xargs -r docker rmi

clean: rm rmi

distclean: clean
	rm -f base/bootstrap.tar.gz

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
