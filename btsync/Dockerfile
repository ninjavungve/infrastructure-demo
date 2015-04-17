FROM zargony/base

ADD https://download-cdn.getsyncapp.com/stable/linux-x64/BitTorrent-Sync_x64.tar.gz /tmp/btsync.tar.gz
RUN install -o root -g root -m 755 -d /opt/btsync
RUN tar -C /opt/btsync -xf /tmp/btsync.tar.gz
ADD sync.conf /opt/btsync/

RUN useradd -d /var/storage -s /usr/sbin/nologin -u 1224 -g 100 btsync

VOLUME ["/var/storage"]

USER btsync
CMD ["/opt/btsync/btsync", "--config", "/opt/btsync/sync.conf", "--log", "/var/log/btsync/btsync.log", "--nodaemon"]
EXPOSE 8888 14975
