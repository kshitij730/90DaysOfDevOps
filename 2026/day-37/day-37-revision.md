# Day 37 – Docker Revision

## Objective

Revise everything learned from Day 29 to Day 36 and evaluate practical Docker skills.

---

# Self Assessment

| Skill | Status |
|--------|--------|
| Run containers (interactive & detached) | ✅ Can Do |
| Manage containers & images | ✅ Can Do |
| Explain Docker image layers | ✅ Can Do |
| Write Dockerfile from scratch | ✅ Can Do |
| CMD vs ENTRYPOINT | ✅ Can Do |
| Build & tag custom image | ✅ Can Do |
| Named Volumes | ✅ Can Do |
| Bind Mounts | ✅ Can Do |
| Custom Networks | ✅ Can Do |
| Docker Compose | ✅ Can Do |
| Environment Variables | ✅ Can Do |
| Multi-stage Builds | ✅ Can Do |
| Push images to Docker Hub | ✅ Can Do |
| Healthchecks & depends_on | ✅ Can Do |

---

# Quick Fire Questions

## 1. Difference between Image and Container?

**Image**

- Read-only template
- Blueprint for containers

**Container**

- Running instance of an image
- Has writable layer
- Can be started, stopped, or removed

---

## 2. What happens when a container is removed?

Without a volume:

- All container data is deleted.

With a named volume:

- Data remains persistent.

---

## 3. How do containers communicate on a custom network?

Containers communicate using:

- Container Name
- Service Name (Docker Compose)

Docker provides built-in DNS resolution.

---

## 4. Difference between

```
docker compose down
```

and

```
docker compose down -v
```

### down

Removes

- Containers
- Networks

Volumes remain.

### down -v

Removes

- Containers
- Networks
- Named Volumes

Database data is deleted.

---

## 5. Why Multi-stage Builds?

- Smaller images
- Better security
- Faster deployment
- Removes build dependencies
- Production-ready images

---

## 6. Difference between COPY and ADD

COPY

- Copies local files

ADD

- Copies files
- Downloads URLs
- Extracts archives

COPY is preferred in most cases.

---

## 7. Meaning of

```
-p 8080:80
```

Host Port

```
8080
```

↓

Container Port

```
80
```

Browser

```
localhost:8080
```

↓

Nginx

```
80
```

---

## 8. Check Docker Disk Usage

```bash
docker system df
```

---

# Weak Areas Revisited

## Topic 1

Docker Compose

Practiced

- Compose Up
- Compose Down
- Compose Logs
- Compose Build

Result

Successfully deployed multi-container applications.

---

## Topic 2

Multi-stage Builds

Practiced

- Single Stage
- Multi-stage Dockerfile

Observation

Image size reduced significantly.

---

# Major Topics Covered

## Docker Basics

- Images
- Containers
- Docker Hub

---

## Dockerfile

- FROM
- RUN
- COPY
- ADD
- WORKDIR
- EXPOSE
- CMD
- ENTRYPOINT
- USER

---

## Storage

- Named Volumes
- Bind Mounts

---

## Networking

- Bridge
- Custom Networks
- DNS Resolution

---

## Docker Compose

- Multi-container Applications
- Environment Variables
- Healthchecks
- Depends_on
- Restart Policies

---

## Optimization

- Multi-stage Builds
- Non-root User
- Alpine Images
- Layer Caching

---

## Docker Hub

- Login
- Tag
- Push
- Pull
- Versioning

---

# Commands Revised

```bash
docker run

docker build

docker images

docker ps

docker stop

docker rm

docker exec

docker logs

docker inspect

docker network

docker volume

docker compose

docker system df

docker system prune
```

---

# Key Takeaways

- Images are templates.
- Containers are running instances.
- Volumes persist data.
- Networks enable container communication.
- Compose manages multi-container apps.
- Multi-stage builds create lightweight images.
- Docker Hub distributes container images.
- Healthchecks improve reliability.
- Non-root containers improve security.

---

# Overall Progress

## Days Completed

✅ Day 29

✅ Day 30

✅ Day 31

✅ Day 32

✅ Day 33

✅ Day 34

✅ Day 35

✅ Day 36

---

# Revision Summary

Docker fundamentals have been successfully revised.

Confident in creating production-ready Docker applications using:

- Dockerfile
- Docker Compose
- Docker Hub
- Volumes
- Networks
- Multi-stage Builds
- Healthchecks
- Environment Variables

---

# Next Goal

➡️ Begin CI/CD (Day 38)

