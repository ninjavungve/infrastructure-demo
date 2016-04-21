FROM nginx:1.9

RUN apt-get update && \
    apt-get install -y ssl-cert --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

COPY nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p /var/www/certs && \
    /usr/sbin/make-ssl-cert generate-default-snakeoil && \
    openssl dhparam -out /var/www/certs/dhparam.pem 256 && \
    ln -sf /etc/ssl/private/ssl-cert-snakeoil.key /var/www/certs/www.zargony.com.key && \
    ln -sf /etc/ssl/certs/ssl-cert-snakeoil.pem /var/www/certs/www.zargony.com.pem && \
    ln -sf /etc/ssl/private/ssl-cert-snakeoil.key /var/www/certs/cloud.zargony.com.key && \
    ln -sf /etc/ssl/certs/ssl-cert-snakeoil.pem /var/www/certs/cloud.zargony.com.pem && \
    ln -sf /etc/ssl/private/ssl-cert-snakeoil.key /var/www/certs/developer.zargony.com.key && \
    ln -sf /etc/ssl/certs/ssl-cert-snakeoil.pem /var/www/certs/developer.zargony.com.pem

VOLUME /var/www
VOLUME /var/log/nginx

EXPOSE 80 443
