#!/bin/sh
set -e

# usage: file_env VAR [DEFAULT]
#    ie: file_env 'XYZ_DB_PASSWORD' 'example'
# (will allow for "$XYZ_DB_PASSWORD_FILE" to fill in the value of
#  "$XYZ_DB_PASSWORD" from a file, especially for Docker's secrets feature)
file_env() {
    local var="$1"
    local fileVar="${var}_FILE"
    local def="${2:-}"
    if [ "${!var:-}" ] && [ "${!fileVar:-}" ]; then
        echo >&2 "error: both $var and $fileVar are set (but are exclusive)"
        exit 1
    fi
    local val="$def"
    if [ "${!var:-}" ]; then
        val="${!var}"
    elif [ "${!fileVar:-}" ]; then
        val="$(< "${!fileVar}")"
    fi
    export "$var"="$val"
    unset "$fileVar"
}

file_env 'DOCKER_DIND_EXTRA_HOSTS'
if [ "$DOCKER_DIND_EXTRA_HOSTS" ]; then

    while IFS=':' read -r -d ',' host ip && [[ -n "$host" ]]; do
        echo "$ip $host"
    done <<<"${DOCKER_DIND_EXTRA_HOSTS},"


    IFS=',' read -ra EXTRA_HOSTS <<< "$DOCKER_DIND_EXTRA_HOSTS"
    for extra_host in "${EXTRA_HOSTS[@]}"; do
        while IFS=':' read -r host ip; do

        done <<< "$extra_host"
        IFS=':' read -ra EXTRA_HOSTS <<< "$DOCKER_DIND_EXTRA_HOSTS"
        echo i >> /etc/hosts
    done
fi

deamon_options=""
file_env 'DOCKER_DIND_DEAMON_OPTION'
if [ "$DOCKER_DIND_DEAMON_OPTION" ]; then
    deamon_options="$DOCKER_DIND_DEAMON_OPTION "
fi

# no arguments passed
# or first arg is `-f` or `--some-option`
if [ "$#" -eq 0 ] || [ "${1#-}" != "$1" ]; then
    # add our default arguments
    set -- dockerd \
        --host=unix:///var/run/docker.sock \
        --host=tcp://0.0.0.0:2375 \
        "${deamon_options}$@"
fi

if [ "$1" = 'dockerd' ]; then
    # if we're running Docker, let's pipe through dind
    # (and we'll run dind explicitly with "sh" since its shebang is /bin/bash)
    set -- sh "$(which dind)" "$@"

    # explicitly remove Docker's default PID file to ensure that it can start properly if it was stopped uncleanly (and thus didn't clean up the PID file)
    find /run /var/run -iname 'docker*.pid' -delete
fi

exec "$@"