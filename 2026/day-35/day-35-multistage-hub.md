# Day 35 – Multi-Stage Builds & Docker Hub

## Objective

Learn how to build optimized Docker images using Multi-Stage Builds and publish them on Docker Hub.

---

# Task 1 – Single Stage Build

## Project Structure

```
hello-node/
│── app.js
│── package.json
└── Dockerfile.single
```

### app.js

```javascript
console.log("Hello from Docker Multi-Stage Build!");
```

### package.json

```json
{
  "name": "hello-node",
  "version": "1.0.0",
  "main": "app.js"
}
```

### Dockerfile.single

```dockerfile
FROM node:22

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

CMD ["node", "app.js"]
```

---

## Build Image

```bash
sudo docker build -f Dockerfile.single -t hello-node:single .
```

---

## Check Image Size

```bash
sudo docker images
```

Example

| Image | Size |
|--------|------|
| hello-node:single | 1.63 GB |

---

## Run Container

```bash
sudo docker run --rm hello-node:single
```

Output

```
Hello from Docker Multi-Stage Build!
```

---

# Task 2 – Multi-Stage Build

## Dockerfile

```dockerfile
# Build Stage
FROM node:22 AS builder

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

# Production Stage
FROM node:22-alpine

WORKDIR /app

COPY --from=builder /app .

CMD ["node", "app.js"]
```

---

## Build

```bash
sudo docker build -t hello-node:multi .
```

---

## Run

```bash
sudo docker run --rm hello-node:multi
```

Output

```
Hello from Docker Multi-Stage Build!
```

---

## Compare Image Sizes

| Image | Approx Size |
|--------|-------------|
| Single Stage | 1.63 GB |
| Multi Stage | 230 MB |

---

### Why is Multi-Stage Smaller?

- Build dependencies are discarded.
- Only application files are copied.
- Final image uses Alpine Linux.
- Smaller images pull faster.
- Reduced attack surface.
- Better for production deployments.

---

# Task 3 – Push to Docker Hub

## Login

```bash
sudo docker login
```

---

## Tag Image

```bash
docker tag hello-node:multi <dockerhub-username>/hello-node:v1
```

Example

```bash
sudo docker tag hello-node:multi johndoe/hello-node:v1
```

---

## Push

```bash
docker push <dockerhub-username>/hello-node:v1
```

---

## Verify

Remove local image

```bash
sudo docker rmi <dockerhub-username>/hello-node:v1
```

Pull again

```bash
sudo docker pull <dockerhub-username>/hello-node:v1
```

Run

```bash
sudo docker run --rm <dockerhub-username>/hello-node:v1
```

Output

```
Hello from Docker Multi-Stage Build!
```

---

# Task 4 – Docker Hub Repository

Verified:

- Repository successfully created.
- Added repository description.
- Verified image tags.
- Pulled image using version tag.
- Pulled latest image.

Commands

```bash
docker pull username/hello-node:v1

docker pull username/hello-node:latest
```

Observation

- `latest` always downloads the newest tagged image.
- Specific tags download that exact version.

---

# Task 5 – Image Best Practices

## Optimized Dockerfile

```dockerfile
FROM node:22-alpine

WORKDIR /app

COPY package*.json ./

RUN npm install --omit=dev \
    && addgroup -S appgroup \
    && adduser -S appuser -G appgroup

COPY . .

USER appuser

CMD ["node", "app.js"]
```

---

## Best Practices Applied

- Used Alpine base image.
- Used specific image tag.
- Created non-root user.
- Combined RUN commands.
- Reduced image size.
- Improved security.
- Production-ready image.

---

# Commands Used

```bash
docker build

docker images

docker run

docker login

docker tag

docker push

docker pull

docker history

docker image inspect
```

---

# Key Learnings

- Multi-stage builds produce much smaller images.
- Alpine significantly reduces image size.
- Docker Hub enables image sharing across systems.
- Specific image tags improve version control.
- Running containers as non-root enhances security.
- Combining RUN instructions reduces image layers.
- Multi-stage builds improve deployment speed and security.

---

# Outcome

Successfully built:

- Single-stage Docker image
- Multi-stage optimized Docker image
- Published image to Docker Hub
- Applied Docker image best practices
- Verified image pull from Docker Hub

---

## Screenshots

- Single-stage image build
- Multi-stage image build
- Image size comparison
- Docker login
- Docker push
- Docker Hub repository
- Docker pull verification
- Optimized Dockerfile