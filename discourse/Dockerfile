FROM ruby:2.3

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates build-essential gifsicle git \
    jhead jpegoptim libpq-dev libxml2-dev libxslt-dev nodejs optipng pngquant pkg-config && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /opt/app
ENV RAILS_ENV production

RUN git clone --depth 1 --branch stable https://github.com/discourse/discourse.git . && \
    bundle config --global frozen 1 && \
    bundle config --global jobs 6 && \
    bundle config build.nokogiri --use-system-libraries && \
    bundle install --deployment --without development test && \
    rm -rf log && mkdir -p log && \
    ln -sf /dev/stderr log/unicorn.stderr.log && \
    ln -sf /dev/stdout log/unicorn.stdout.log && \
    ln -sf /dev/stdout log/production.log && \
    mkdir -p /tmp/app && ln -sf /tmp/app tmp && mkdir -p tmp/cache tmp/pids tmp/sessions tmp/sockets

#RUN bundle exec rake assets:precompile

COPY run.sh /
RUN chmod 755 /run.sh
ENTRYPOINT ["/run.sh"]

EXPOSE 3000
