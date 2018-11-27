#!/bin/bash

DOCKER_CONTAINER=ubuntu:latest

DESIRED_USER=$(whoami)
DOCKER_NAME="${DESIRED_USER}_shell"

DESIRED_UID=$(id -u $DESIRED_USER)
DESIRED_GID=$(id -g $DESIRED_USER)
HOMEDIR=$(eval echo ~$DESIRED_USER)
MYHOSTNAME="$(hostname --fqdn)-${DESIRED_USER}-docker"

# Create container if does not exist
id=$(docker ps -aq --no-trunc --filter name=^/${DOCKER_NAME}$)
if [ -z "$id" ]; then
    # New docker
    docker run -d --hostname="$MYHOSTNAME" -v $HOMEDIR:$HOMEDIR:rw --name="$DOCKER_NAME" \
                  "$DOCKER_CONTAINER" bash -c 'while true; do sleep 60 ; done'
fi

# Start the container (no matter if already running)
docker start "$DOCKER_NAME"

# Exec a shell in it
docker exec -it "$DOCKER_NAME" bash
