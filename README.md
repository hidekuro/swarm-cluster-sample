# About

HA & Scalable Swarm Cluster sample.

# Requirements

* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* [docker](https://www.docker.com/products/docker)
* [docker-machine](https://docs.docker.com/machine/install-machine/)

or

* [Docker Toolbox](https://www.docker.com/products/docker-toolbox)

# Getting started

create cluster machines.

```bash
bash ./create.sh
```

The cluster shown below is created.

![cluster.png](cluster.png)

# Try Ops

Try `docker` command on swarm mode machine.

```bash
eval $(docker-machine config manager-0)
docker info
docker service ls
docker stack ls
```

manager-0, manager-1, and manager-2 is "replicated manager nodes".

you can also use manager-1 instead of manager-0. The same is true for manager-2.

## Examples

run once `eval $(docker-machine env manager-0)` before all operations.

### listing nodes

```bash
docker node ls
```

```text
ID                           HOSTNAME    STATUS  AVAILABILITY  MANAGER STATUS
0w0hi49opinwoilkudr4x0h1b    worker-2-1  Ready   Active
1sc2qbqsfa0a6tqrbe4uz8in2    worker-1-1  Ready   Active
557xwsctmlx6waag2hnguhwu8    worker-0-1  Ready   Active
7mdku2sk5pyaji72k64p6o2qd    worker-1-0  Ready   Active
f4vh1htdhb1pltu75nhdmqprl    manager-1   Ready   Active        Reachable
m92mx3d5i4ga119al7xomle3x *  manager-0   Ready   Active        Leader
miys28yroy4p5ac15l708o7px    worker-2-0  Ready   Active
pv9rwwkzkxp50ch9rmv5qsmt6    manager-2   Ready   Active        Reachable
xhavctvvhm8yfnyjbnk56gzk1    worker-0-0  Ready   Active
```

### stack deploy

```bash
docker stack deploy -c myapp/docker-compose.yml myapp
docker stack ls
```

```text
NAME   SERVICES
myapp  1
```

list services

```bash
docker stack services myapp
```

```text
ID            NAME       MODE        REPLICAS  IMAGE
50v9f08afwra  myapp_web  replicated  6/6       nginx:latest
```

list tasks (means like a "containers")

```bash
docker stack ps myapp
```

```text
ID            NAME         IMAGE         NODE        DESIRED STATE  CURRENT STATE          ERROR  PORTS
02fxtfu5myrf  myapp_web.1  nginx:latest  worker-0-1  Running        Running 2 minutes ago
lv4orevn0a4q  myapp_web.2  nginx:latest  worker-0-0  Running        Running 2 minutes ago
o6g6oo6aw3bb  myapp_web.3  nginx:latest  worker-0-1  Running        Running 2 minutes ago
qqtas7mixk43  myapp_web.4  nginx:latest  worker-1-0  Running        Running 2 minutes ago
vyivx6seef5l  myapp_web.5  nginx:latest  worker-1-1  Running        Running 2 minutes ago
wdo0cmntp43q  myapp_web.6  nginx:latest  worker-0-0  Running        Running 2 minutes ago
```

### scale-in/out service

scale-in

```bash
docker service scale myapp_web=4
docker stack ps myapp
```

```text
ID            NAME         IMAGE         NODE        DESIRED STATE  CURRENT STATE          ERROR  PORTS
02fxtfu5myrf  myapp_web.1  nginx:latest  worker-0-1  Running        Running 6 minutes ago
qqtas7mixk43  myapp_web.4  nginx:latest  worker-1-0  Running        Running 6 minutes ago
vyivx6seef5l  myapp_web.5  nginx:latest  worker-1-1  Running        Running 6 minutes ago
wdo0cmntp43q  myapp_web.6  nginx:latest  worker-0-0  Running        Running 6 minutes ago
```

scale-out

```bash
docker service scale myapp_web=8
docker stack ps myapp
```

```text
ID            NAME         IMAGE         NODE        DESIRED STATE  CURRENT STATE                     ERROR  PORTS
02fxtfu5myrf  myapp_web.1  nginx:latest  worker-0-1  Running        Running 7 minutes ago
vbvxupix5d3x  myapp_web.2  nginx:latest  worker-1-0  Running        Running less than a second ago
152c9w3u3nu1  myapp_web.3  nginx:latest  worker-2-1  Running        Preparing less than a second ago
qqtas7mixk43  myapp_web.4  nginx:latest  worker-1-0  Running        Running 7 minutes ago
vyivx6seef5l  myapp_web.5  nginx:latest  worker-1-1  Running        Running 7 minutes ago
wdo0cmntp43q  myapp_web.6  nginx:latest  worker-0-0  Running        Running 7 minutes ago
ricrj2w54i7x  myapp_web.7  nginx:latest  worker-2-0  Running        Preparing less than a second ago
vh7x3bv3cw90  myapp_web.8  nginx:latest  worker-2-0  Running        Preparing less than a second ago
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
