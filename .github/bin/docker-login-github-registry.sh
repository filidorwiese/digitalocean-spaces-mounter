#!/bin/bash -e

: "${GH_TOKEN?}"
: "${GH_USER?}"

echo "${GH_TOKEN}" | docker login https://ghcr.io -u "${GH_USER}" --password-stdin
