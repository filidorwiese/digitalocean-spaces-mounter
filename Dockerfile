FROM golang:1.15-buster

# Set debconf to run non-interactively
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

## Some dependencies for awscli
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      git build-essential libfuse-dev libcurl4-openssl-dev libxml2-dev pkg-config libssl-dev mime-support automake libtool

# Install Goofys
RUN go get github.com/kahing/goofys && \
    go install github.com/kahing/goofys

## Entry Point
ADD entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh
CMD ["/entrypoint.sh"]
