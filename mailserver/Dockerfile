FROM zargony/base

# FIXME: Workaround for weird dovecot install problems in Ubuntu 14.04 (ignore first time install error)
RUN apt-get -qqy install dovecot-core; ln -s /lib/init/upstart-job /etc/init.d/dovecot; apt-get -qqy install dovecot-core

RUN apt-get -qqy install ca-certificates dovecot-imapd

ADD dovecot.conf /etc/

VOLUME ["/var/mail"]

CMD ["/usr/sbin/dovecot", "-c", "/etc/dovecot.conf", "-F"]
EXPOSE 993
