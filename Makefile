SUITE :=
MIRROR :=
PROXY :=

#----------------------------------------------------------------------------

IMAGES=$(patsubst %/Dockerfile,%,$(wildcard */Dockerfile))

all: help

help:
	@echo "  base        create a new base image by bootstrapping from scratch"
	@echo "  <name>      build the named image (see <name>/Dockerfile)"

base: bootstrap.tar.gz
	docker import - zargony/$@ <$<

bootstrap.tar.gz:
	$(if $(PROXY), http_proxy=$(PROXY)) ./bootstrap.sh $@ $(SUITE) $(MIRROR)

clean:
	docker ps -a -q |xargs -r docker rm
	docker images |grep "^<none>" |awk '{print $$3}' |xargs -r docker rmi

distclean: clean
	rm -f bootstrap.tar.gz

.PHONY: $(IMAGES) base clean distclean

%: %/Dockerfile
	docker build -t zargony/$@ $(dir $<)
