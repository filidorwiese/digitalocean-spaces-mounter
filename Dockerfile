FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      ca-certificates curl fuse mime-support && \
    rm -rf /var/lib/apt/lists/*

RUN curl -fsSL -o /usr/local/bin/goofys \
      https://github.com/kahing/goofys/releases/download/v0.24.0/goofys && \
    chmod +x /usr/local/bin/goofys

ADD entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh
CMD ["/entrypoint.sh"]
