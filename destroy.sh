#!/bin/bash
set -e
cd $(dirname $0)

for i in 0 1 2; do
  docker-machine rm -f consul$i
  docker-machine rm -f manager$i
  for n in 0 1; do
    docker-machine rm -f agent$i-$n
  done
done
