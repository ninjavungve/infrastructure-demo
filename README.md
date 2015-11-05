# Zargony's Infrastructure Setup

## Components

- **Host**: a Linux machine that runs multiple containers. In production, this is a real server running the [Docker](http://www.docker.com/) daemon. For testing, a host can be started in a local VM.
- **Image**: a read-only image of the initial filesystem from which containers can be created.
- **Container**. runtime environment for a service (a filesystem based on its image and other runtime resources).

## Host setup

For local testing, use [docker-machine](https://www.docker.com/docker-machine).

For setting up a real host, see [HOST.md](HOST.md).

## Show service status

```sh
$ rake ps
```

## Running services

```sh
$ git pull
$ rake up
```

## Updating services

```sh
$ git pull
$ rake update
```
