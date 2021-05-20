#!/bin/bash
REGISTRY=registry.docker.libis.be
NAME=libis/annotot

build () {
  docker build . --rm --no-cache -t $NAME
}

push () {
  docker tag $NAME $REGISTRY/$NAME
  docker push $REGISTRY/$NAME
}


case "$1" in
  "build" )
    build
    ;;
  "push" )
    push
    ;;
  * )
    build
    push
    ;;
esac
