# Day 48 – GitHub Actions Project: End-to-End CI/CD Pipeline

## Objective

Today I combined everything learned from Day 40 to Day 47 — workflows, triggers, secrets, Docker builds, reusable workflows, and advanced events — into one complete, production-style CI/CD pipeline. The project builds, tests, and deploys a simple FastAPI health-check service using reusable workflows, PR validation, environment protection, and scheduled monitoring.

---

## Task 1 – Project Setup

### What was built?

A minimal FastAPI service with a single `/health` endpoint, containerized with Docker, forming the base application for the entire pipeline.

### Files

```text
app.py
requirements.txt
Dockerfile
test_health.sh
```

```python
# app.py
from fastapi import FastAPI
from datetime import datetime

app = FastAPI(title="Capstone Health API")

@app.get("/health")
def health():
    return {
        "status": "ok",
        "service": "github-actions-capstone",
        "time": datetime.utcnow().isoformat()
    }
```

```dockerfile
# Dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app.py .
EXPOSE 8000
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
```

```bash
# test_health.sh
#!/bin/bash
set -e

echo "Building and starting container for test..."
docker run -d --name health-test -p 8000:8000 capstone-image
sleep 4

echo "Curling /health endpoint..."
RESPONSE=$(curl -s http://localhost:8000/health)
echo "Response: $RESPONSE"

if echo "$RESPONSE" | grep -q '"status":"ok"'; then
  echo "Test passed"
  docker stop health-test && docker rm health-test
  exit 0
else
  echo "Test failed"
  docker stop health-test && docker rm health-test
  exit 1
fi
```

### Verification

* ✅ Image builds successfully
* ✅ Container runs and exposes port 8000
* ✅ `curl http://localhost:8000/health` returns `status: ok`

---

## Task 2 – Reusable Workflow: Build & Test

### What is it?

A `workflow_call`-triggered workflow that installs dependencies, builds the Docker image, and runs the health-check test — without deploying anything. Called by both the PR pipeline and the main pipeline.

### File

```text
.github/workflows/reusable-build-test.yml
```

```yaml
name: Reusable - Build & Test

on:
  workflow_call:
    inputs:
      python_version:
        required: true
        type: string
      run_tests:
        required: false
        type: boolean
        default: true
    outputs:
      test_result:
        description: "passed or failed"
        value: ${{ jobs.build-test.outputs.result }}

jobs:
  build-test:
    runs-on: ubuntu-latest
    outputs:
      result: ${{ steps.set-result.outputs.result }}
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-python@v5
        with:
          python-version: ${{ inputs.python_version }}

      - name: Install dependencies
        run: pip install -r requirements.txt

      - name: Build image for testing
        run: docker build -t capstone-image .

      - name: Run tests
        if: inputs.run_tests == true
        run: bash test_health.sh

      - name: Set result
        id: set-result
        if: always()
        run: echo "result=${{ job.status == 'success' && 'passed' || 'failed' }}" >> "$GITHUB_OUTPUT"
```

### Verification

* ✅ Runs standalone via `workflow_call`
* ✅ Output `test_result` correctly reflects passed/failed
* ✅ Does not build or push to Docker Hub

---

## Task 3 – Reusable Workflow: Docker Build & Push

### What is it?

A parameterized workflow that logs into Docker Hub and pushes the image using inputs for `image_name` and `tag`, keeping credentials in `secrets`.

### File

```text
.github/workflows/reusable-docker.yml
```

