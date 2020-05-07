#!/bin/bash

VIRTUAL_HOST_NAME=$1
IMAGE=$2
INTERNAL_PORT=$3
CONFIG_TEMPLATE=$4

DEFAULT_CONFIG_TEMPLATE=./VIRTUAL_HOST_CONFIG_TEMPLATE.conf
DEFAULT_INTERNAL_PORT=3000

if [ -z "$VIRTUAL_HOST_NAME" ]; then
  echo "Virtual host not defined"
  exit 1
fi

if [ -z "$IMAGE" ]; then
  echo "Image host not defined"
  exit 1
fi

if [ -z "$INTERNAL_PORT" ]; then
  echo "Use default internal port $DEFAULT_INTERNAL_PORT"

  INTERNAL_PORT=$DEFAULT_INTERNAL_PORT
fi

if test -f "$CONFIG_TEMPLATE"; then
  echo "Use supplied template";
else
  echo "Use default template";
  CONFIG_TEMPLATE=$DEFAULT_CONFIG_TEMPLATE
fi

#############################################

mkdir -p apps/$VIRTUAL_HOST_NAME

PORT=$(./lib/get-free-port.sh)

echo Port: $PORT

./lib/docker-run.sh $VIRTUAL_HOST_NAME $IMAGE $INTERNAL_PORT $PORT

./lib/nginx-create-virtualhost.sh $VIRTUAL_HOST_NAME $PORT $CONFIG_TEMPLATE
