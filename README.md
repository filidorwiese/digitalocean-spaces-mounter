## Overview

This docker image can be used to mount a [DigitalOcean Spaces](https://www.digitalocean.com/products/spaces/) space as a filesystem within Kubenernetes as a sidecar container. It uses [Goofys](https://github.com/kahing/goofys) as the filesystem driver, which in turn is based on AWS CLI and Fuse.

## Usage in Kubernetes

Look at [kubernetes-example.yml](kubernetes-example.yml) for an example of how to mount your DO space and share it as a bidirectional volume to your main application. The `securityContext.privileged: true` flag is needed to allow fuse to mount in kernel user-space. You can't do without.

## Usage in docker-compose

The same idea is possible in Docker Compose using [bind propagation](https://docs.docker.com/storage/bind-mounts/#configure-bind-propagation):
````
version: '3.6'

services:
  myspace-mounter:
    image: filidorwiese/digitalocean-spaces-mounter:latest
    privileged: true
    volumes:
      - type: bind
        source: "${PWD}/target"
        target: /mnt/myspace
        bind:
          propagation: shared
    environment:
      - "SPACES_ACCESS_KEY=my-spaces-access-key"
      - "SPACES_SECRET_KEY=my-spaces-secret-key"
      - "SPACES_REGION=fra1"
      - "SPACES_NAME=myspace"
      - "MOUNT_DIRECTORY=/mnt/myspace"
      - "UID=101"
      - "GID=101"

  nginx:
    image: nginx:latest
    volumes:
      - type: bind
        source: "${PWD}/target"
        target: /var/www
        bind:
          propagation: slave

````

## Readonly

If you specificy a `READONLY` environment variable, no matter the contents, the space will be mounted as read-only.
