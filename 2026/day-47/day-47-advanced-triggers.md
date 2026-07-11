# Day 47 – Advanced Triggers: PR Events, Cron Schedules & Event-Driven Pipelines

## Objective

Today I explored some of GitHub Actions' advanced event triggers that are commonly used in production CI/CD pipelines. Instead of only reacting to `push` events, I learned how workflows can respond to pull request lifecycle events, scheduled cron jobs, path filters, chained workflows, and even external API requests.

---

# Task 1 – Pull Request Lifecycle Events

## What are Pull Request Lifecycle Events?

GitHub provides different activity types for pull requests that allow workflows to run only when specific actions occur.

The workflow below listens for:

* `opened`
* `synchronize`
* `reopened`
* `closed`

It also checks whether the PR was merged before executing the final step.

---

## File

```text
.github/workflows/pr-lifecycle.yml
```

```yaml
name: PR Lifecycle

on:
  pull_request:
    types:
      - opened
      - synchronize
      - reopened
      - closed

jobs:
  pr-info:
    runs-on: ubuntu-latest

    steps:
      - name: Print PR Details
        run: |
          echo "Event: ${{ github.event.action }}"
          echo "Title: ${{ github.event.pull_request.title }}"
          echo "Author: ${{ github.event.pull_request.user.login }}"
          echo "Source Branch: ${{ github.event.pull_request.head.ref }}"
          echo "Target Branch: ${{ github.event.pull_request.base.ref }}"

      - name: PR Merged
        if: github.event.pull_request.merged == true
        run: |
          echo "Pull Request was merged successfully!"
```

---

## Verification

After testing the workflow:

* ✅ Triggered when a PR was opened
* ✅ Triggered after pushing new commits to the PR
* ✅ Triggered after reopening a PR
* ✅ Triggered after merging the PR

---

# Task 2 – PR Validation Workflow

This workflow simulates common validation checks performed before merging code into the main branch.

It includes:

* File size validation
* Branch naming convention validation
* PR description validation

---

## File

```text
.github/workflows/pr-checks.yml
```

```yaml
name: PR Checks

on:
  pull_request:
    branches:
      - main

jobs:
  file-size-check:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Check File Size
        run: |
          find . -type f -size +1M && {
            echo "Large file detected"
            exit 1
          } || echo "All files are under 1 MB"

  branch-name-check:
    runs-on: ubuntu-latest

    steps:
      - name: Validate Branch Name
        run: |
          BRANCH="${{ github.head_ref }}"

          if [[ "$BRANCH" =~ ^(feature|fix|docs)/ ]]; then
            echo "Valid branch name"
          else
            echo "Invalid branch name"
            exit 1
          fi

  pr-body-check:
    runs-on: ubuntu-latest

    steps:
      - name: Check PR Description
        run: |
          BODY="${{ github.event.pull_request.body }}"

          if [ -z "$BODY" ]; then
            echo "::warning::PR description is empty."
          else
            echo "PR description exists."
          fi
```

---

## Verification

* ✅ File size check works correctly.
* ✅ Invalid branch names fail the workflow.
* ✅ Empty PR descriptions generate warnings.
* ✅ Valid pull requests pass all checks.

---

# Task 3 – Scheduled Workflows (Cron)

GitHub Actions supports cron-based scheduled workflows that automatically execute at specific times.

This workflow contains two schedules:

* Every Monday at **2:30 AM UTC**
* Every **6 hours**

A manual trigger (`workflow_dispatch`) is also added for testing.

---

## File

```text
.github/workflows/scheduled-tasks.yml
```

```yaml
name: Scheduled Tasks

on:
  workflow_dispatch:

  schedule:
    - cron: "30 2 * * 1"
    - cron: "0 */6 * * *"

jobs:
  health-check:
    runs-on: ubuntu-latest

    steps:
      - name: Show Schedule
        run: |
          echo "Triggered by: ${{ github.event.schedule }}"

      - name: Health Check
        run: |
          curl -I https://github.com
```

---

## Cron Expressions

### Every weekday at 9:00 AM IST

```text
30 3 * * 1-5
```

---

### First day of every month at midnight (UTC)

```text
0 0 1 * *
```

---

## Why can scheduled workflows be delayed or skipped?

GitHub schedules are not guaranteed to execute at the exact minute. On inactive repositories, scheduled workflows may be delayed or skipped to reduce infrastructure usage. Scheduled workflows only run on the repository's default branch.

---

# Task 4 – Path & Branch Filters

Path filters help reduce unnecessary workflow executions.

---

## Smart Trigger

```text
.github/workflows/smart-triggers.yml
```

