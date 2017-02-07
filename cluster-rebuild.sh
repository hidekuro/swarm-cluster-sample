#!/bin/bash
set -e
cd $(dirname $0)

# dismantle cluster
for i in 2 1 0; do
  for n in 1 0; do
    docker-machine ssh worker-${i}-${n} docker swarm leave --force
  done
  docker-machine ssh manager-${i} docker swarm leave --force
done

# init primary manager
docker-machine ssh manager-0 \
  docker swarm init \
    --advertise-addr="$(docker-machine ip manager-0)" \
    --listen-addr=0.0.0.0:2377

# get tokens
MANAGER_TOKEN="$(docker-machine ssh manager-0 docker swarm join-token -q manager)"
WORKER_TOKEN="$(docker-machine ssh manager-0 docker swarm join-token -q worker)"

# join replicas to cluster
for i in 1 2; do
  docker-machine ssh manager-${i} \
    docker swarm join \
      --advertise-addr="$(docker-machine ip manager-${i})" \
      --token="${MANAGER_TOKEN}" \
      $(docker-machine ip manager-0):2377
done

# join workers to cluster
for i in 0 1 2; do
  for n in 0 1; do
    docker-machine ssh worker-${i}-${n} \
      docker swarm join \
        --advertise-addr="$(docker-machine ip worker-${i}-${n})" \
        --token="${WORKER_TOKEN}" \
        $(docker-machine ip manager-${i}):2377
  done
done
