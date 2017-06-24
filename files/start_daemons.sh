#!/bin/bash

service ssh start
service docker start

while /bin/true; do
  sleep 60
done
