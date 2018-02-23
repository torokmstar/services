#!/usr/bin/env bash

CMD="$1"

IMG_NAME="zookeeper"
NAME="zookeeper_doc"
PEER_PORT=2888
LEADER_PORT=3888
CLIENT_PORT=2181

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
    echo "running container"
    docker run -h "$NAME" -d -p "$PEER_PORT":"$PEER_PORT" -p "$LEADER_PORT":"$LEADER_PORT" -p "$CLIENT_PORT":"$CLIENT_PORT" --name "$NAME" "$IMG_NAME" 
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



