# Zargony's Infrastructure Setup

## Host setup

Building images requires [Docker][docker], so you either need a VM running docker for testing or a real host that runs Docker.

### Virtual host

For local testing, simply prepare a host in a virtual machine:

    $ vagrant up

### Real host

For setting up a real host, see [HOST.md][HOST.md].


## Building a base image

To create a new minimal base image:

    $ make base

The base image is a prerequisite for other images and contains a minimal OS with common settings and latest updates. It serves as the base for further images and containers.


[HOST.md]: HOST.md
[docker]: http://docker.io/
