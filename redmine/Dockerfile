FROM zargony/base

RUN apt-get -qqy install git ruby build-essential ruby-dev libsqlite3-dev libxml2-dev
RUN gem install bundler --no-rdoc --no-ri

RUN git clone https://github.com/chiliproject/chiliproject.git --branch stable --depth 1 /opt/redmine
ADD Gemfile.local /opt/redmine/
ADD config.ru /opt/redmine/
ADD configuration.yml /opt/redmine/config/
ADD database.yml /opt/redmine/config/
ADD robots.txt /opt/redmine/public/
RUN rm -f /opt/redmine/public/favicon.ico
RUN rm -rf /opt/redmine/public/files && ln -s /var/lib/redmine/files /opt/redmine/public/files
RUN rm -rf /opt/redmine/public/plugin_assets && ln -s /var/lib/redmine/plugin_assets /opt/redmine/public/plugin_assets
ADD pridago.css /opt/redmine/public/themes/pridago/stylesheets/application.css
ADD soapbox_parade.css /opt/redmine/public/themes/soapbox_parade/stylesheets/application.css
RUN rm -rf /opt/redmine/log && ln -s /var/log/redmine /opt/redmine/log
RUN rm -rf /opt/redmine/tmp && ln -s /tmp/redmine /opt/redmine/tmp

RUN cd /opt/redmine && bundle install --without mysql2 postgres rmagick
RUN cd /opt/redmine && rake config/initializers/session_store.rb

RUN useradd -d /opt/redmine -s /usr/sbin/nologin -u 1282 -g 100 -c Redmine redmine
RUN chown redmine:users /opt/redmine/config/*.yml && chmod 400 /opt/redmine/config/*.yml
RUN install -o redmine -g users -m 700 -d /tmp/redmine
RUN install -o redmine -g users -m 700 -d /var/log/redmine

VOLUME ["/var/lib/redmine"]

USER redmine
WORKDIR /opt/redmine
CMD ["/usr/local/bin/unicorn", "--env", "production", "--listen", "/var/www/redmine/backend.sock"]
