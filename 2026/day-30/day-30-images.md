# Day 30 – Docker Images & Container Lifecycle

## Objective

Today's goal was to understand how Docker Images and Containers work internally, explore image layers, and practice the complete container lifecycle from creation to removal.

---

# Task 1: Docker Images

## Pull Docker Images

```bash
sudo docker pull nginx
sudo docker pull ubuntu
sudo docker pull alpine
```

## List Available Images

```bash
sudo docker images
```

### Sample Output

```bash
IMAGE           ID             DISK USAGE   CONTENT SIZE   EXTRA
alpine:latest   28bd5fe8b56d         13MB         3.93MB
nginx:latest    42f2d24ae18d        241MB           66MB    U
ubuntu:latest   53958ec7b67c        160MB         45.3MB
```

## Ubuntu vs Alpine

| Ubuntu                           | Alpine                            |
| -------------------------------- | --------------------------------- |
| Full-featured Linux distribution | Minimal Linux distribution        |
| Larger image size                | Extremely small image size        |
| Includes many packages           | Includes only essential packages  |
| Better for development           | Better for lightweight containers |

### Why Alpine is Smaller?

Alpine Linux is built specifically for containers and uses BusyBox utilities instead of full GNU packages, making it much lighter and faster to download.

---

## Inspect an Image

```bash
sudo docker inspect nginx
```

### Information Available

* Image ID
* Environment Variables
* Labels
* Architecture
* Creation Date
* Entrypoint
* Layer Information

---

## Remove an Image

```bash
sudo docker rmi alpine
```

---

# Task 2: Docker Image Layers

## View Image History

```bash
sudo docker image history nginx
```

### Sample Output

```bash
IMAGE          CREATED        CREATED BY                                      SIZE      COMMENT
42f2d24ae18d   42 hours ago   CMD ["nginx" "-g" "daemon off;"]                0B        buildkit.dockerfile.v0
<missing>      42 hours ago   STOPSIGNAL SIGQUIT                              0B        buildkit.dockerfile.v0
<missing>      42 hours ago   EXPOSE map[80/tcp:{}]                           0B        buildkit.dockerfile.v0
<missing>      42 hours ago   ENTRYPOINT ["/docker-entrypoint.sh"]            0B        buildkit.dockerfile.v0
<missing>      42 hours ago   COPY 30-tune-worker-processes.sh /docker-ent…   16.4kB    buildkit.dockerfile.v0
<missing>      42 hours ago   COPY 20-envsubst-on-templates.sh /docker-ent…   12.3kB    buildkit.dockerfile.v0
<missing>      42 hours ago   COPY 15-local-resolvers.envsh /docker-entryp…   12.3kB    buildkit.dockerfile.v0
<missing>      42 hours ago   COPY 10-listen-on-ipv6-by-default.sh /docker…   12.3kB    buildkit.dockerfile.v0
<missing>      42 hours ago   COPY docker-entrypoint.sh / # buildkit          8.19kB    buildkit.dockerfile.v0
<missing>      42 hours ago   RUN /bin/sh -c set -x     && groupadd --syst…   87.1MB    buildkit.dockerfile.v0
<missing>      42 hours ago   ENV DYNPKG_RELEASE=1~trixie                     0B        buildkit.dockerfile.v0
<missing>      42 hours ago   ENV PKG_RELEASE=1~trixie                        0B        buildkit.dockerfile.v0
<missing>      42 hours ago   ENV ACME_VERSION=0.4.1                          0B        buildkit.dockerfile.v0
<missing>      42 hours ago   ENV NJS_RELEASE=1~trixie                        0B        buildkit.dockerfile.v0
<missing>      42 hours ago   ENV NJS_VERSION=0.9.9                           0B        buildkit.dockerfile.v0
<missing>      42 hours ago   ENV NGINX_VERSION=1.31.2                        0B        buildkit.dockerfile.v0
<missing>      42 hours ago   LABEL maintainer=NGINX Docker Maintainers <d…   0B        buildkit.dockerfile.v0
<missing>      9 days ago     # debian.sh --arch 'amd64' out/ 'trixie' '@1…   87.4MB    debuerreotype 0.17
```

