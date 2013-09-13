# Start with an empty filesystem
FROM scratch

# Add the base system (result of a bootstrap.sh run)
ADD bootstrap.tar.gz /

# Add the apt proxy configuration
ADD apt-proxy.conf /etc/apt/apt.conf.d/02proxy

# Run a command to test that this image is able to execute commands
RUN echo Base system created
