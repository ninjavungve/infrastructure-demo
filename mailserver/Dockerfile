FROM zargony/base

# FIXME: Workaround for weird dovecot install problems in Ubuntu 14.04
RUN apt-get -qqy install dovecot-core; ln -s /lib/init/upstart-job /etc/init.d/dovecot; apt-get -qqy install dovecot-core

RUN apt-get -qqy install ca-certificates dovecot-imapd

ADD imap.zargony.com.key /etc/ssl/private/
RUN chown 0:0 /etc/ssl/private/*; chmod 600 /etc/ssl/private/*
ADD imap.zargony.com.pem /etc/ssl/certs/
RUN update-ca-certificates --fresh

ADD dovecot.conf /opt/dovecot/
ADD users /opt/dovecot/
RUN chown root:dovecot /opt/dovecot/users; chmod 640 /opt/dovecot/users

VOLUME ["/var/mail"]

CMD ["/usr/sbin/dovecot", "-c", "/opt/dovecot/dovecot.conf", "-F"]
EXPOSE 993
