FROM zargony/base

RUN apt-get -qqy install redis-server

RUN /bin/sed -i "s/^\(daemonize\|bind\)/#\\1/" /etc/redis/redis.conf

USER redis
CMD ["/usr/bin/redis-server", "/etc/redis/redis.conf"]
EXPOSE 6379
