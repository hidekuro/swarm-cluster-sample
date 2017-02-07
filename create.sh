#!/bin/bash
set -e
cd $(dirname $0)

# create swarm cluster
#
# + zone-0 (10.20.0.0/24)
#   + manager-0
#   | + worker-0-0
#   | + worker-0-1
# + zone-1 (10.20.1.0/24)
#   + manager-1
#   | + worker-1-0
#   | + worker-1-1
# + zone-2 (10.20.2.0/24)
#   + manager-2
#   | + worker-2-0
#   | + worker-2-1

# create manager machines
for i in 0 1 2; do
  docker-machine create \
    -d virtualbox \
    --virtualbox-memory="512" \
    --virtualbox-hostonly-cidr="10.20.${i}.1/24" \
    manager-${i}
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

# create worker machines
for i in 0 1 2; do
  for n in 0 1; do
    docker-machine create \
      -d virtualbox \
      --virtualbox-memory="512" \
      --virtualbox-hostonly-cidr="10.20.${i}.1/24" \
      worker-${i}-${n}

    # join to manager
    docker-machine ssh worker-${i}-${n} \
      docker swarm join \
        --advertise-addr="$(docker-machine ip worker-${i}-${n})" \
        --token="${WORKER_TOKEN}" \
        $(docker-machine ip manager-${i}):2377
  done
done
