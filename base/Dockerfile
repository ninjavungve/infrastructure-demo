FROM ubuntu:14.04

ENV DEBIAN_FRONTEND="noninteractive"

RUN echo "Europe/Berlin" >/etc/timezone && dpkg-reconfigure tzdata

RUN apt-get -qq update
RUN apt-get -qqy upgrade
