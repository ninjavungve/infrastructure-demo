FROM ubuntu:14.04

ENV DEBIAN_FRONTEND="noninteractive"

RUN echo "Europe/Berlin" >/etc/timezone && dpkg-reconfigure tzdata

ADD proxydetect /etc/apt/
ADD apt.conf /etc/apt/apt.conf.d/02proxy

RUN apt-get -qq update
RUN apt-get -qqy upgrade
