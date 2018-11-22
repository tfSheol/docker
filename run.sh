#!/bin/sh

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

docker build -t "docker/docker-ce" .

rm -rf build
mkdir -p build

docker run -it --privileged --name "docker-build" "docker/docker-ce"
docker cp "docker-build":/opt/app/docker-ce/components/packaging/static/build/win/docker/docker.exe build/docker.exe
docker rm "docker-build"

cd build

curl -L --silent "https://github.com/docker/machine/releases/download/$(curl --silent "https://api.github.com/repos/docker/machine/releases" | grep -Po '"tag_name": "\K.*?(?=")' | sed q)/docker-machine-Windows-x86_64.exe" --output docker-machine.exe
curl -L --silent "https://github.com/docker/compose/releases/download/$(curl --silent "https://api.github.com/repos/docker/compose/releases" | grep -Po '"tag_name": "\K.*?(?=")' | sed q)/docker-compose-Windows-x86_64.exe" --output docker-compose.exe