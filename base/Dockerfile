FROM ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive

RUN echo "Europe/Berlin" >/etc/timezone && dpkg-reconfigure tzdata

ADD proxydetect /etc/apt/
ADD apt-proxy.conf /etc/apt/apt.conf.d/02proxy

# TODO: Detect and support provider-specific mirrors like mirror.hetzner.de
RUN sed -i 's/archive.ubuntu.com/de.archive.ubuntu.com/' /etc/apt/sources.list

RUN apt-get -qq update
RUN apt-get -qqy upgrade
