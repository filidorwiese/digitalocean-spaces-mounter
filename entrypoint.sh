#!/bin/bash -e

: "${SPACES_ACCESS_KEY?}"
: "${SPACES_SECRET_KEY?}"
: "${SPACES_REGION?}"
: "${SPACES_NAME?}"
: "${MOUNT_DIRECTORY?}"
: "${UID?}"
: "${GID?}"

mkdir -p /root/.aws/
echo "[default]
aws_access_key_id = ${SPACES_ACCESS_KEY}
aws_secret_access_key = ${SPACES_SECRET_KEY}" > /root/.aws/credentials

mkdir -p "${MOUNT_DIRECTORY}"
goofys --file-mode=0666 --endpoint="https://${SPACES_REGION}.digitaloceanspaces.com" --uid="${UID}" --gid="${GID}" -o allow_other -f "${SPACES_NAME}" "${MOUNT_DIRECTORY}"
