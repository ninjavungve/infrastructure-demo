FROM zargony/base

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 80F70E11F0F0D5F10CB20E62F5DA5F09C3173AA6
RUN echo "deb http://ppa.launchpad.net/brightbox/ruby-ng/ubuntu trusty main" >/etc/apt/sources.list.d/ruby-ng.list
RUN apt-get -qq update

RUN apt-get -qqy install ca-certificates ruby2.2 ruby2.2-dev ruby-switch
RUN ruby-switch --set ruby2.2
RUN echo "gem: --no-document" >/etc/gemrc
RUN gem install bundler
