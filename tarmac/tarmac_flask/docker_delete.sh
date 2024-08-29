#!/usr/bin/env bash
#kill all containers
docker kill $(docker ps -a -q)
# Delete all containers
docker rm $(docker ps -a -q)
# Delete all images
docker rmi $(docker images -q)