#!/bin/sh

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

DOCKER_V=$(curl --silent "https://api.github.com/repos/docker/docker-ce/releases" | grep -Po '"tag_name": "\K.*?(?=")' | sed q)
DOCKER_COMPOSE_V=$(curl --silent "https://api.github.com/repos/docker/compose/releases" | grep -Po '"tag_name": "\K.*?(?=")' | sed q)
DOCKER_MACHINE_V=$(curl --silent "https://api.github.com/repos/docker/machine/releases" | grep -Po '"tag_name": "\K.*?(?=")' | sed q)

if [[ ! -z "$DOCKER_V" && ! -z "$DOCKER_COMPOSE_V" && ! -z "$DOCKER_MACHINE_V" ]]; then
    rm -rf build && mkdir -p build

    echo "========================================"
    echo "Docker: $DOCKER_V"
    echo "Docker-compose: v$DOCKER_COMPOSE_V"
    echo "Docker-machine: $DOCKER_MACHINE_V"
    echo "========================================"

    echo "Docker: $DOCKER_V" >> build/build.txt
    echo "Docker-compose: v$DOCKER_COMPOSE_V" > build/build.txt
    echo "Docker-machine: $DOCKER_MACHINE_V" > build/build.txt

    docker build --build-arg DOCKER_V=${DOCKER_V} -t "docker/docker-ce" .

    docker run -it --privileged --name "docker-build" "docker/docker-ce"
    docker cp "docker-build":/opt/app/docker-ce/components/packaging/static/build/win/docker/docker.exe build/docker.exe
    docker rm "docker-build"

    cd build
    curl -L --silent "https://github.com/docker/machine/releases/download/$DOCKER_MACHINE_V/docker-machine-Windows-x86_64.exe" --output docker-machine.exe
    curl -L --silent "https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_V/docker-compose-Windows-x86_64.exe" --output docker-compose.exe

else
    echo "========================================"
    echo "No version found !"
    echo "========================================"
fi