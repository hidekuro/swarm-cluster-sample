#!/bin/bash
set -e
cd $(dirname $0)

for i in 0 1 2; do
  nohup docker-machine start manager-${i} > /dev/null 2>&1 &
  for n in 0 1; do
    nohup docker-machine start worker-${i}-${n} > /dev/null 2>&1 &
  done
done