```yaml
name: Smart Trigger

on:
  push:
    branches:
      - main
      - release/**
    paths:
      - "src/**"
      - "app/**"

jobs:
  trigger:
    runs-on: ubuntu-latest

    steps:
      - run: echo "Application source changed."
```

---

## Ignore Documentation Changes

```text
.github/workflows/ignore-docs.yml
```

```yaml
name: Ignore Docs

on:
  push:
    branches:
      - main
      - release/**
    paths-ignore:
      - "*.md"
      - "docs/**"

jobs:
  skip-docs:
    runs-on: ubuntu-latest

    steps:
      - run: echo "Documentation-only changes skipped."
```

---

## When should you use `paths`?

Use `paths` when workflows should run **only if specific files or folders are modified**.

Example:

* Source code
* Backend services
* Infrastructure files

---

## When should you use `paths-ignore`?

Use `paths-ignore` when workflows should execute for almost everything **except** documentation or other non-functional files.

Example:

* README updates
* Documentation
* Markdown files

---

# Task 5 – Chaining Workflows using `workflow_run`

Instead of calling another workflow directly, GitHub can automatically trigger a second workflow after another workflow completes.

---

## Tests Workflow

```text
.github/workflows/tests.yml
```

```yaml
name: Run Tests

on:
  push:

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - run: echo "Running Tests..."
      - run: echo "Tests Passed!"
```

---

## Deploy Workflow

```text
.github/workflows/deploy-after-tests.yml
```

```yaml
name: Deploy After Tests

on:
  workflow_run:
    workflows:
      - Run Tests
    types:
      - completed

jobs:
  deploy:
    if: github.event.workflow_run.conclusion == 'success'

    runs-on: ubuntu-latest

    steps:
      - run: echo "Deploying Application..."

  failed:
    if: github.event.workflow_run.conclusion != 'success'

    runs-on: ubuntu-latest

    steps:
      - run: echo "Tests failed. Deployment skipped."
```

---

## Verification

Workflow execution order:

```text
Push Code
      │
      ▼
Run Tests
      │
      ▼
workflow_run Event
      │
      ▼
Deploy After Tests
```

Deployment starts only if the test workflow finishes successfully.

---

# Task 6 – External Event Trigger (`repository_dispatch`)

GitHub Actions workflows can also be triggered from external systems.

---

## File

```text
.github/workflows/external-trigger.yml
```

```yaml
name: External Trigger

on:
  repository_dispatch:
    types:
      - deploy-request

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
      - run: |
          echo "Environment: ${{ github.event.client_payload.environment }}"
```

---

## Trigger Command

```bash
gh api repos/<owner>/<repo>/dispatches \
-f event_type=deploy-request \
-f client_payload='{"environment":"production"}'
```

---

## When is `repository_dispatch` useful?

External systems commonly trigger GitHub workflows, including:

* Monitoring tools
* Slack bots
* Jenkins
* Deployment dashboards
* Incident response platforms
* Internal automation tools

For example, a monitoring platform could trigger an automatic rollback pipeline after detecting a production outage.

---

# `workflow_run` vs `workflow_call`

| workflow_run                               | workflow_call                                   |
| ------------------------------------------ | ----------------------------------------------- |
| Triggered after another workflow completes | Called directly by another workflow             |
| Event-driven                               | Function-like invocation                        |
| Can react to workflow success or failure   | Reuses workflow logic                           |
| Best for chained CI/CD pipelines           | Best for reusable workflows across repositories |

---

# Repository Structure

```text
github-actions-practice/
│
├── .github
│   └── workflows
│       ├── pr-lifecycle.yml
│       ├── pr-checks.yml
│       ├── scheduled-tasks.yml
│       ├── smart-triggers.yml
│       ├── ignore-docs.yml
│       ├── tests.yml
│       ├── deploy-after-tests.yml
│       └── external-trigger.yml
│
└── 2026
    └── day-47
        └── day-47-advanced-triggers.md
```

---

# Verification Checklist

* ✅ Explored Pull Request lifecycle events
* ✅ Built a PR validation workflow
* ✅ Created scheduled workflows using cron
* ✅ Learned GitHub cron syntax
* ✅ Implemented path and branch filters
* ✅ Chained workflows using `workflow_run`
* ✅ Triggered workflows using `repository_dispatch`
* ✅ Compared `workflow_run` and `workflow_call`

---


# Key Learnings

* GitHub Actions supports many event types beyond `push`.
* Pull request events enable automated validation before merging code.
* Scheduled workflows are useful for health checks, backups, and maintenance tasks.
* Path filters reduce unnecessary workflow executions and optimize CI resources.
* `workflow_run` creates event-driven pipelines by chaining workflows together.
* `repository_dispatch` allows external applications and services to trigger GitHub Actions workflows.
* Advanced triggers make CI/CD pipelines more flexible, efficient, and production-ready.
