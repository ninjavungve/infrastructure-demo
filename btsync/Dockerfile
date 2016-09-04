FROM debian

RUN apt-get update && \
    apt-get install -y ca-certificates --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

ADD https://download-cdn.getsync.com/stable/linux-glibc-x64/BitTorrent-Sync_glibc23_x64.tar.gz /tmp/btsync.tar.gz
RUN tar -C /usr/local/bin -zxf /tmp/btsync.tar.gz btsync && \
    rm -f /tmp/btsync.tar.gz

RUN addgroup --gid 1000 user && \
    adduser --uid 1000 --gid 1000 user && \
    install -d -o user -g user -m 0755 /data
USER user
WORKDIR /home/user

RUN btsync --dump-sample-config >/data/btsync.conf

VOLUME /data

CMD ["/usr/local/bin/btsync", "--nodaemon", "--config", "/data/btsync.conf"]
EXPOSE 8888 14975
