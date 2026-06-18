# Day 29 – Introduction to Docker

## Introduction

Today I started learning Docker, one of the most important technologies in modern DevOps.

Before Docker, developers often faced the problem of:

> "It works on my machine but not in production."

Docker solves this problem by packaging applications and their dependencies into lightweight, portable units called containers.

Containers ensure applications run consistently across development, testing, and production environments.

---

# Task 1: What is Docker?

## What is a Container?

A container is a lightweight, isolated environment that contains:

* Application Code
* Runtime
* Libraries
* Dependencies
* Configuration

Containers share the host operating system kernel but run independently.

### Why Do We Need Containers?

Without containers:

* Environment inconsistencies occur
* Dependency conflicts happen
* Deployment becomes difficult

With containers:

✅ Consistent deployments

✅ Faster startup

✅ Better resource utilization

✅ Easy scaling

---

# Containers vs Virtual Machines

| Feature        | Container   | Virtual Machine |
| -------------- | ----------- | --------------- |
| OS Kernel      | Shared      | Separate        |
| Startup Time   | Seconds     | Minutes         |
| Size           | MBs         | GBs             |
| Performance    | Near Native | More Overhead   |
| Resource Usage | Low         | High            |

---

## Virtual Machine Architecture

```text
Hardware
│
Hypervisor
│
├── VM 1 (Guest OS)
├── VM 2 (Guest OS)
└── VM 3 (Guest OS)
```

---

## Container Architecture

```text
Hardware
│
Host OS
│
Docker Engine
│
├── Container 1
├── Container 2
└── Container 3
```

Containers share the host OS kernel.

---

# Docker Architecture

Docker consists of:

### Docker Client

The command line tool.

Example:

```bash
docker run nginx
```

---

### Docker Daemon

Background service that manages:

* Images
* Containers
* Networks
* Volumes

---

### Docker Images

Read-only templates used to create containers.

Example:

```text
Ubuntu Image
Nginx Image
Redis Image
```

---

### Docker Containers

Running instances of images.

Example:

```bash
docker run nginx
```

Creates a container from the nginx image.

---

### Docker Registry

Stores Docker Images.

Most common registry:

```text
Docker Hub
```

---

## Docker Architecture Diagram

```text
Docker Client
      │
      ▼
Docker Daemon
      │
 ┌────┴────┐
 ▼         ▼
Images  Containers
      │
      ▼
 Docker Hub
```

---

# Task 2: Install Docker

## Install Docker (Ubuntu)

```bash
sudo apt update
sudo apt install docker.io -y
```

---

## Start Docker

```bash
sudo systemctl start docker
sudo systemctl enable docker
```

---

## Verify Installation

```bash
docker --version
```

Example Output:

```bash
Docker version 27.x.x
```

---

## Verify Docker Service

```bash
sudo systemctl status docker
```

---

## Run Hello World

```bash
sudo docker run hello-world
```

Output:

```text
Hello from Docker!
This message shows that your installation appears to be working correctly.
```

### What Happened?

1. Docker searched for image
2. Downloaded image from Docker Hub
3. Created container
4. Executed container
5. Displayed message
6. Exited container

---

# Task 3: Run Real Containers

## Run Nginx Container

```bash
sudo docker run -d -p 8080:80 nginx
```

Explanation:

```text
-d     Detached Mode
-p     Port Mapping
8080   Host Port
80     Container Port
```

---

## Verify Container

```bash
sudo docker ps
```

Output:

```text
CONTAINER ID
IMAGE
STATUS
PORTS
```

---

## Access Nginx

Browser:

```text
http://localhost:8080
```

You should see:

```text
Welcome to nginx!
```

---

## Run Ubuntu Container

```bash
sudo docker run -it ubuntu
```

Explanation:

```text
-i  Interactive
-t  Terminal
```

---

## Inside Container

Try:

```bash
ls
pwd
cat /etc/os-release
```

Exit:

```bash
exit
```

---

## List Running Containers

```bash
sudo docker ps
```

---

## List All Containers

```bash
sudo docker ps -a
```

---

## Stop Container

```bash
sudo docker stop 1ddac5b39f60
```

Example:

```bash
sudo docker stop 1ddac5b39f60
```

---

## Remove Container

```bash
sudo docker rm 1ddac5b39f60
```

---

# Task 4: Explore Docker

## Detached Mode

```bash
sudo docker run -d nginx
```

Container runs in background.

---

## Custom Container Name

```bash
sudo docker run -d --name my-nginx nginx
```

---

## Port Mapping

```bash
sudo docker run -d -p 9090:80 nginx
```

Host:

```text
localhost:9090
```

Container:

```text
port 80
```

---

## View Logs

```bash
sudo docker logs my-nginx
```

---

## Execute Command Inside Container

```bash
sudo docker exec -it my-nginx bash
```

or

```bash
sudo docker exec -it my-nginx sh
```

---

## Check Running Containers

```bash
sudo docker ps
```

Example:

```text
CONTAINER ID   IMAGE     COMMAND                  CREATED         STATUS         PORTS                                     NAMES
19d7bf7ba6bb   nginx     "/docker-entrypoint.…"   2 minutes ago   Up 2 minutes   0.0.0.0:9090->80/tcp, [::]:9090->80/tcp   kind_cray
54fba87fec62   nginx     "/docker-entrypoint.…"   2 minutes ago   Up 2 minutes   80/tcp                                    my-nginx
7a33c35078b9   nginx     "/docker-entrypoint.…"   3 minutes ago   Up 3 minutes   80/tcp                                    interesting_varahamihira
```

---

# Important Docker Commands

## Download Image

```bash
sudo docker pull nginx
```

---

## Run Container

```bash
sudo docker run nginx
```

---

## Run Interactive

```bash
sudo docker run -it ubuntu
```

---

## Run Detached

```bash
sudo docker run -d nginx
```

---

## List Containers

```bash
sudo docker ps
sudo docker ps -a
```

---

## Stop Container

```bash
sudo docker stop 54fba87fec62
```

---

## Remove Container

```bash
sudo docker rm 54fba87fec62
```

---

## Logs

```bash
sudo docker logs 7a33c35078b9
```

---

## Execute Command

```bash
sudo docker exec -it 7a33c35078b9 bash
```

---

# Screenshots to Capture

### Screenshot 1

```bash
sudo docker run hello-world
```

---

### Screenshot 2

```bash
sudo docker ps
```

---

### Screenshot 3

Nginx running in browser:

```text
localhost:8080
```

---

### Screenshot 4

Ubuntu interactive container:

```bash
sudo docker run -it ubuntu
```

---

# Key Learnings

## 1. Containers are Lightweight

Containers share the host kernel and consume fewer resources than VMs.

---

## 2. Docker Simplifies Deployment

Applications behave consistently across environments.

---

## 3. Images and Containers are Different

Image = Template

Container = Running Instance

---

## 4. Docker Hub is a Central Registry

Docker automatically downloads images when needed.

---

# Conclusion

Today I learned the fundamentals of Docker, including containers, images, Docker architecture, installation, and container lifecycle management. I successfully ran my first Docker containers using hello-world, Nginx, and Ubuntu, gaining hands-on experience with one of the most important technologies in modern DevOps and Cloud Engineering.
