FROM zargony/base

RUN apt-get -qqy install nginx php5-cli php5-fpm php5-sqlite php5-gd

ADD http://download.owncloud.org/community/owncloud-6.0.3.tar.bz2 /opt/owncloud/
RUN cd /opt/owncloud && tar -jxf owncloud-*.tar.bz2 && mv owncloud public
ADD nginx.conf /opt/owncloud/
ADD php-fpm.conf /opt/owncloud/
ADD start.sh /opt/owncloud/
RUN chown -R 0:0 /opt/owncloud

RUN useradd -d /opt/owncloud -s /bin/false -u 1281 -g 100 owncloud
RUN mkdir /var/log/owncloud; chown owncloud:users /var/log/owncloud; chmod 700 /var/log/owncloud

ADD config.php /opt/owncloud/public/config/
RUN chown owncloud:www-data /opt/owncloud/public/config/config.php

VOLUME ["/var/lib/owncloud"]

WORKDIR /opt/owncloud
CMD ["/opt/owncloud/start.sh"]
