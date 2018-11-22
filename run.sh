#!/bin/sh

set -e

rm -rf build
mkdir -p build

#docker rm "docker-build"
docker run -it --privileged --name "docker-build" "docker/docker-ce"
docker cp "docker-build":/opt/app/docker-ce/components/packaging/static/build/win/docker/ build
docker rm "docker-build"
