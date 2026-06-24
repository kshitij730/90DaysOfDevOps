# Day 32 – Docker Volumes & Networking

## Objective

Learn how Docker handles persistent storage and container-to-container communication using volumes and networks.

---

# Task 1: The Problem (Data Loss Without Volumes)

## Run PostgreSQL Container

```bash
docker run -d \
--name postgres-db \
-e POSTGRES_PASSWORD=admin123 \
postgres
```

## Create Sample Data

```bash
docker exec -it postgres-db psql -U postgres
```

Inside PostgreSQL:

```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50)
);

INSERT INTO users(name)
VALUES ('Shubham'),
       ('DevOps');

SELECT * FROM users;
```

## Remove Container

```bash
docker stop postgres-db
docker rm postgres-db
```

## Create New Container

```bash
docker run -d \
--name postgres-db-new \
-e POSTGRES_PASSWORD=admin123 \
postgres
```

## Observation

After entering PostgreSQL again:

```sql
SELECT * FROM users;
```

Result:

```text
ERROR: relation "users" does not exist
```

### Why?

Containers are ephemeral.

When the original container was removed, its writable layer was deleted as well, causing all stored data to disappear.

---

# Task 2: Named Volumes

## Create Volume

```bash
docker volume create postgres-data
```

## Verify

```bash
docker volume ls
```

## Run PostgreSQL With Volume

```bash
docker run -d \
--name postgres-db \
-e POSTGRES_PASSWORD=admin123 \
-v postgres-data:/var/lib/postgresql/data \
postgres
```

## Create Data

```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50)
);

INSERT INTO users(name)
VALUES ('Docker'),
       ('Volume');
```

## Remove Container

```bash
docker stop postgres-db
docker rm postgres-db
```

## Create New Container Using Same Volume

```bash
docker run -d \
--name postgres-db-new \
-e POSTGRES_PASSWORD=admin123 \
-v postgres-data:/var/lib/postgresql/data \
postgres
```

## Verify Data

```sql
SELECT * FROM users;
```

Output:

```text
 id |  name
----+---------
 1  | Docker
 2  | Volume
```

### Observation

Data remained intact even after deleting the container.

Docker volume preserved the database files.

## Inspect Volume

```bash
docker volume inspect postgres-data
```

---

# Task 3: Bind Mounts

## Create Project Folder

```bash
mkdir website
cd website
```

## Create HTML File

```html
<!DOCTYPE html>
<html>
<head>
    <title>Docker Bind Mount</title>
</head>
<body>
    <h1>Hello from Host Machine!</h1>
</body>
</html>
```

## Run Nginx With Bind Mount

```bash
docker run -d \
--name nginx-bind \
-p 8080:80 \
-v $(pwd):/usr/share/nginx/html \
nginx
```

## Access Browser

```text
http://localhost:8080
```

## Edit index.html

```html
<h1>Updated Without Rebuilding Container</h1>
```

Refresh browser.

### Observation

Changes appeared instantly.

No image rebuild required.

### Named Volume vs Bind Mount

| Named Volume               | Bind Mount                    |
| -------------------------- | ----------------------------- |
| Managed by Docker          | Managed by Host OS            |
| Stored in Docker directory | Uses host filesystem directly |
| Better for databases       | Better for development        |
| Portable                   | Host-dependent                |

---

# Task 4: Docker Networking Basics

## List Networks

```bash
docker network ls
```

## Inspect Bridge Network

```bash
docker network inspect bridge
```

## Run Two Containers

```bash
docker run -dit --name container1 ubuntu bash

docker run -dit --name container2 ubuntu bash
```

## Get IP Address

```bash
docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' container2
```

Example:

```text
172.17.0.3
```

## Ping By IP

```bash
docker exec container1 ping 172.17.0.3
```

Result:

```text
Success
```

## Ping By Name

```bash
docker exec container1 ping container2
```

Result:

```text
Failed
```

### Observation

Default bridge network does not provide automatic DNS-based name resolution.

---

# Task 5: Custom Networks

## Create Custom Bridge

```bash
docker network create my-app-net
```

## Run Containers

```bash
docker run -dit \
--name app1 \
--network my-app-net \
ubuntu bash

docker run -dit \
--name app2 \
--network my-app-net \
ubuntu bash
```

## Ping By Name

```bash
docker exec app1 ping app2
```

Result:

```text
Success
```

### Why?

User-defined bridge networks include Docker DNS.

Containers automatically resolve each other's names.

---

# Task 6: Putting Everything Together

## Create Network

```bash
docker network create app-network
```

## Create Volume

```bash
docker volume create mysql-data
```

## Run MySQL Container

```bash
docker run -d \
--name mysql-db \
--network app-network \
-e MYSQL_ROOT_PASSWORD=root123 \
-v mysql-data:/var/lib/mysql \
mysql
```

## Run Application Container

```bash
docker run -dit \
--name app-container \
--network app-network \
ubuntu bash
```

## Verify Connectivity

```bash
docker exec app-container ping mysql-db
```

Output:

```text
64 bytes from mysql-db
```

### Observation

The application container successfully reached the database using the container name instead of an IP address.

This setup closely resembles real-world microservice communication.

---

# Key Learnings

### Volumes

* Containers lose data when deleted.
* Volumes persist data independently of containers.
* Ideal for databases and production workloads.

### Bind Mounts

* Directly connect host files to containers.
* Excellent for development workflows.
* Changes appear instantly.

### Networking

* Default bridge supports IP communication.
* Custom bridge networks provide automatic DNS resolution.
* Containers can communicate using container names.

### Real-World Use Case

A production application commonly uses:

* Database Container + Volume
* Application Container
* Custom Docker Network

This combination provides both persistent storage and reliable service-to-service communication.

---

# Conclusion

Today’s biggest takeaway was understanding that containers are temporary by design.

Volumes solve persistence.

Custom networks solve communication.

Together, they enable stateful applications and multi-container architectures that resemble real-world production environments.

#90DaysOfDevOps #DevOpsKaJosh #TrainWithShubham
