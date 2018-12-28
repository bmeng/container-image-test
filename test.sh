#!/bin/bash

REGISTRY=$1
TAG=$2
IMAGES="keepalived-ipfailover egress-router egress-http-proxy egress-dns-proxy"

# Pre pull images in do not exist
for IMAGE in $IMAGES; do
  docker images | grep ose-$IMAGE.*$TAG 
  if [ $? -ne 0 ]; then
    docker pull $REGISTRY/ose-$IMAGE:$TAG
  fi
done

# Test images
for IMAGE in $IMAGES; do 
  container-structure-test test --image $REGISTRY/ose-$IMAGE:$TAG --config $IMAGE/metatest.yaml --config $IMAGE/filetest.yaml --config $IMAGE/cmdtest.yaml
  if [ $? -ne 0 ]; then
    break
    echo "$IMAGE failed"
  fi
done
