FROM zargony/base

RUN apt-get -qqy install git-core ruby build-essential ruby-dev libsqlite3-dev libxml2-dev
RUN gem install bundler --no-rdoc --no-ri

RUN git clone https://github.com/chiliproject/chiliproject.git --branch stable --depth 1 /opt/redmine
ADD Gemfile.local /opt/redmine/
ADD config.ru /opt/redmine/
ADD configuration.yml /opt/redmine/config/
ADD database.yml /opt/redmine/config/
ADD robots.txt /opt/redmine/public/
RUN rm -f /opt/redmine/public/favicon.ico
RUN rm -rf /opt/redmine/public/files; ln -s /var/lib/redmine/files /opt/redmine/public/files
RUN rm -rf /opt/redmine/public/plugin_assets; ln -s /var/lib/redmine/plugin_assets /opt/redmine/public/plugin_assets
ADD pridago.css /opt/redmine/public/themes/pridago/stylesheets/application.css
ADD soapbox_parade.css /opt/redmine/public/themes/soapbox_parade/stylesheets/application.css
RUN rm -rf /opt/redmine/log; ln -s /var/log/redmine /opt/redmine/log
RUN rm -rf /opt/redmine/tmp; ln -s /tmp/redmine /opt/redmine/tmp

RUN cd /opt/redmine && bundle install --without mysql2 postgres rmagick
RUN cd /opt/redmine && rake config/initializers/session_store.rb

RUN useradd -d /opt/redmine -s /bin/false -u 1282 -g 100 redmine
RUN mkdir /tmp/redmine; chown redmine:users /tmp/redmine; chmod 700 /tmp/redmine
RUN mkdir /var/log/redmine; chown redmine:users /var/log/redmine; chmod 700 /var/log/redmine

VOLUME ["/var/lib/redmine"]

USER redmine
ENV RAILS_ENV production
CMD ["/opt/redmine/script/server", "-p", "5000"]
EXPOSE 5000
