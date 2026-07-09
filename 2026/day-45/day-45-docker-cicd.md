# Day 45 – Docker Build & Push in GitHub Actions

## 🎯 Objective

Today's goal was to automate the Docker image build and deployment process using GitHub Actions. Instead of manually building and pushing Docker images, I created a complete CI/CD pipeline that automatically builds, tags, and publishes Docker images to Docker Hub whenever code is pushed to the `main` branch.

---

# Task 1 – Preparation

Before creating the pipeline, I prepared the repository by adding the required application files and configuring GitHub Secrets.

## Application Used

- Flask Application (from Day 36)

## Files Added

```
Dockerfile
app.py
requirements.txt
README.md
```

## GitHub Secrets

Repository → Settings → Secrets and Variables → Actions

Created the following repository secrets:

| Secret | Purpose |
|----------|----------|
| DOCKER_USERNAME | Docker Hub Username |
| DOCKER_TOKEN | Docker Hub Personal Access Token |

These secrets are securely injected into the workflow during execution without exposing them in logs.

---

# Task 2 – Build Docker Image in CI

Created the workflow:

```
.github/workflows/docker-publish.yml
```

The workflow automatically:

- Checks out the repository
- Builds the Docker image
- Generates a short commit SHA
- Tags the image

---

## Complete Workflow

```yaml
name: Docker Build & Publish

on:
  push:
    branches:
      - main
      - feature/**
  pull_request:

env:
  IMAGE_NAME: github-actions-practice

jobs:

  docker:

    runs-on: ubuntu-latest

    permissions:
      contents: read

    steps:

      - name: Checkout Repository
        uses: actions/checkout@v4

      - name: Set Short SHA
        id: vars
        run: echo "SHORT_SHA=${GITHUB_SHA::7}" >> $GITHUB_ENV

      - name: Login to Docker Hub
        if: github.ref == 'refs/heads/main'
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_TOKEN }}

      - name: Build Docker Image
        uses: docker/build-push-action@v5
        with:
          context: .
          push: false
          tags: |
            ${{ secrets.DOCKER_USERNAME }}/${{ env.IMAGE_NAME }}:latest
            ${{ secrets.DOCKER_USERNAME }}/${{ env.IMAGE_NAME }}:sha-${{ env.SHORT_SHA }}

      - name: Push Docker Image
        if: github.ref == 'refs/heads/main'
        uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: |
            ${{ secrets.DOCKER_USERNAME }}/${{ env.IMAGE_NAME }}:latest
            ${{ secrets.DOCKER_USERNAME }}/${{ env.IMAGE_NAME }}:sha-${{ env.SHORT_SHA }}

      - name: Show Docker Hub Repository
        if: github.ref == 'refs/heads/main'
        run: |
          echo "Docker Image Published Successfully!"
          echo "https://hub.docker.com/r/${{ secrets.DOCKER_USERNAME }}/${{ env.IMAGE_NAME }}"
```

---

# Task 3 – Push Docker Image to Docker Hub

After the image was successfully built, the workflow authenticated with Docker Hub using GitHub Secrets and pushed the image automatically.

## Image Tags

```
latest

sha-72bc9f1
```

Every commit creates a unique SHA tag while the latest version is always available using the `latest` tag.

---

## Docker Hub Repository

```
https://hub.docker.com/r/<username>/github-actions-practice
```

Successfully verified that both tags appeared in Docker Hub.

---

# Task 4 – Push Only on Main Branch

Added the following condition:

```yaml
if: github.ref == 'refs/heads/main'
```

## Result

### Push to Main Branch

✔ Build Image

✔ Push Image

---

### Push to Feature Branch

✔ Build Image

❌ Skip Docker Push

This prevents unnecessary images from being published during development.

---

# Task 5 – GitHub Actions Status Badge

Added a workflow badge inside the repository README.

```markdown
![Docker Build](https://github.com/<username>/github-actions-practice/actions/workflows/docker-publish.yml/badge.svg)
```

Whenever the workflow succeeds or fails, the badge updates automatically.

---

# Task 6 – Pull and Run Docker Image

Pulled the image from Docker Hub.

```bash
docker pull <username>/github-actions-practice:latest
```

Started the container.

```bash
docker run -d -p 5000:5000 <username>/github-actions-practice:latest
```

Verified that the application was running successfully.

---

# Git Push → Running Container Journey

```
Developer writes code
        │
        ▼
git add
        │
        ▼
git commit
        │
        ▼
git push
        │
        ▼
GitHub Actions Triggered
        │
        ▼
Checkout Repository
        │
        ▼
Build Docker Image
        │
        ▼
Login to Docker Hub
        │
        ▼
Push latest Image
        │
        ▼
Push SHA Image
        │
        ▼
Docker Hub Repository Updated
        │
        ▼
Server pulls latest image
        │
        ▼
docker run
        │
        ▼
Application Running Successfully
```

---

# Workflow Features

- Automatic Build
- Automatic Docker Login
- Automatic Docker Push
- Docker Hub Integration
- Image Versioning using SHA Tags
- Latest Image Tag
- Branch Protection
- Status Badge
- Fully Automated CI/CD Pipeline

---

# Files Used

```
.
├── Dockerfile
├── app.py
├── requirements.txt
├── README.md
└── .github/
    └── workflows/
        └── docker-publish.yml
```

---

# Commands Used

## Build Image Locally

```bash
docker build -t github-actions-practice .
```

---

## Run Container

```bash
docker run -d -p 5000:5000 github-actions-practice
```

---

## Pull from Docker Hub

```bash
docker pull <username>/github-actions-practice:latest
```

---

## Run Pulled Image

```bash
docker run -d -p 5000:5000 <username>/github-actions-practice:latest
```

---

# Key Learnings

- GitHub Actions can automatically build Docker images after every push.
- Docker Hub credentials should always be stored as GitHub Secrets.
- Using SHA tags makes every Docker image uniquely identifiable.
- Branch-based conditions prevent unnecessary image publishing.
- Status badges provide quick visibility into workflow health.
- CI/CD eliminates manual deployment steps and ensures consistent builds.

---

# Screenshots to Include

- Successful GitHub Actions workflow
- Docker build logs
- Docker push logs
- Docker Hub repository with `latest` and SHA tags
- Green workflow status badge
- Running Docker container

---

# Conclusion

Day 45 was my first complete Docker CI/CD implementation using GitHub Actions.

By combining Docker, GitHub Actions, Docker Hub, GitHub Secrets, and automated workflows, I built a pipeline that automatically builds, tags, and publishes Docker images without any manual intervention.

This workflow closely resembles the CI/CD pipelines used by modern DevOps teams for containerized application delivery and gave me practical experience in automating the software release process.