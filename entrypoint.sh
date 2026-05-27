#!/bin/bash -e

: "${SPACES_ACCESS_KEY?}"
: "${SPACES_SECRET_KEY?}"
: "${SPACES_REGION?}"
: "${SPACES_NAME?}"
: "${MOUNT_DIRECTORY?}"
: "${UID?}"
: "${GID?}"

: "${SPACES_ENDPOINT:=https://${SPACES_REGION}.digitaloceanspaces.com}"

READWRITE_FLAG="-o rw"
if [ "${READONLY}" ]; then
  READWRITE_FLAG="-o ro"
fi

mkdir -p /root/.aws/
echo "[default]
aws_access_key_id = ${SPACES_ACCESS_KEY}
aws_secret_access_key = ${SPACES_SECRET_KEY}" > /root/.aws/credentials

mkdir -p "${MOUNT_DIRECTORY}"

cleanup() {
  fusermount -u "${MOUNT_DIRECTORY}" 2>/dev/null || umount -l "${MOUNT_DIRECTORY}" 2>/dev/null || true
}
trap 'cleanup; kill -TERM "${GOOFYS_PID}" 2>/dev/null; wait "${GOOFYS_PID}" 2>/dev/null; exit 0' SIGTERM SIGINT
trap cleanup EXIT

goofys --file-mode=0666 --endpoint="${SPACES_ENDPOINT}" --region="${SPACES_REGION}" --uid="${UID}" --gid="${GID}" -o allow_other ${READWRITE_FLAG} -f "${SPACES_NAME}" "${MOUNT_DIRECTORY}" &
GOOFYS_PID=$!
wait "${GOOFYS_PID}"

