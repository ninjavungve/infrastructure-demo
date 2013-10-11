SUITE :=
MIRROR :=
PROXY :=

#----------------------------------------------------------------------------

IMAGES=$(filter-out base,$(patsubst %/Dockerfile,%,$(wildcard */Dockerfile)))

help:
	@echo "  base        create a new base image by bootstrapping from scratch"
	@echo "  <name>      build the named image (see <name>/Dockerfile)"
	@echo "  all         build all images (except base)"
	@echo "  shell       run an interactive shell in a fresh container"

shell:
	docker run -i -t zargony/base /bin/bash

all: $(IMAGES)

base: base/bootstrap.tar.gz base/apt-proxy.conf
	docker build -rm -t zargony/$@ $@

base/apt-proxy.conf:
	echo "$(if $(PROXY),Acquire::http { Proxy \"$(PROXY)\"; };)" >$@

base/bootstrap.tar.gz:
	$(if $(PROXY),http_proxy=$(PROXY)) ./bootstrap.sh $@ $(SUITE) $(MIRROR)

$(IMAGES): %: %/Dockerfile
	docker build -rm -t zargony/$@ $(dir $<)

clean:
	docker ps -a |grep -E "Exit [0-9]+" |awk '{print $$1}' |xargs -r docker rm
	docker images |grep "^<none>" |awk '{print $$3}' |xargs -r docker rmi

distclean: clean
	rm -f base/bootstrap.tar.gz base/apt-proxy.conf

.PHONY: all base $(IMAGES) clean distclean

#----------------------------------------------------------------------------

# Files that are not excluded by the main .gitignore but by a .gitignore in
# a subdirectory are considered private files
DIRS_WITH_PRIVATE_FILES=$(patsubst %/.gitignore,%,$(wildcard */.gitignore))
PRIVATE_FILES=$(foreach d,$(DIRS_WITH_PRIVATE_FILES),$(addprefix $(d),$(shell cat $(d)/.gitignore)))

pack:
	tar -cp $(PRIVATE_FILES) |gzip -c9 |openssl aes-256-cbc -a -e -salt >private.dat

unpack:
	cat private.dat |openssl aes-256-cbc -a -d |gzip -dc |tar -xp

.PHONY: pack unpack
