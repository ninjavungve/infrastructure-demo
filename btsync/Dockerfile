FROM zargony/base

ADD http://download.getsyncapp.com/endpoint/btsync/os/linux-x64/track/stable /tmp/btsync.tar.gz
RUN install -o root -g root -m 755 -d /opt/btsync
RUN tar -C /opt/btsync -xf /tmp/btsync.tar.gz

RUN useradd -d /var/storage -s /usr/sbin/nologin -u 1224 -g 100 btsync

VOLUME ["/var/storage"]

USER btsync
CMD ["/opt/btsync/btsync", "--config", "/var/storage/sync.conf", "--log", "/var/log/btsync/btsync.log", "--nodaemon"]
EXPOSE 8888 14975
