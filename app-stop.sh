#!/bin/bash

VIRTUAL_HOST_NAME=$1
CONTAINER=apps/$VIRTUAL_HOST_NAME/CONTAINER
NGINX_CONFIG=apps/$VIRTUAL_HOST_NAME/nginx.conf

if [ -z "$VIRTUAL_HOST_NAME" ]; then
  echo "Virtual host not defined"
  exit 1
fi

if test -f "$CONTAINER"; then
  echo "Stop application $VIRTUAL_HOST_NAME";
else
  echo "Container for application $VIRTUAL_HOST_NAME is not found";
  exit 1
fi

CONTAINER_ID=$(< $CONTAINER)

echo "Stop container ${CONTAINER_ID}"
docker stop $CONTAINER_ID
if [ $? -ne 0 ]; then
  echo "Stop failed"
  rm $CONTAINER
  exit 1
fi

echo "Remove container ${CONTAINER_ID}"
docker rm $CONTAINER_ID
if [ $? -ne 0 ]; then
  echo "Remove failed"
  rm $CONTAINER
  exit 1
fi

rm $CONTAINER
rm $NGINX_CONFIG