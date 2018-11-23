#!/bin/bash

service ssh start
nohup dockerd &

while /bin/true; do
  sleep 60
done
