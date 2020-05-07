#!/bin/bash

PORT_FROM=3000
PORT_TO=4000
COUNT=1

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  comm -23 \
    <(seq "$PORT_FROM" "$PORT_TO" | sort) \
    <(netstat -tan | tail -n+3 | awk '{print $4}' | awk -F: '{print $(NF)}' | sort -u) \
    | shuf | head -n "$COUNT"
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
  comm -23 \
      <(seq "$PORT_FROM" "$PORT_TO" | sort) \
      <(netstat -tan -p tcp | tail -n+3 | awk '{print $4}' | awk -F. '{print $(NF)}' | sort -u) \
      | sort -R | head -n "$COUNT"
fi;