```yaml
name: Reusable - Docker Build & Push

on:
  workflow_call:
    inputs:
      image_name:
        required: true
        type: string
      tag:
        required: true
        type: string
    secrets:
      docker_username:
        required: true
      docker_token:
        required: true
    outputs:
      image_url:
        value: ${{ jobs.docker-build.outputs.url }}

jobs:
  docker-build:
    runs-on: ubuntu-latest
    outputs:
      url: ${{ steps.set-url.outputs.url }}
    steps:
      - uses: actions/checkout@v4

      - uses: docker/login-action@v3
        with:
          username: ${{ secrets.docker_username }}
          password: ${{ secrets.docker_token }}

      - uses: docker/build-push-action@v6
        with:
          context: .
          push: true
          tags: ${{ secrets.docker_username }}/${{ inputs.image_name }}:${{ inputs.tag }}

      - name: Set image URL
        id: set-url
        run: echo "url=${{ secrets.docker_username }}/${{ inputs.image_name }}:${{ inputs.tag }}" >> "$GITHUB_OUTPUT"
```

### Verification

* ✅ Logs into Docker Hub successfully using repo secrets
* ✅ Image pushed with correct tag
* ✅ Output `image_url` passed to downstream jobs

---

## Task 4 – PR Pipeline

### What is it?

Runs on `pull_request` events (`opened`, `synchronize`) targeting `main`. Calls the reusable build-test workflow only — no Docker push happens on PRs.

### File

```text
.github/workflows/pr-pipeline.yml
```

```yaml
name: PR Pipeline

on:
  pull_request:
    branches: [main]
    types: [opened, synchronize]

jobs:
  build-test:
    uses: ./.github/workflows/reusable-build-test.yml
    with:
      python_version: "3.11"
      run_tests: true

  pr-comment:
    needs: build-test
    runs-on: ubuntu-latest
    steps:
      - run: echo "PR checks passed for branch: ${{ github.head_ref }}"
```

### Verification

* ✅ Triggered on PR opened and on new commits (synchronize)
* ✅ Runs tests only, no Docker image pushed
* ✅ `pr-comment` job prints summary after tests pass

---

## Task 5 – Main Branch Pipeline

### What is it?

Runs on `push` to `main`. Chains three stages: build & test → Docker build & push (tagged `latest` and `sha-<short-hash>`) → deploy with environment protection.

### File

```text
.github/workflows/main-pipeline.yml
```

```yaml
name: Main Pipeline

on:
  push:
    branches: [main]

jobs:
  build-test:
    uses: ./.github/workflows/reusable-build-test.yml
    with:
      python_version: "3.11"
      run_tests: true

  get-sha:
    needs: build-test
    runs-on: ubuntu-latest
    outputs:
      short_sha: ${{ steps.sha.outputs.short }}
    steps:
      - id: sha
        run: echo "short=$(echo ${{ github.sha }} | cut -c1-7)" >> "$GITHUB_OUTPUT"

  docker-build:
    needs: get-sha
    uses: ./.github/workflows/reusable-docker.yml
    with:
      image_name: capstone-app
      tag: latest
    secrets:
      docker_username: ${{ secrets.DOCKER_USERNAME }}
      docker_token: ${{ secrets.DOCKER_TOKEN }}

  docker-build-sha:
    needs: get-sha
    uses: ./.github/workflows/reusable-docker.yml
    with:
      image_name: capstone-app
      tag: sha-${{ needs.get-sha.outputs.short_sha }}
    secrets:
      docker_username: ${{ secrets.DOCKER_USERNAME }}
      docker_token: ${{ secrets.DOCKER_TOKEN }}

  deploy:
    needs: [docker-build, docker-build-sha]
    runs-on: ubuntu-latest
    environment: production
    steps:
      - run: echo "Deploying image: ${{ needs.docker-build.outputs.image_url }} to production"
```

### Verification

* ✅ Merge to `main` runs the full chain in sequence
* ✅ Image tagged with both `latest` and short SHA
* ✅ `deploy` job pauses for manual approval (environment protection rule)

---

## Task 6 – Scheduled Health Check

### What is it?

Runs every 12 hours (plus `workflow_dispatch` for manual testing). Pulls the deployed image, runs it, curls `/health`, and writes a report to the job summary.

### File

```text
.github/workflows/health-check.yml
```