---

## What are Docker Layers?

Docker images are composed of multiple read-only layers stacked on top of each other.

Each Dockerfile instruction creates a new layer.

### Benefits of Layers

* Faster image builds
* Layer reuse across images
* Reduced storage consumption
* Faster image downloads

### Layer Structure

```text
Base OS Layer
      ↓
Package Layer
      ↓
Application Layer
      ↓
Configuration Layer
```

---

# Task 3: Container Lifecycle

## Create Container

```bash
sudo docker create --name my-nginx nginx
```

Container State:

```text
Created
```

---

## Start Container

```bash
sudo docker start my-nginx
```

Container State:

```text
Running
```

---

## Pause Container

```bash
sudo docker pause my-nginx
```

Container State:

```text
Paused
```

---

## Unpause Container

```bash
sudo docker unpause my-nginx
```

Container State:

```text
Running
```

---

## Stop Container

```bash
sudo docker stop my-nginx
```

Container State:

```text
Exited
```

---

## Restart Container

```bash
sudo docker restart my-nginx
```

Container State:

```text
Running
```

---

## Kill Container

```bash
sudo docker kill my-nginx
```

Container State:

```text
Exited
```

---

## Remove Container

```bash
sudo docker rm my-nginx
```

Container State:

```text
Removed
```

---

## Container Lifecycle Flow

```text
CREATE
   ↓
START
   ↓
RUNNING
 ↙      ↘
PAUSE   STOP
 ↓        ↓
UNPAUSE EXITED
          ↓
       RESTART
          ↓
       RUNNING
          ↓
         KILL
          ↓
        REMOVE
```

---

# Task 4: Working with Running Containers

## Run Nginx Container

```bash
sudo docker run -d --name webserver -p 8080:80 nginx
```

---

## View Logs

```bash
sudo docker logs webserver
```

---

## View Real-Time Logs

```bash
sudo docker logs -f webserver
```

---

## Enter Running Container

```bash
sudo docker exec -it webserver bash
```

---

## Execute Command Without Entering

```bash
sudo docker exec webserver ls /usr/share/nginx/html
```

---

## Inspect Container

```bash
sudo docker inspect webserver
```

### Useful Information Found

* Container IP Address
* Port Mappings
* Mount Points
* Container State
* Network Configuration

### Get Container IP Directly

```bash
sudo docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' webserver
```

---

# Task 5: Cleanup

## Stop All Running Containers

```bash
sudo docker stop $(docker ps -q)
```

---

## Remove All Stopped Containers

```bash
sudo docker container prune -f
```

---

## Remove Unused Images

```bash
sudo docker image prune -a -f
```

---

## Check Docker Disk Usage

```bash
sudo docker system df
```

---

## Full Cleanup

```bash
sudo docker system prune -a
```

---

# Key Learnings

## 1. Image vs Container

An Image is a blueprint/template, while a Container is a running instance of that image.

```text
Image → Class
Container → Object
```

---

## 2. Docker Layers

Docker stores images as layers to improve efficiency, reduce storage usage, and speed up builds.

---

## 3. Container Lifecycle

A container moves through multiple states:

```text
Create → Start → Run → Pause → Stop → Restart → Kill → Remove
```

Understanding these states is critical for troubleshooting and managing production workloads.

---

# Commands Practiced Today

```bash
docker pull
docker images
docker inspect
docker image history
docker create
docker start
docker pause
docker unpause
docker stop
docker restart
docker kill
docker rm
docker logs
docker logs -f
docker exec
docker system df
docker image prune
docker container prune
docker system prune
```

---

# Conclusion

Today I learned how Docker images are built using layers, how containers move through different lifecycle states, and how to inspect, manage, troubleshoot, and clean up Docker resources effectively. Understanding these fundamentals is essential before moving toward Dockerfiles, custom images, Docker Compose, and Kubernetes.
