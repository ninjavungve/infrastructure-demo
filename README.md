# Zargony's Infrastructure Setup

## Components

- **Host**: a Linux machine that runs multiple containers. In production, this is a real server running the [Docker][docker] daemon. For testing, a host can be started in a local VM.
- **Base image**: a Docker image that contains a minimal Linux system, suitable for being used as the base for custom build services.

## Host setup

For local testing, use [docker-machine][docker-machine].

For setting up a real host, see [HOST.md][HOST.md].

## Building a base image

To create a new minimal base image, use `rake baseimage`. This gets the Docker ubuntu image, configures some core settings and stores it as the base image into Docker. The base image is the prerequisite for other images.

## Building / running /updating services

Use [docker-machine][docker-machine].


[HOST.md]: HOST.md
[docker]: http://www.docker.com/
[docker-machine]: https://www.docker.com/docker-machine
