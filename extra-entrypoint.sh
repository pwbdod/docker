#!/bin/sh

# no arguments passed
# or first arg is `-f` or `--some-option`
if [ "$#" -eq 0 ] || [ "${1#-}" != "$1" ]; then
	if [ -n "${DOCKER_REGISTRY_MIRROR:-}" ]; then
		set -- \
			--registry-mirror="$DOCKER_REGISTRY_MIRROR" \
			"$@"
    fi

	if [ -n "${DOCKER_INSECURE_REGISTRY:-}" ]; then
		set -- \
			--insecure-registry="$DOCKER_INSECURE_REGISTRY" \
			"$@"
    fi
fi

set -- dockerd-entrypoint.sh "$@"

exec "$@"