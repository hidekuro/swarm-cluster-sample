# About

HA & Scalable Swarm Cluster sample.

# Requirements

* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* [docker](https://www.docker.com/)
  * docker-engine
  * docker-machine
  * docker-compose

# Getting started

create cluster machines.

```bash
bash ./create.sh
```

The cluster shown below is created.

![cluster.png](cluster.png)

# Consul Web UI

Consul Web UI is available in all `consul*` machine.

try to access `http://$(docker-machine ip consul0)/ui`.


# Try Ops

Try `docker` command on swarm mode machine.

```bash
docker $(docker-machine config --swarm manager0)
```

You can use `docker-compose` in the same way.

```bash
docker-compose $(docker-machine config --swarm manager0)
```

manager0, manager1, and manager2 is "replicated manager nodes".

you can also use manager1 instead of manager0. The same is true for manager2.

## Examples

### get swarm cluster info

```bash
docker $(docker-machine config --swarm manager0) info
```

### deploy apps

```bash
cd myapp
docker-compose $(docker-machine config --swarm manager0) up -d
```

### scale out docker-compose services

```bash
docker-compose $(docker-machine config --swarm manager0) scale web=6
```

# Destroying

remove all machines

```bash
bash ./destroy.sh
```

### NOTE

You need to delete manually host-only networks which IP is `10.20.*.1/24` using VirutalBox GUI.

# License

MIT License
