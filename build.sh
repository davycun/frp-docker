#!/bin/sh

set -e

VERSION=$1

if [ "$VERSION" = "" ]; then
    echo "need on args for frp version"
    exit 1
fi

docker build -t davidcun/frp:$VERSION --build-arg VERSION=$VERSION -f Dockerfile .
docker push davidcun/frp:$VERSION
