# Day 34 – Docker Compose: Real-World Multi-Container Apps

## Objective
Learn to build production-like multi-container applications using Docker Compose with custom Dockerfiles, healthchecks, restart policies, named networks, and persistent volumes.

---

# Task 1: Build Your Own App Stack

## Project Structure

```
day-34/
│── app/
│   ├── app.py
│   ├── requirements.txt
│   └── Dockerfile
│
├── docker-compose.yml
└── .env
```

---

## app.py

```python
from flask import Flask
import os

app = Flask(__name__)

@app.route("/")
def home():
    return f"""
    <h1>Day 34 Docker Compose</h1>
    <h2>Flask + PostgreSQL + Redis</h2>
    <p>Database Host: {os.getenv("DB_HOST")}</p>
    <p>Redis Host: {os.getenv("REDIS_HOST")}</p>
    """

app.run(host="0.0.0.0", port=5000)
```

---

## requirements.txt

```
flask
psycopg2-binary
redis
```

---

## Dockerfile

```Dockerfile
FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 5000

CMD ["python","app.py"]
```

---

# Task 2: docker-compose.yml

```yaml
version: "3.9"

services:

  web:
    build: ./app
    container_name: flask-app

    ports:
      - "5000:5000"

    environment:
      DB_HOST: postgres
      DB_NAME: mydb
      DB_USER: admin
      DB_PASSWORD: password
      REDIS_HOST: redis

    depends_on:
      postgres:
        condition: service_healthy

    restart: always

    networks:
      - app-network

    labels:
      project: day34
      service: web

  postgres:
    image: postgres:16

    container_name: postgres-db

    environment:
      POSTGRES_DB: mydb
      POSTGRES_USER: admin
      POSTGRES_PASSWORD: password

    volumes:
      - postgres-data:/var/lib/postgresql/data

    restart: always

    healthcheck:
      test: ["CMD-SHELL","pg_isready -U admin"]
      interval: 10s
      timeout: 5s
      retries: 5

    networks:
      - app-network

    labels:
      service: database

  redis:
    image: redis:7-alpine

    container_name: redis-cache

    restart: always

    networks:
      - app-network

    labels:
      service: cache

volumes:
  postgres-data:

networks:
  app-network:
    driver: bridge
```

---

# Task 3: Start the Stack

```bash
sudo docker compose up -d --build
```

---

## Verify

```bash
sudo docker ps
```

Output

```
flask-app
postgres-db
redis-cache
```

---

Access

```
http://<EC2-Public-IP>:5000
```

Expected

```
Day 34 Docker Compose

Flask + PostgreSQL + Redis

Database Host: postgres

Redis Host: redis
```

---

# Task 4: depends_on & Healthcheck

Database starts first.

Docker waits until PostgreSQL becomes healthy.

Only then Flask starts.

Verify

```bash
sudo docker compose ps
```

Check health

```bash
sudo docker inspect postgres-db
```

Health Status

```
healthy
```

---

# Task 5: Restart Policies

Restart Database

```bash
sudo docker kill postgres-db
```

Output

```
postgres-db
```

After few seconds

```bash
sudo docker ps
```

Database automatically starts again because

```
restart: always
```

Difference

| Restart Policy | Behaviour |
|---------------|-----------|
| always | Restart every time |
| on-failure | Restart only if container crashes |
| unless-stopped | Restart except when manually stopped |
| no | Never restart |

---

# Task 6: Custom Dockerfile Build

Rebuild after changing code

```bash
sudo docker compose up --build -d
```

Docker rebuilds Flask image and starts updated container.

---

# Task 7: Named Volumes

List volumes

```bash
sudo docker volume ls
```

Inspect

```bash
sudo docker volume inspect day-34_postgres-data
```

Data remains even after container removal.

---

# Task 8: Custom Network

List networks

```bash
sudo docker network ls
```

Inspect

```bash
sudo docker network inspect app-network
```

All three containers belong to the same network.

Containers communicate using service names.

```
postgres

redis

web
```

---

# Task 9: Scaling (Bonus)

Scale Flask

```bash
sudo docker compose up --scale web=3
```

Observation

- Three Flask containers start.
- Only one container can bind to port 5000.
- Remaining replicas cannot expose the same host port.
- In production this is solved using a Load Balancer or Reverse Proxy (e.g., Nginx).

---

# Useful Commands

Build

```bash
docker compose up --build
```

Detached Mode

```bash
docker compose up -d
```

Logs

```bash
docker compose logs -f
```

Logs of Web Service

```bash
docker compose logs web
```

Stop

```bash
docker compose stop
```

Remove

```bash
docker compose down
```

Remove Volumes

```bash
docker compose down -v
```

List Containers

```bash
docker compose ps
```

---

# Key Learnings

- Built a complete 3-service application using Docker Compose.
- Used a custom Dockerfile with the build option.
- Configured PostgreSQL health checks.
- Used depends_on with service_healthy.
- Implemented restart policies.
- Used named volumes for persistent database storage.
- Created a custom bridge network.
- Added labels for better organization.
- Learned why scaling with port mapping requires a reverse proxy or load balancer.

---

## Conclusion

Day 34 focused on building production-like Docker Compose environments. By combining a Flask application, PostgreSQL database, and Redis cache, I learned how modern applications are orchestrated using health checks, restart policies, named volumes, custom networks, and service dependencies. These concepts form the foundation for deploying scalable applications before moving on to Kubernetes.