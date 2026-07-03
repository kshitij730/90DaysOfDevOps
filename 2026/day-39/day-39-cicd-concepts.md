# Day 39 – What is CI/CD?

## Objective

Today's goal was to understand why CI/CD exists, how it solves real software delivery problems, and learn the building blocks of a CI/CD pipeline before writing actual GitHub Actions workflows.

---

# Task 1: The Problem

Imagine a team of five developers pushing code manually and deploying directly to production.

## What can go wrong?

- Code conflicts between developers.
- Bugs reaching production without testing.
- Manual deployment mistakes.
- Different deployment procedures by different developers.
- Downtime caused by human errors.
- Difficult rollbacks if deployment fails.
- Inconsistent application versions running across environments.

---

## What does "It works on my machine" mean?

This means an application works perfectly on the developer's local machine but fails on another developer's machine, staging, or production because of differences in:

- Operating system
- Installed packages
- Environment variables
- Dependency versions
- Configuration files

CI/CD minimizes this issue by using standardized automated build and testing environments.

---

## How many times can a team safely deploy manually?

Manual deployments are usually limited to **1–2 deployments per day** because they are slow, risky, and require human supervision.

With CI/CD, teams can safely deploy dozens or even hundreds of times per day.

---

# Task 2: CI vs CD

## Continuous Integration (CI)

Continuous Integration is the practice of automatically building and testing code whenever developers push changes to a shared repository.

It helps detect bugs, merge conflicts, and build failures early.

### Example

A developer pushes code to GitHub.

GitHub Actions automatically runs unit tests and builds the application.

---

## Continuous Delivery (CD)

Continuous Delivery ensures that the application is always deployment-ready after passing all automated checks.

Deployment to production still requires manual approval.

### Example

The application is automatically built, tested, and deployed to a staging environment.

A release engineer clicks **Deploy** when ready.

---

## Continuous Deployment (CD)

Continuous Deployment goes one step further.

Every successful pipeline automatically deploys to production without manual approval.

### Example

Netflix automatically deploys production changes after all pipeline checks pass.

---

# Task 3: Pipeline Anatomy

## Trigger

The event that starts the pipeline.

Examples:

- Git Push
- Pull Request
- Scheduled Run
- Manual Trigger

---

## Stage

A logical phase in the pipeline.

Examples:

- Build
- Test
- Deploy

---

## Job

A collection of related tasks executed inside a stage.

Example:

Run unit tests.

---

## Step

A single action or command inside a job.

Examples:

```bash
npm install
npm test
docker build .
```

---

## Runner

The machine or virtual environment that executes pipeline jobs.

Examples:

- GitHub-hosted runner
- Self-hosted runner

---

## Artifact

The output produced by a pipeline.

Examples:

- Docker Image
- JAR File
- ZIP Package
- Test Reports

---

# Task 4: CI/CD Pipeline Diagram

```
Developer
     │
     ▼
Git Push to GitHub
     │
     ▼
GitHub Actions Trigger
     │
     ▼
──────────────────────────────
Stage 1 → Build
──────────────────────────────
Install Dependencies
Compile Application

     │
     ▼
──────────────────────────────
Stage 2 → Test
──────────────────────────────
Run Unit Tests
Run Lint Checks

     │
     ▼
──────────────────────────────
Stage 3 → Docker Build
──────────────────────────────
Build Docker Image
Push Image to Docker Hub

     │
     ▼
──────────────────────────────
Stage 4 → Deploy
──────────────────────────────
Deploy to Staging Server

     │
     ▼
Application Running
```

---

# Task 5: Explore an Open-Source Repository

Repository Chosen:

**FastAPI**

GitHub Repository:

https://github.com/fastapi/fastapi

Workflow Folder:

```
.github/workflows/
```

Workflow Examined:

```
tests.yml
```

### Trigger

- Push
- Pull Request

---

### Number of Jobs

Approximately **2–4 jobs** depending on Python versions and operating systems.

---

### What does it do?

- Installs Python
- Installs project dependencies
- Runs formatting checks
- Runs unit tests
- Verifies that FastAPI builds successfully before merging changes

---

# What I Learned

## 1.

CI/CD is not a tool.

It is a software development practice that automates integration, testing, and deployment.

---

## 2.

A pipeline is made up of triggers, stages, jobs, and steps executed by runners.

---

## 3.

Automation reduces deployment errors, improves software quality, and enables frequent, reliable releases.

---

# Conclusion

Today I learned the core concepts behind CI/CD and understood how automated pipelines improve collaboration, reduce manual errors, and accelerate software delivery. These fundamentals will help me build GitHub Actions workflows and complete end-to-end CI/CD pipelines in the upcoming days.