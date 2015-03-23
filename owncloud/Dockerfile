FROM zargony/base

RUN apt-get -qqy install nginx php5-cli php5-fpm php5-sqlite php5-gd

ADD https://download.owncloud.org/community/owncloud-8.0.2.tar.bz2 /opt/owncloud/
RUN cd /opt/owncloud && tar -jxf owncloud-*.tar.bz2 && mv owncloud public
ADD nginx.conf /opt/owncloud/
ADD php-fpm.conf /opt/owncloud/
ADD start.sh /opt/owncloud/
RUN chown -R root:root /opt/owncloud

RUN useradd -d /opt/owncloud -s /usr/sbin/nologin -u 1281 -g 100 -c OwnCloud owncloud
RUN rm -f /opt/owncloud/public/config/config.php && ln -s /var/lib/owncloud/config.php /opt/owncloud/public/config/config.php
RUN install -o owncloud -g users -m 700 -d /var/log/owncloud
RUN chown -R owncloud:root /var/lib/nginx

# Fix /var/lib/nginx permissions
RUN rm -rf /var/lib/nginx/*
RUN mkdir -p /var/lib/nginx/{body,fastcgi,proxy,scgi,uwsgi}
RUN chown -R owncloud:root /var/lib/nginx
RUN chmod 700 /var/lib/nginx/*

VOLUME ["/var/lib/owncloud"]

WORKDIR /opt/owncloud
CMD ["/opt/owncloud/start.sh"]
