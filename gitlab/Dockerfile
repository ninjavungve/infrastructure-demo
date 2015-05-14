FROM zargony/base-ruby

RUN apt-get -qqy install git curl python2.7 checkinstall build-essential libpq-dev libxml2-dev libxslt-dev zlib1g-dev libyaml-dev libssl-dev libgdbm-dev libreadline-dev libncurses5-dev libffi-dev libcurl4-openssl-dev libicu-dev openssh-server redis-tools logrotate python-docutils pkg-config cmake ssmtp nodejs

ADD ssh_host_dsa_key /etc/ssh/
ADD ssh_host_dsa_key.pub /etc/ssh/
ADD ssh_host_ecdsa_key /etc/ssh/
ADD ssh_host_ecdsa_key.pub /etc/ssh/
ADD ssh_host_rsa_key /etc/ssh/
ADD ssh_host_rsa_key.pub /etc/ssh/
RUN chown root:root /etc/ssh/ssh_host*key* && chmod 600 /etc/ssh/ssh_host*key && chmod 644 /etc/ssh/ssh_host*key.pub
RUN install -o root -g root -m 755 -d /var/run/sshd

RUN git clone https://gitlab.com/gitlab-org/gitlab-ce.git --branch 7-10-stable --depth 1 /opt/gitlab
ADD database.yml /opt/gitlab/config/
ADD gitlab.yml /opt/gitlab/config/
ADD resque.yml /opt/gitlab/config/
ADD unicorn.rb /opt/gitlab/config/
RUN chmod 644 /opt/gitlab/config/*.yml
ADD smtp_settings.rb /opt/gitlab/config/initializers/
RUN cp /opt/gitlab/config/initializers/rack_attack.rb.example /opt/gitlab/config/initializers/rack_attack.rb
RUN sed -i "s/^\\s*config.serve_static_assets.*$/config.serve_static_assets = true/" /opt/gitlab/config/environments/production.rb
RUN rm -rf /opt/gitlab/log && ln -s /var/log/gitlab/gitlab /opt/gitlab/log
RUN rm -rf /opt/gitlab/tmp && ln -s /tmp/gitlab /opt/gitlab/tmp
RUN rm -rf /opt/gitlab/public/uploads && ln -s /var/lib/gitlab/uploads /opt/gitlab/public/uploads
RUN rm -rf /opt/gitlab/.secret && ln -s /var/lib/gitlab/.secret /opt/gitlab/
RUN rm -rf /opt/gitlab/.gitlab_shell_secret && ln -s /var/lib/gitlab/.gitlab_shell_secret /opt/gitlab/

RUN cd /opt/gitlab && bundle install --deployment --without development test mysql aws

RUN git clone https://gitlab.com/gitlab-org/gitlab-shell.git --branch v`cat /opt/gitlab/GITLAB_SHELL_VERSION` --depth 1 /opt/gitlab-shell
ADD gitlab-shell.yml /opt/gitlab-shell/config.yml
RUN rm -rf /opt/gitlab-shell/.gitlab_shell_secret && ln -s ../gitlab/.gitlab_shell_secret /opt/gitlab-shell/
RUN /opt/gitlab-shell/bin/install

RUN groupadd -g 1283 git
RUN useradd -d /var/lib/gitlab -s /bin/bash -u 1283 -g 1283 -c GitLab git
RUN install -o git -g git -m 750 -d /tmp/gitlab/cache
RUN install -o git -g git -m 750 -d /tmp/gitlab/pids
RUN install -o git -g git -m 750 -d /tmp/gitlab/repo_satellites
RUN install -o git -g git -m 750 -d /var/log/gitlab/gitlab
RUN install -o git -g git -m 750 -d /var/log/gitlab/gitlab-shell

RUN cd /opt/gitlab && bundle exec rake assets:precompile RAILS_ENV=production
RUN chmod 644 /opt/gitlab/config/initializers/*.rb
RUN chown -R git:git /tmp/gitlab
ADD start.sh /opt/gitlab/

VOLUME ["/var/lib/gitlab"]

WORKDIR /opt/gitlab
ENV RAILS_ENV production
CMD ["/opt/gitlab/start.sh"]
EXPOSE 22
