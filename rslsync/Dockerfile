FROM debian

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates && \
    rm -rf /var/lib/apt/lists/*

ADD https://download-cdn.resilio.com/stable/linux-glibc-x64/resilio-sync_glibc23_x64.tar.gz /tmp/rslsync.tar.gz
RUN tar -C /usr/local/bin -zxf /tmp/rslsync.tar.gz rslsync && \
    rm -f /tmp/rslsync.tar.gz

RUN addgroup --gid 1000 user && \
    adduser --uid 1000 --gid 1000 user && \
    install -d -o user -g user -m 0755 /data
USER user
WORKDIR /home/user

RUN rslsync --dump-sample-config >/data/rslsync.conf

VOLUME /data

CMD ["/usr/local/bin/rslsync", "--nodaemon", "--config", "/data/rslsync.conf"]
EXPOSE 8888 14975
