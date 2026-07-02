# Docker Cheat Sheet

A quick reference for the most commonly used Docker commands.

---

# Container Commands

| Command | Description |
|----------|-------------|
| docker run image | Run a container |
| docker run -it ubuntu bash | Interactive container |
| docker run -d nginx | Detached mode |
| docker ps | Running containers |
| docker ps -a | All containers |
| docker stop container | Stop container |
| docker start container | Start stopped container |
| docker restart container | Restart container |
| docker pause container | Pause container |
| docker unpause container | Resume paused container |
| docker kill container | Force stop container |
| docker rm container | Remove container |
| docker exec -it container bash | Enter running container |
| docker exec container command | Run one command |
| docker logs container | View logs |
| docker logs -f container | Follow logs |
| docker inspect container | Inspect container details |

---

# Image Commands

| Command | Description |
|----------|-------------|
| docker images | List images |
| docker pull nginx | Download image |
| docker build -t app:v1 . | Build image |
| docker tag app:v1 user/app:v1 | Tag image |
| docker push user/app:v1 | Push image |
| docker pull user/app:v1 | Pull image |
| docker rmi image | Remove image |
| docker image history image | Show image layers |
| docker image inspect image | Inspect image |

---

# Volume Commands

| Command | Description |
|----------|-------------|
| docker volume create volume-name | Create volume |
| docker volume ls | List volumes |
| docker volume inspect volume-name | Inspect volume |
| docker volume rm volume-name | Delete volume |

Mount Volume

```bash
-v volume-name:/container/path
```

Bind Mount

```bash
-v /host/path:/container/path
```

---

# Network Commands

| Command | Description |
|----------|-------------|
| docker network ls | List networks |
| docker network create app-net | Create network |
| docker network inspect app-net | Inspect network |
| docker network connect app-net container | Connect container |

---

# Docker Compose Commands

| Command | Description |
|----------|-------------|
| docker compose up | Start services |
| docker compose up -d | Detached mode |
| docker compose down | Stop & remove |
| docker compose down -v | Remove containers & volumes |
| docker compose ps | Running services |
| docker compose logs | View logs |
| docker compose logs -f | Follow logs |
| docker compose build | Build images |
| docker compose up --build | Rebuild & run |
| docker compose config | Validate compose file |

---

# Cleanup Commands

| Command | Description |
|----------|-------------|
| docker container prune | Remove stopped containers |
| docker image prune -a | Remove unused images |
| docker volume prune | Remove unused volumes |
| docker network prune | Remove unused networks |
| docker system prune -a | Remove everything unused |
| docker system df | Check Docker disk usage |

---

# Dockerfile Instructions

## FROM

Base image

```dockerfile
FROM python:3.12-slim
```

---

## WORKDIR

Working directory

```dockerfile
WORKDIR /app
```

---

## COPY

Copy local files

```dockerfile
COPY . .
```

---

## ADD

Copy + download/extract archives

```dockerfile
ADD file.tar.gz /
```

---

## RUN

Execute build commands

```dockerfile
RUN apt update && apt install curl -y
```

---

## EXPOSE

Document application port

```dockerfile
EXPOSE 5000
```

---

## CMD

Default command

```dockerfile
CMD ["python","app.py"]
```

---

## ENTRYPOINT

Main executable

```dockerfile
ENTRYPOINT ["python"]
```

---

## USER

Run as non-root

```dockerfile
USER appuser
```

---

# Most Useful Docker Commands

```bash
docker run

docker ps

docker images

docker build

docker pull

docker push

docker exec

docker logs

docker inspect

docker compose up

docker compose down

docker system df

docker system prune -a
```

---

# Docker Lifecycle

```
Dockerfile
      ↓
docker build
      ↓
Image
      ↓
docker run
      ↓
Container
      ↓
Start → Stop → Restart → Remove
```

---

# Best Practices

- Use Alpine or Slim images
- Don't use latest tag
- Use Multi-stage builds
- Run as non-root user
- Use .dockerignore
- Use named volumes
- Use healthchecks
- Use Docker Compose
- Keep images small
- Push versioned images to Docker Hub

---

# Docker Hub Workflow

```
docker login

↓

docker build

↓

docker tag

↓

docker push

↓

docker pull
```

---

# Remember

Container = Running Instance

Image = Blueprint

Volume = Persistent Storage

Network = Communication

Compose = Multi-container Management