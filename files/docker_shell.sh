#!/bin/bash

DOCKER_CONTAINER=ubuntu:latest

DESIRED_USER=$(whoami)
DOCKER_NAME="${DESIRED_USER}_shell"

DESIRED_UID=$(id -u $DESIRED_USER)
DESIRED_GID=$(id -g $DESIRED_USER)
HOMEDIR=$(eval echo ~$DESIRED_USER)
MYHOSTNAME="$(hostname --fqdn)-${DESIRED_USER}-docker"

# USE THIS TO RESUME NEW CONTAINERS
id=$(docker ps -aq --no-trunc --filter name=^/${DOCKER_NAME}$)
if [ -z "$id" ]; then
    # New docker
    docker run -t -i --hostname="$MYHOSTNAME" -v $HOMEDIR:$HOMEDIR:rw --name="$DOCKER_NAME"  "$DOCKER_CONTAINER"
else
    # Resume old
    docker start "$DOCKER_NAME"
    docker attach "$DOCKER_NAME"
fi

# USE THIS TO HAVE NEW CONTAINERS AT EACH LOGIN
#docker rm -f "$DOCKER_NAME" >/dev/null 2>&1 # May not be running, just throw away the output
#docker run --rm -t -i --hostname="$MYHOSTNAME" -v $HOMEDIR:$HOMEDIR:rw --name="$DOCKER_NAME"  "$DOCKER_CONTAINER"
