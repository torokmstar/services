#!/usr/bin/env bash

CMD="$1"

IMG_NAME="mongo"
NAME="mongo_doc"
PORT=27017


OLD_ID=$( docker ps -aq --format '{{.ID}}' --filter=name=$NAME )
case "$CMD" in
  build)
    echo "removing $OLD_ID"
    docker stop "$OLD_ID"
    docker rm "$OLD_ID"
    docker image rm "$IMG_NAME"

    echo "builing $IMG_NAME"
    docker build -t "$IMG_NAME" .
    ;;
  start)
    echo "removing $OLD_ID"
    docker stop "$OLD_ID"
    docker rm "$OLD_ID"
 
    echo "running mongo cont"
    docker run -h "$NAME" -d -p "$PORT":"$PORT" --name "$NAME" "$IMG_NAME" 
    ;;
  remove)
    if [[ "$OLD_ID" != "" ]]; then
      echo "killing $NAME aka $OLD_ID"
      docker stop "$NAME"
      docker rm "$NAME"
    fi
    ;;
  *)
    echo "Usage: $0 {build|start|remove}"
    ;;
esac



