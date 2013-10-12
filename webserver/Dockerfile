FROM zargony/base

RUN apt-get -qqy install nginx ca-certificates

ADD developer.zargony.com.key /etc/ssl/private/
RUN chown 0:0 /etc/ssl/private/*; chmod 600 /etc/ssl/private/*
ADD developer.zargony.com.pem /etc/ssl/certs/
RUN update-ca-certificates

ADD nginx.conf /opt/nginx/nginx.conf

VOLUME ["/var/www"]

CMD ["/usr/sbin/nginx", "-c", "/opt/nginx/nginx.conf"]
EXPOSE 80 443
