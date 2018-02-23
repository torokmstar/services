#!/usr/bin/env bash

CMD="$1"
NAME="local_net"
SEGMENT="172.60.0.0/16"

OLD_ID=$( docker network ls --filter=name=$NAME --format='{{.ID}}' )
case "$CMD" in
  create)
    if [[ -n "$OLD_ID" ]]; then
      echo "removing $OLD_ID"
      docker network rm "$OLD_ID"
    fi
    echo "creating $NAME with $SEGMENT"
    docker network create --subnet="$SEGMENT" "$NAME"
    ;;
  list)
    echo "listing networks"
    docker network ls
    ;;
  remove)
    echo "removing $NAME"
    docker network rm "$NAME"
    ;;
  *)
    echo "Usage: $0 {create|list|remove}"
    ;;
esac


