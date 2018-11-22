#!/bin/sh

set -e

docker-machine create --virtualbox-memory "4096" --virtualbox-cpu-count "4" --virtualbox-disk-size 150000 default
