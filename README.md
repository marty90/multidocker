# MultiDocker
This container creates a system where each new user is forced to login into an independent docker container.
The obtained scenario is similar to a setup where each user is provided a **virtual machine**, but it is implemented with **docker**.

Each user has `root` access within her container and **cannot** access the physical machine nor other users' containers. Thus, this tool is useful to share a machine across different users that need to be root, but need to be isolated eachothers. Compared to per-user virtual machines, `multidocker` has few limitations: (i) users cannot interact with the kernel, (ii) users cannot create other users (only admin can). 

Under the hood it leverages the key ideas of [docker-in-docker](https://github.com/jpetazzo/dind) and [dockersh](https://github.com/Yelp/dockersh).

**Warning**:
It has not been designed for being deployed in the wild, nor has been tested by independent auditors.

# 1. Run
Just run.
```
sudo docker run  -d --privileged martino90/multidocker
```
The `--privileged` flag is needed as new containers are spawned within this one.
And ssh to the container with:
```
ssh root@<IPADDRESS>
```
`<IPADDRESS>` is the containers's ip address. You can get it with:
``` 
 docker inspect --format '{{ .NetworkSettings.IPAddress }}' <CONTAINER_ID>
```
Default password is `toor`. You may want to change it.
Within the container, you are in a standard Ubuntu image with few packets already installed.

You may want to `run` the container with the `-p [external_port]:22` to make the docker reachable from outside your machine via ssh on the port `[external_port]`.

# 2. Add users
To add a user in the system, ssh as root to the container (see previous point), and type:
```
adduser_docker <USERNAME>
```
This will create a new user. You have to specify the user's password.
You can manipulate the created user with normal bash tool (e.g., `deluser`).
`adduser_docker` is a simple macro that creates a user, and does some magic to force it to login in an independent container.

# 3. Connect as a user
To login as user in the system, ssh to the container:
```
ssh <USERNAME>@<IPADDRESS>
```
The user is prompted in **its own** docker container. The base image is `ubuntu`.
This is an independent container, where the user can play and install whatever she wants.
The user has almost the same freedom as in a virtual machine (few limitations are imposed by docker).
You may want to add your ssh public key in `~/.ssh/authorized_keys` to autologin in the shell.

You can logout from the shell, and then login again; the container is **persistent**!
