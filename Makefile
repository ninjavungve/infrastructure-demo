SUITE := raring
MIRROR := local

#----------------------------------------------------------------------------

all: help

help:
	@echo base     -- create a new base image by bootstrapping from scratch
	@echo <name>   -- build image for the named box (see <name>/Dockerfile)

base: bootstrap.tar.gz
	docker import - zargony/$@ <$<

bootstrap.tar.gz:
	./bootstrap.sh $@ $(SUITE) $(MIRROR)

clean:
	docker rm `docker ps -a -q`

distclean: clean
	rm -f bootstrap.tar.gz

%: %/Dockerfile
	docker build -t zargony/$@ $(dir $<)
