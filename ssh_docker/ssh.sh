#!/usr/bin/env bash

CMD="$1"

IMG_NAME="ssh_serv"
NAME="ssh_serv"
PORT=2222

OLD_ID=$( docker ps -aq --format '{{.ID}}' --filter=name=$NAME )
echo "OLD : $OLD_ID"
case "$CMD" in
  build)
    echo "removing $OLD_ID"
    docker stop "$OLD_ID"
    docker rm "$OLD_ID"
    docker image rm "$IMG_NAME"

    echo "builing $IMG_NAME"
    docker build -t "$IMG_NAME" .
    ;;
  remove)
    if [[ "$OLD_ID" != "" ]]; then
      echo "killing $OLD_ID"
      docker stop "$OLD_ID"
      docker rm "$OLD_ID"
    fi
    ;;
  start)
    echo "starting $NAME"
    docker run -h "$NAME" -d -p "$PORT":22 --name "$NAME" "$IMG_NAME"
    ;;
  login)
    ssh root@0.0.0.0 -p "$PORT"
    ;;
  *)
    echo "Usage: $0 {build|start|remove|login}"
    ;;

esac

