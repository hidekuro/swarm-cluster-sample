#!/bin/bash
set -e
cd $(dirname $0)

for i in 0 1 2; do
  docker-machine start consul$i
  docker-machine start manager$i
  for n in 0 1; do
    docker-machine start agent$i-$n
  done
done