```yaml
name: Health Check

on:
  schedule:
    - cron: '0 */12 * * *'
  workflow_dispatch:

jobs:
  health-check:
    runs-on: ubuntu-latest
    steps:
      - name: Pull latest image
        run: docker pull ${{ secrets.DOCKER_USERNAME }}/capstone-app:latest

      - name: Run container
        run: docker run -d --name health-test -p 8000:8000 ${{ secrets.DOCKER_USERNAME }}/capstone-app:latest

      - name: Wait and curl health endpoint
        id: check
        run: |
          sleep 5
          if curl -sf http://localhost:8000/health; then
            echo "status=PASSED" >> "$GITHUB_OUTPUT"
          else
            echo "status=FAILED" >> "$GITHUB_OUTPUT"
          fi

      - name: Stop container
        if: always()
        run: docker stop health-test && docker rm health-test

      - name: Write summary
        run: |
          echo "## Health Check Report" >> $GITHUB_STEP_SUMMARY
          echo "- Image: capstone-app:latest" >> $GITHUB_STEP_SUMMARY
          echo "- Status: ${{ steps.check.outputs.status }}" >> $GITHUB_STEP_SUMMARY
          echo "- Time: $(date)" >> $GITHUB_STEP_SUMMARY
```

### Verification

* ✅ Cron trigger set for every 12 hours
* ✅ Manual `workflow_dispatch` works for testing
* ✅ `$GITHUB_STEP_SUMMARY` renders a readable report on the Actions run page

---

## Pipeline Architecture

```text
PR opened/synced   → build & test           → PR checks pass
Push to main       → build & test
                   → Docker build & push (latest + sha tag)
                   → deploy (manual approval required)
Every 12 hours     → health check on deployed image
```

---

## Repository Structure

```text
github-actions-capstone/
│
├── app.py
├── requirements.txt
├── Dockerfile
├── test_health.sh
├── README.md
│
└── .github
    └── workflows
        ├── reusable-build-test.yml
        ├── reusable-docker.yml
        ├── pr-pipeline.yml
        ├── main-pipeline.yml
        └── health-check.yml
```

---

## Status

![PR Pipeline](https://github.com/kshitij730/github-actions-capstone/actions/workflows/pr-pipeline.yml/badge.svg)
![Main Pipeline](https://github.com/kshitij730/github-actions-capstone/actions/workflows/main-pipeline.yml/badge.svg)
![Health Check](https://github.com/kshitij730/github-actions-capstone/actions/workflows/health-check.yml/badge.svg)

---

## Verification Checklist

* ✅ Reusable build & test workflow works standalone via `workflow_call`
* ✅ Reusable Docker workflow builds and pushes with parameterized tags
* ✅ PR pipeline runs tests only, no image push
* ✅ Main pipeline chains test → build → deploy with environment protection
* ✅ Scheduled health check runs every 12 hours + on manual dispatch
* ✅ Deploy job requires manual approval via `production` environment

---

## What I'd Add Next

* Slack notification on deploy failure
* Multi-environment promotion (staging → production)
* Automatic rollback if scheduled health check fails
* Trivy vulnerability scan as a mandatory gate before deploy

---

## Key Learnings

* Reusable workflows (`workflow_call`) let build/test and Docker logic be written once and consumed by multiple pipelines.
* Separating the PR pipeline from the main pipeline enforces that Docker images are only pushed after a merge, not on every commit.
* Job outputs (`needs.<job>.outputs.<name>`) are the clean way to pass data — like image tags — between chained jobs.
* Environment protection rules turn a simple `deploy` job into a real approval gate, mirroring how production deployments work in real teams.
* Scheduled workflows combined with `$GITHUB_STEP_SUMMARY` give a lightweight, no-extra-tooling way to monitor a deployed service.

`#90DaysOfDevOps` `#DevOpsKaJosh` `#TrainWithShubham`