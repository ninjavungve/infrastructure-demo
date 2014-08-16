# Start with an empty filesystem
FROM scratch

# Add the base system (result of a bootstrap.sh run)
ADD bootstrap.tar.gz /

# Always use the noninteractive frontend
ENV DEBIAN_FRONTEND noninteractive

# Stub initctl since it won't work inside a container (see also https://github.com/dotcloud/docker/issues/1024)
RUN dpkg-divert --local --rename --add /sbin/initctl; ln -s ../bin/true /sbin/initctl

# Run apt update and upgrade all packages
RUN apt-get -qq update
RUN apt-get -qqy upgrade

# Run a command to test that this image is able to execute commands
RUN echo Base system created
