#!/bin/bash

APPS_FOLDER=apps/

docker create network nginx

docker run \
  --detach \
  --name nginx \
  --restart unless-stopped \
  --volume $APPS_FOLDER:/etc/nginx/conf.d/:ro \
  --network nginx \
  --publish 0.0.0.0:80:80 \
  nginx:latest
