AREA := de
DISTRIBUTION := raring

all: base

base: bootstrap.tar.gz
	cat $< |docker import - zargony/$@

bootstrap.tar.gz:
	./bootstrap.sh $@ $(AREA) $(DISTRIBUTION) box

clean:
	docker rm `docker ps -a -q`

distclean: clean
	rm -f bootstrap.tar.gz

%: %/Dockerfile
	docker build -t zargony/$@ $(dir $<)
