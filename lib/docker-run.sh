#!/bin/bash

VIRTUAL_HOST_NAME=$1
IMAGE=$2
INTERNAL_PORT=$3
EXTERNAL_PORT=$4

CONTAINER_INTERMEDIATE=apps/$VIRTUAL_HOST_NAME/CONTAINER_INTERMEDIATE
CONTAINER=apps/$VIRTUAL_HOST_NAME/CONTAINER
ENV_FILE=apps/$VIRTUAL_HOST_NAME/ENV
INTERNAL_SHARED_FOLDER=/usr/app/storage

NETWORK=hello-work

CHECK_TIMEOUT=2
CHECK_SUCCESS_RESULT="Hello work"
CHECK_URI=/CHECK

CONTAINER_NAME=$VIRTUAL_HOST_NAME-$EXTERNAL_PORT

if [ -z "$VIRTUAL_HOST_NAME" ]; then
  echo "Virtual host is not defined"
  exit 1
fi

if [ -z "$IMAGE" ]; then
  echo "Image is not defined"
  exit 1
fi

if [ -z "$INTERNAL_PORT" ]; then
  echo "Internal port is not defined"
  exit 1
fi

if [ -z "$EXTERNAL_PORT" ]; then
  echo "External port is not defined"
  exit 1
fi

#############################################
echo "Create shared volume"

docker volume create $VIRTUAL_HOST_NAME

echo "Start new container ${IMAGE}"
docker run \
  --detach \
  --network $NETWORK \
  --restart unless-stopped \
  --publish 127.0.0.1:$EXTERNAL_PORT:$INTERNAL_PORT \
  --env-file $ENV_FILE \
  --volume $VIRTUAL_HOST_NAME:$INTERNAL_SHARED_FOLDER \
  --hostname $CONTAINER_NAME \
  --name $CONTAINER_NAME \
  $IMAGE > $CONTAINER_INTERMEDIATE

if [ $? -ne 0 ]; then
  echo "Start failed.";

  echo "Remove intermediate container.";
  docker rm "$(< $CONTAINER_INTERMEDIATE)"
  exit 1;
fi

echo "Check response"
sleep $CHECK_TIMEOUT
CHECK_RESULT="$(curl -s http://127.0.0.1:$EXTERNAL_PORT$CHECK_URI)"

echo "Result $CHECK_RESULT"

if [ "$CHECK_SUCCESS_RESULT" == "$CHECK_RESULT" ]; then
  echo "Check succeeded"
else
  echo "Check failed"
fi

if test -f "$CONTAINER"; then
  echo "Stop old container ${IMAGE}"
  docker stop "$(< $CONTAINER)"
  if [ $? -ne 0 ]; then
    echo "Stop failed"
  fi

  echo "Remove old container ${IMAGE}"
  docker rm "$(< $CONTAINER)"
  if [ $? -ne 0 ]; then
    echo "Remove failed"
  fi
fi

mv $CONTAINER_INTERMEDIATE $CONTAINER