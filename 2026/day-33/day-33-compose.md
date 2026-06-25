# Day 33 – Docker Compose: Multi-Container Basics

## Objective

Learn how Docker Compose simplifies running multi-container applications using a single YAML file.

---

# Task 1: Install & Verify Docker Compose

## Check Docker Compose

```bash
docker-compose --version
```

### Output

```text
Docker Compose version v5.1.1
```

Docker Compose is successfully installed and ready to use.

---

# Task 2: First Docker Compose File

## Project Structure

```
compose-basics/
│── docker-compose.yml
```

## docker-compose.yml

```yaml
version: "3.9"

services:
  nginx:
    image: nginx
    container_name: nginx-compose
    ports:
      - "8080:80"
```

## Start Services

```bash
docker compose up -d
```

## Verify Running Containers

```bash
docker compose ps
```

## Access Browser

```
http://<EC2-Public-IP>:8080
```

The default Nginx page loads successfully.

## Stop & Remove

```bash
docker compose down
```

---

# Task 3: WordPress + MySQL Setup

## docker-compose.yml

```yaml
version: "3.9"

services:

  db:
    image: mysql:8.0
    container_name: mysql-db

    restart: always

    environment:
      MYSQL_ROOT_PASSWORD: root123
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wpuser
      MYSQL_PASSWORD: wp123

    volumes:
      - mysql-data:/var/lib/mysql

  wordpress:
    image: wordpress
    container_name: wordpress-app

    restart: always

    depends_on:
      - db

    ports:
      - "8081:80"

    environment:
      WORDPRESS_DB_HOST: db:3306
      WORDPRESS_DB_USER: wpuser
      WORDPRESS_DB_PASSWORD: wp123
      WORDPRESS_DB_NAME: wordpress

volumes:
  mysql-data:
```

## Start Services

```bash
docker compose up -d
```

## Verify

```bash
docker compose ps
```

## Open Browser

```
http://<EC2-Public-IP>:8081
```

WordPress installation page appears successfully.

### Persistence Test

```bash
docker compose down
docker compose up -d
```

Result:

The WordPress database and website remain intact because MySQL data is stored in the named volume.

---

# Task 4: Docker Compose Commands

## Start in Detached Mode

```bash
docker compose up -d
```

---

## View Running Services

```bash
docker compose ps
```

---

## View Logs

```bash
docker compose logs
```

---

## Follow Logs

```bash
docker compose logs -f
```

---

## Logs of Specific Service

```bash
docker compose logs wordpress

docker compose logs db
```

---

## Stop Services

```bash
docker compose stop
```

---

## Remove Everything

```bash
docker compose down
```

---

## Remove Containers + Volumes

```bash
docker compose down -v
```

---

## Rebuild Images

```bash
docker compose up --build
```

---

# Task 5: Environment Variables

## Create .env

```env
MYSQL_ROOT_PASSWORD=root123
MYSQL_DATABASE=wordpress
MYSQL_USER=wpuser
MYSQL_PASSWORD=wp123
```

## docker-compose.yml

```yaml
services:

  db:
    image: mysql:8

    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      MYSQL_DATABASE: ${MYSQL_DATABASE}
      MYSQL_USER: ${MYSQL_USER}
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}
```

## Verify

```bash
docker compose config
```

Docker correctly substitutes variables from the `.env` file.

---

# Project Structure

```
day-33/

│── docker-compose.yml
│── .env
│── day-33-compose.md
```

---

# Key Learnings

## Docker Compose

* Uses a single YAML file to define multiple containers.
* Automatically creates networks.
* Automatically connects services.
* Starts the complete application using one command.

---

## Benefits

✅ One command deployment

✅ Automatic networking

✅ Named volumes

✅ Easy environment management

✅ Better project organization

---

## Useful Commands

```bash
docker compose up -d

docker compose down

docker compose ps

docker compose logs

docker compose logs -f

docker compose stop

docker compose restart

docker compose up --build

docker compose config
```

---

# Conclusion

Docker Compose makes multi-container applications simple and reproducible.

Instead of manually creating networks, volumes, and containers, everything can be managed declaratively inside a single `docker-compose.yml` file.

This is the standard approach for local development and forms the foundation for deploying modern containerized applications.

---

**#90DaysOfDevOps #DevOpsKaJosh #TrainWithShubham**
