#!/bin/bash
set -e
cd $(dirname $0)

for i in 0 1 2; do
  docker-machine start manager-${i}
  for n in 0 1; do
    docker-machine start worker-${i}-${n}
  done
done
