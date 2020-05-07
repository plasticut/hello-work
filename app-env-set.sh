#!/bin/bash

VIRTUAL_HOST_NAME=$1
ENV_FILE=apps/$VIRTUAL_HOST_NAME/ENV

if [ -z "$VIRTUAL_HOST_NAME" ]; then
  echo "Virtual host not defined"
  exit 1
fi

rm $ENV_FILE

for arg; do
  if [ "$arg" != "$VIRTUAL_HOST_NAME" ]; then
    echo "$arg" >> $ENV_FILE
  fi
done
