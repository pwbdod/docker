FROM docker:dind

RUN apk add --no-cache bash

COPY dockerd-entrypoint.sh /usr/local/bin/