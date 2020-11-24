#!/bin/bash -e

# We're building using the Github Container Registry as a cache for docker build.
#
# This appears to perform the fastest, see:
# https://dev.to/dtinth/caching-docker-builds-in-github-actions-which-approach-is-the-fastest-a-research-18ei
#

: "${IMAGE?}"
: "${VERSION?}"
: "${CONTEXT?}"

if [[ ! "$VERSION" =~ ^([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}|latest)$ ]]; then
    echo "Provided tag $VERSION does not meet format of xxx.xxx.xxx"
    exit 1
fi

if [[ ! -f "${CONTEXT}/Dockerfile" ]]; then
    echo "Dockerfile ${CONTEXT}/Dockerfile not found"
    exit 1
fi

IMAGE_NAME="ghcr.io/${IMAGE}:latest"

docker pull "${IMAGE_NAME}" || true
docker build \
  --build-arg "VERSION=${VERSION}" \
  --cache-from="${IMAGE_NAME}" \
  --tag "${IMAGE_NAME}" \
  "${CONTEXT}"

docker push "${IMAGE_NAME}"
