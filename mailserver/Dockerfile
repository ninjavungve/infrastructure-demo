FROM alpine

RUN apk add --update ca-certificates dovecot

COPY dovecot.conf /etc/

VOLUME ["/var/mail"]

CMD ["/usr/sbin/dovecot", "-c", "/etc/dovecot.conf", "-F"]
EXPOSE 143 993
