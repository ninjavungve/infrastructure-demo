FROM zargony/base

ADD http://download-lb.utorrent.com/endpoint/btsync/os/linux-x64/track/stable /tmp/btsync.tar.gz
RUN mkdir /opt/btsync; tar -C /opt/btsync -xf /tmp/btsync.tar.gz; rm -f /tmp/btsync.tar.gz

RUN useradd -d /var/storage -s /bin/false -u 1224 -g 100 btsync

VOLUME ["/var/storage"]

USER btsync
CMD ["/opt/btsync/btsync", "--config", "/var/storage/sync.conf", "--nodaemon"]
EXPOSE 8888 14975
