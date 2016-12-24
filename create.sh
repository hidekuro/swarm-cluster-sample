#!/bin/bash
set -e
cd $(dirname $0)

# create consul cluster
for i in 0 1 2; do
  docker-machine create \
    -d virtualbox \
    --virtualbox-memory 512 \
    --virtualbox-hostonly-cidr 10.20.$i.1/24 \
    --engine-label zone=zone$i \
    --engine-label role=consul \
    consul$i
done

# start consul servers
for i in 0 1 2; do
  docker $(docker-machine config consul$i) run \
    -d \
    --name consul$i \
    --restart always \
    -p 8300-8302:8300-8302/tcp \
    -p 8301-8302:8301-8302/udp \
    -p 8400:8400/tcp \
    -p 8500:8500/tcp \
    -p 8600:8600/tcp \
    -p 8600:8600/udp \
    consul agent \
      -server \
      -node consul$i \
      -ui \
      -client 0.0.0.0 \
      -advertise $(docker-machine ip consul$i) \
      -retry-join $(docker-machine ip consul0) \
      -bootstrap-expect 3
done

# create swarm-manager cluster
for i in 0 1 2; do
  docker-machine create \
    -d virtualbox \
    --virtualbox-memory 512 \
    --virtualbox-hostonly-cidr 10.20.$i.1/24 \
    --engine-opt cluster-store=consul://$(docker-machine ip consul$i):8500 \
    --engine-label zone=zone$i \
    --engine-label role=swarm-manager \
    --swarm-master \
    --swarm-discovery consul://$(docker-machine ip consul$i):8500 \
    --swarm-strategy spread \
    --swarm-opt replication \
    manager$i
done

# create swarm-agent
for i in 0 1 2; do
  for n in 0 1; do
    docker-machine create \
      -d virtualbox \
      --engine-opt cluster-store=consul://$(docker-machine ip consul$i):8500 \
      --engine-label zone=zone$i \
      --engine-label role=swarm-worker \
      --virtualbox-memory 512 \
      --virtualbox-hostonly-cidr 10.20.$i.1/24 \
      --swarm \
      --swarm-discovery consul://$(docker-machine ip consul$i):8500 \
      agent$i-$n
  done
done
