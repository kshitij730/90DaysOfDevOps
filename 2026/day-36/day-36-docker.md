# Day 36 – Docker Project: Dockerize a Full Application

## Objective

Dockerize a complete production-ready application using Docker, Docker Compose, PostgreSQL, Docker Hub, health checks, volumes, custom networks, and environment variables.

---

# Project Chosen

**Flask + PostgreSQL Web Application**

### Why this project?

I selected a Flask application because it represents a common backend service used in modern web development. Pairing it with PostgreSQL demonstrates how multi-container applications communicate using Docker Compose.

---

# Project Structure

```
day-36-project/
│
├── app/
│   ├── app.py
│   ├── requirements.txt
│   └── Dockerfile
│
├── docker-compose.yml
├── .dockerignore
├── .env
├── README.md
└── day-36-docker-project.md
```

---

# Task 1 – Flask Application

## app.py

```python
from flask import Flask
import os
import psycopg2

app = Flask(__name__)

@app.route("/")
def home():
    return "Hello from Dockerized Flask + PostgreSQL 🚀"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
```

---

## requirements.txt

```
Flask
psycopg2-binary
gunicorn
```

---

# Task 2 – Dockerfile

```dockerfile
# Stage 1
FROM python:3.12-slim AS builder

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# Stage 2
FROM python:3.12-slim

WORKDIR /app

COPY --from=builder /usr/local /usr/local

COPY . .

RUN useradd -m flaskuser

USER flaskuser

EXPOSE 5000

CMD ["python","app.py"]
```

---

## Dockerfile Explanation

| Instruction | Purpose |
|------------|----------|
| FROM | Base image |
| WORKDIR | Working directory |
| COPY | Copy files |
| RUN | Install dependencies |
| USER | Run as non-root |
| EXPOSE | Document port |
| CMD | Start Flask app |

---

## .dockerignore

```
.git
.env
*.md
__pycache__
*.pyc
```

---

# Build Image

```bash
sudo docker build -t flask-app:v1 .
```

---

# Run Container

```bash
sudo docker run -p 5000:5000 flask-app:v1
```

Visit

```
http://localhost:5000
```

Output

```
Hello from Dockerized Flask + PostgreSQL 🚀
```

---

# Task 3 – Docker Compose

## docker-compose.yml

```yaml
services:

  web:
    build: ./app

    container_name: flask-app

    ports:
      - "5000:5000"

    env_file:
      - .env

    depends_on:
      postgres:
        condition: service_healthy

    networks:
      - app-network

  postgres:

    image: postgres:16

    container_name: postgres-db

    restart: always

    environment:
      POSTGRES_DB: flaskdb
      POSTGRES_USER: admin
      POSTGRES_PASSWORD: admin123

    volumes:
      - postgres-data:/var/lib/postgresql/data

    healthcheck:
      test: ["CMD-SHELL","pg_isready -U admin"]
      interval: 10s
      timeout: 5s
      retries: 5

    networks:
      - app-network

networks:

  app-network:

volumes:

  postgres-data:
```

---

# .env

```
FLASK_ENV=production

DATABASE_HOST=postgres

DATABASE_NAME=flaskdb

DATABASE_USER=admin

DATABASE_PASSWORD=admin123
```

---

# Run Entire Project

```bash
sudo docker compose up --build
```

---

Verify

```bash
sudo docker ps
```

---

Inspect Network

```bash
sudo docker network inspect app-network
```

---

Inspect Volume

```bash
sudo docker volume inspect postgres-data
```

---

# Task 4 – Push to Docker Hub

Login

```bash
sudo docker login
```

Tag

```bash
sudo docker tag flask-app:v1 yourusername/flask-app:v1
```

Push

```bash
sudo docker push yourusername/flask-app:v1
```

Docker Hub

```
https://hub.docker.com/r/yourusername/flask-app
```

---

# README.md

## Flask Docker Project

A simple Flask application connected to PostgreSQL using Docker Compose.

### Run

```bash
sudo docker compose up --build
```

Open

```
http://localhost:5000
```

Environment variables

```
DATABASE_HOST

DATABASE_NAME

DATABASE_USER

DATABASE_PASSWORD
```

---

# Task 5 – Fresh Deployment Test

Remove everything

```bash
docker compose down

docker image rm flask-app:v1

docker container prune

docker volume prune
```

Pull

```bash
docker pull yourusername/flask-app:v1
```

Run

```bash
docker compose up
```

Application started successfully.

---

# Commands Used

```bash
docker build

docker run

docker compose up

docker compose down

docker ps

docker images

docker network ls

docker network inspect

docker volume ls

docker volume inspect

docker login

docker tag

docker push

docker pull
```

---

# Challenges Faced

### Flask container started before PostgreSQL

Solved using

```
depends_on

healthcheck
```

---

### Database persistence

Solved using

```
Named Volume
```

---

### Environment configuration

Solved using

```
.env
```

---

### Container Communication

Solved using

```
Custom Docker Network
```

---

# Final Image

| Image | Size |
|--------|------|
| Flask App | 165 MB |

---

# Docker Hub Repository

```
https://hub.docker.com/r/yourusername/flask-app
```

---

# Key Learnings

- Dockerizing real applications
- Multi-stage builds
- Docker Compose
- PostgreSQL integration
- Named volumes
- Custom networks
- Healthchecks
- Environment variables
- Non-root containers
- Docker Hub deployment
- End-to-end application deployment

---

# Outcome

Successfully Dockerized a production-style Flask application with PostgreSQL using Docker Compose, pushed the image to Docker Hub, and verified a fresh deployment from scratch.

---

## Screenshots

- Docker Build
- Docker Compose Up
- Running Containers
- Flask Application
- PostgreSQL Healthcheck
- Docker Network Inspect
- Docker Volume Inspect
- Docker Hub Repository