# Day 31 – Dockerfile: Build Your Own Images

## Objective

Learn how to create custom Docker images using Dockerfiles, understand common Dockerfile instructions, compare CMD vs ENTRYPOINT, build a simple web application image, use .dockerignore, and optimize Docker builds with caching.

---

# Task 1: Your First Dockerfile

## Create Project Directory

```bash
mkdir my-first-image
cd my-first-image
```

## Dockerfile

```dockerfile
FROM ubuntu:latest

RUN apt-get update && apt-get install -y curl

CMD ["echo", "Hello from my custom image!"]
```

## Build Image

```bash
sudo docker build -t my-ubuntu:v1 .
```

## Run Container

```bash
sudo docker run my-ubuntu:v1
```

### Output

```text
Hello from my custom image!
```

### What I Learned

* FROM selects the base image.
* RUN executes commands during image build.
* CMD defines the default command when the container starts.

---

# Task 2: Dockerfile Instructions

## Project Structure

```text
dockerfile-demo/
├── Dockerfile
└── app.txt
```

## app.txt

```text
Dockerfile Demo Application
```

## Dockerfile

```dockerfile
FROM ubuntu:latest

RUN apt-get update && apt-get install -y curl

WORKDIR /app

COPY app.txt .

EXPOSE 8080

CMD ["cat", "app.txt"]
```

## Build Image

```bash
sudo docker build -t dockerfile-demo:v1 .
```

## Run Container

```bash
sudo docker run dockerfile-demo:v1
```

### Output

```text
Dockerfile Demo Application
```

### Instruction Summary

| Instruction | Purpose                       |
| ----------- | ----------------------------- |
| FROM        | Base image                    |
| RUN         | Execute commands during build |
| COPY        | Copy files into image         |
| WORKDIR     | Set working directory         |
| EXPOSE      | Document container port       |
| CMD         | Default startup command       |

---

# Task 3: CMD vs ENTRYPOINT

## CMD Example

### Dockerfile

```dockerfile
FROM alpine

CMD ["echo", "hello"]
```

### Build

```bash
sudo docker build -t cmd-demo .
```

### Run

```bash
sudo docker run cmd-demo
```

Output:

```text
hello
```

### Override CMD

```bash
sudo docker run cmd-demo ls
```

Output:

```text
bin
etc
usr
...
```

CMD is replaced by the new command.

---

## ENTRYPOINT Example

### Dockerfile

```dockerfile
FROM alpine

ENTRYPOINT ["echo"]
```

### Build

```bash
sudo docker build -t entry-demo .
```

### Run

```bash
sudo docker run entry-demo hello
```

Output:

```text
hello
```

### Run With Arguments

```bash
sudo docker run entry-demo Docker Rocks!
```

Output:

```text
Docker Rocks!
```

ENTRYPOINT remains fixed and additional arguments are appended.

---

## CMD vs ENTRYPOINT Notes

### Use CMD When

* Default command should be easily replaceable.
* Running different commands with the same image.

### Use ENTRYPOINT When

* Container should always execute a specific program.
* Building CLI-style containers.

---

# Task 4: Build a Simple Web App Image

## index.html

```html
<!DOCTYPE html>
<html>
<head>
    <title>My Website</title>
</head>
<body>
    <h1>Welcome to My Docker Website</h1>
    <p>Day 31 Dockerfile Challenge Completed.</p>
</body>
</html>
```

## Dockerfile

```dockerfile
FROM nginx:alpine

COPY index.html /usr/share/nginx/html/index.html
```

## Build Image

```bash
sudo docker build -t my-website:v1 .
```

## Run Container

```bash
sudo docker run -d -p 8080:80 --name my-website my-website:v1
```

## Verify

Open browser:

```text
http://localhost:8080
```

### Result

Custom HTML page is displayed successfully.

---

# Task 5: .dockerignore

## .dockerignore

```text
node_modules
.git
*.md
.env
```

## Build Image

```bash
sudo docker build -t ignore-demo:v1 .
```

## Verification

Ignored files are excluded from the build context and not copied into the image.

### Benefits

* Smaller image size
* Faster builds
* Improved security

---

# Task 6: Build Optimization

## Initial Dockerfile

```dockerfile
FROM ubuntu

COPY . .

RUN apt-get update
```

Any source code change invalidates cache and rebuilds everything.

---

## Optimized Dockerfile

```dockerfile
FROM ubuntu

RUN apt-get update

COPY . .
```

Docker reuses cached layers when source files haven't changed.

---

## Why Layer Order Matters

Docker builds images layer by layer.

* Layers are cached.
* If a layer changes, all subsequent layers rebuild.
* Frequently changing files should be copied later.
* Stable dependencies should be installed earlier.

### Benefits

* Faster builds
* Better cache reuse
* Reduced development time
* Improved CI/CD performance

---

# Key Takeaways

✅ Dockerfiles define how custom images are built.

✅ Common instructions include FROM, RUN, COPY, WORKDIR, EXPOSE, CMD, and ENTRYPOINT.

✅ CMD can be overridden at runtime.

✅ ENTRYPOINT creates fixed container behavior.

✅ Nginx can serve static websites easily.

✅ .dockerignore reduces build context size.

✅ Docker layer caching significantly improves build speed.

---

# Screenshots to Capture

1. Building `my-ubuntu:v1`
2. Running custom image
3. CMD vs ENTRYPOINT demonstration
4. Building `my-website:v1`
5. Website running in browser
6. `.dockerignore` usage
7. Docker cache demonstration

---

## Repository Structure

```text
2026/
└── day-31/
    ├── day-31-dockerfile.md
    ├── my-first-image/
    │   └── Dockerfile
    ├── dockerfile-demo/
    │   ├── Dockerfile
    │   └── app.txt
    ├── cmd-demo/
    │   └── Dockerfile
    ├── entry-demo/
    │   └── Dockerfile
    ├── my-website/
    │   ├── Dockerfile
    │   └── index.html
    └── .dockerignore
```
