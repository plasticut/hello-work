#!/bin/bash

VIRTUAL_HOST_NAME=$1
UPSTREAM_PORT=$2
CONFIG_TEMPLATE=$3

NGINX_CONFIG=apps/$VIRTUAL_HOST_NAME/nginx.conf
DOMAIN=$(cat DOMAIN)

if [ -z "$VIRTUAL_HOST_NAME" ]; then
  echo "Virtual host is not defined"
  exit 1
fi

if [ -z "$UPSTREAM_PORT" ]; then
  echo "Upstream port is not defined"
  exit 1
fi

if [ -z "$CONFIG_TEMPLATE" ]; then
  echo "Config template is not defined"
  exit 1
fi

#############################################

echo "Template: $CONFIG_TEMPLATE"

eval "echo \"$(<$CONFIG_TEMPLATE)\"" > $NGINX_CONFIG