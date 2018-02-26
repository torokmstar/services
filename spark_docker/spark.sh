#!/usr/bin/env bash

CMD="$1"

IMG_NAME="spark"
NAME="spark_doc"
PORT=8080

OLD_ID=$( docker ps -aq --format '{{.ID}}' --filter=name=$NAME )
case "$CMD" in
  build)
    docker rm $(docker ps -aq -f status=exited)
    docker images -f “dangling=true” -q   echo "removing $OLD_ID"

    docker stop "$OLD_ID"
    docker rm "$OLD_ID"
    docker image rm "$IMG_NAME"

    echo "builing $IMG_NAME"
    docker build -t "$IMG_NAME" .
    ;;
  start)
    echo "running container"
    docker run -m 3000M -h "$NAME" -d -p 50022:22 -p "$PORT":"$PORT" --name "$NAME" "$IMG_NAME" 
    ;;
  remove)
    if [[ "$OLD_ID" != "" ]]; then
      docker rm $(docker ps -aq -f status=exited)
      docker images -f “dangling=true” -q
      echo "killing $NAME aka $OLD_ID"
      docker stop "$NAME"
      docker rm "$NAME"
    fi
    ;;
  *)
    echo "Usage: $0 {build|start|remove}"
    ;;
esac



