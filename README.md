## Overview

This docker image can be used to mount a [DigitalOcean Space](https://www.digitalocean.com/products/spaces/) as a filesystem within Kubenernetes as a sidecar container. It uses [Goofys](https://github.com/kahing/goofys) as the filesystem driver, which in turn is based on AWS CLI and Fuse.

## Usage in Kubernetes

Look at [kubernetes-example.yml](kubernetes-example.yml) for an example of how to mount your space and share it as a Bidirectional volume to your main application. The `securityContext.privileged: true` flag is needed to allow fuse to mount in kernel user-space. You can't do without.
