FROM nginx:1.9

RUN apt-get update && \
    apt-get install -y --no-install-recommends ssl-cert && \
    rm -rf /var/lib/apt/lists/*

COPY nginx.conf /etc/nginx/nginx.conf

RUN /usr/sbin/make-ssl-cert generate-default-snakeoil && \
    openssl dhparam -out /etc/ssl/dhparam.pem 256 && \
    mkdir -p /etc/letsencrypt/live/zargony.com && \
    ln -sf /etc/ssl/private/ssl-cert-snakeoil.key /etc/letsencrypt/live/zargony.com/privkey.pem && \
    ln -sf /etc/ssl/certs/ssl-cert-snakeoil.pem /etc/letsencrypt/live/zargony.com/fullchain.pem && \
    mkdir -p /etc/letsencrypt/live/cloud.zargony.com && \
    ln -sf /etc/ssl/private/ssl-cert-snakeoil.key /etc/letsencrypt/live/cloud.zargony.com/privkey.pem && \
    ln -sf /etc/ssl/certs/ssl-cert-snakeoil.pem /etc/letsencrypt/live/cloud.zargony.com/fullchain.pem && \
    mkdir -p /etc/letsencrypt/live/developer.zargony.com && \
    ln -sf /etc/ssl/private/ssl-cert-snakeoil.key /etc/letsencrypt/live/developer.zargony.com/privkey.pem && \
    ln -sf /etc/ssl/certs/ssl-cert-snakeoil.pem /etc/letsencrypt/live/developer.zargony.com/fullchain.pem && \
    mkdir -p /etc/letsencrypt/live/cafe.zargony.com && \
    ln -sf /etc/ssl/private/ssl-cert-snakeoil.key /etc/letsencrypt/live/cafe.zargony.com/privkey.pem && \
    ln -sf /etc/ssl/certs/ssl-cert-snakeoil.pem /etc/letsencrypt/live/cafe.zargony.com/fullchain.pem && \
    mkdir -p /var/www/blog /var/www/charmer

VOLUME /var/www
VOLUME /var/log/nginx

EXPOSE 80 443
