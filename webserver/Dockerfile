FROM zargony/base

RUN apt-get -qqy install nginx ca-certificates

ADD nginx.conf /etc/

VOLUME ["/var/www"]

CMD ["/usr/sbin/nginx", "-c", "/etc/nginx.conf"]
EXPOSE 80 443
