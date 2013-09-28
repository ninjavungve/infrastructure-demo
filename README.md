# Zargony's Infrastructure Setup

## Components

- **Host**: a Linux machine that runs multiple images. In production, this is a real server running the Docker daemon. For testing, a host can be started in a local VM.
- **Base image**: a Docker image that contains a minimal Linux system, suitable for being used as the base for other images.
- **Image**: an image based on the base image that contains additional files required to run a specific service.

### Tools

- `bootstrap.sh`: Bootstraps a new Linux system into a target directory. Used to build a new base image, but can also be used to install an OS to a real server (see [HOST.md][HOST.md]).
- `install-docker.sh`: Installs the Docker daemon on the system it runs on.
- `make`: Used to build various images.

## Host setup

For local testing, fire up a host in a VM using `vagrant up`.

For setting up a real host, see [HOST.md][HOST.md].

## Building a base image

To create a new minimal base image, use `make base`. This uses bootstrap.sh to install a minimal base system into a directory, configures some core settings and imports it as the base image into Docker. The base image is the prerequisite for other images.

## Building an image

Use `make <subdir>` to build the image in the given subdirectory.

## Updating images

To update an image to the latest version, simply rebuild it. If the base image is rebuild, it'll contain all latest updates from the distribution (other images based on it must also be rebuild to take advantage of a new base image).


[HOST.md]: HOST.md
[docker]: http://docker.io/
[vagrant]: http://vagrantup.com/
