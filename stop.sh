#!/bin/bash
set -e
cd $(dirname $0)

for i in 0 1 2; do
  docker-machine stop consul$i
  docker-machine stop manager$i
  for n in 0 1; do
    docker-machine stop agent$i-$n
  done
done
