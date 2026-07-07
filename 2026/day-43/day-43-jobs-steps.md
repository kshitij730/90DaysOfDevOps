# Day 43 – Jobs, Steps, Environment Variables & Conditionals

## Objective

Today's goal was to learn how GitHub Actions controls workflow execution using multiple jobs, environment variables, job outputs, dependencies, and conditional execution.

---

# Task 1 – Multi-Job Workflow

Created a workflow named `multi-job.yml` with three dependent jobs.

Workflow Graph

```
Build
   │
   ▼
Test
   │
   ▼
Deploy
```

## multi-job.yml

```yaml
name: Multi Job Workflow

on:
  push:

jobs:

  build:
    runs-on: ubuntu-latest

    steps:
      - name: Build
        run: echo "Building the app"

  test:
    runs-on: ubuntu-latest

    needs: build

    steps:
      - name: Test
        run: echo "Running tests"

  deploy:
    runs-on: ubuntu-latest

    needs: test

    steps:
      - name: Deploy
        run: echo "Deploying the application"
```

### Observation

- Build executes first.
- Test starts only after Build succeeds.
- Deploy starts only after Test succeeds.
- GitHub Actions displays the dependency graph automatically.

---

# Task 2 – Environment Variables

Environment variables were used at three different levels.

- Workflow Level
- Job Level
- Step Level

Also printed GitHub context variables.

## env-vars.yml

```yaml
name: Environment Variables

on:
  push:

env:
  APP_NAME: myapp

jobs:

  demo:
    runs-on: ubuntu-latest

    env:
      ENVIRONMENT: staging

    steps:

      - name: Print Variables

        env:
          VERSION: 1.0.0

        run: |
          echo "Application = $APP_NAME"
          echo "Environment = $ENVIRONMENT"
          echo "Version = $VERSION"

          echo "Commit SHA = ${{ github.sha }}"
          echo "Actor = ${{ github.actor }}"
```

### Output

Successfully printed

- APP_NAME
- ENVIRONMENT
- VERSION
- Commit SHA
- GitHub Username

---

# Task 3 – Job Outputs

Created one job that generates today's date.

Created another job that reads the output.

## job-output.yml

```yaml
name: Job Outputs

on:
  push:

jobs:

  generate:

    runs-on: ubuntu-latest

    outputs:
      today: ${{ steps.date.outputs.today }}

    steps:

      - id: date

        run: |
          echo "today=$(date)" >> $GITHUB_OUTPUT

  print:

    runs-on: ubuntu-latest

    needs: generate

    steps:

      - name: Print Date

        run: |
          echo "Today's Date:"
          echo "${{ needs.generate.outputs.today }}"
```

### Observation

Job 1 generated the output.

Job 2 successfully accessed it using

```
needs.generate.outputs.today
```

### Why Job Outputs?

Outputs help jobs share data.

Examples

- Docker Image Tag
- Build Version
- Release Number
- Generated File Name
- Deployment URL

---

# Task 4 – Conditionals

Implemented different conditional executions.

## conditionals.yml

```yaml
name: Conditionals

on:
  push:
  pull_request:

jobs:

  demo:

    runs-on: ubuntu-latest

    steps:

      - name: Run Only On Main

        if: github.ref == 'refs/heads/main'

        run: echo "Main Branch"

      - name: Intentional Failure

        run: exit 1

        continue-on-error: true

      - name: Runs If Previous Failed

        if: failure()

        run: echo "Previous Step Failed"

  push-only:

    if: github.event_name == 'push'

    runs-on: ubuntu-latest

    steps:

      - run: echo "Runs only on Push Event"
```

### Observation

- Main Branch step executes only on main.
- Failure() runs only after a failed step.
- continue-on-error allows workflow execution to continue.
- Push-only job never runs during Pull Requests.

---

# Task 5 – Smart Pipeline

Created a smart pipeline.

Workflow Graph

```
Lint ─────┐
          │
          ▼
       Summary
          ▲
          │
Test ─────┘
```

## smart-pipeline.yml

```yaml
name: Smart Pipeline

on:
  push:

jobs:

  lint:

    runs-on: ubuntu-latest

    steps:
      - name: Lint

        run: echo "Lint Successful"

  test:

    runs-on: ubuntu-latest

    steps:
      - name: Test

        run: echo "Tests Passed"

  summary:

    runs-on: ubuntu-latest

    needs:
      - lint
      - test

    steps:

      - name: Branch Information

        run: |

          if [[ "${{ github.ref_name }}" == "main" ]]

          then
            echo "Main Branch Push"

          else
            echo "Feature Branch Push"

          fi

      - name: Commit Message

        run: |

          echo "${{ github.event.head_commit.message }}"
```

### Observation

- Lint and Test run simultaneously.
- Summary waits for both jobs.
- Detects branch type.
- Prints latest commit message.

---

# GitHub Context Variables Used

| Variable | Description |
|-----------|-------------|
| `${{ github.actor }}` | User who triggered workflow |
| `${{ github.sha }}` | Commit SHA |
| `${{ github.ref_name }}` | Branch Name |
| `${{ github.event_name }}` | Event Type |
| `${{ github.event.head_commit.message }}` | Commit Message |

---

# What is `needs`?

`needs` creates dependency between jobs.

Example

```
Build
 ↓
Test
 ↓
Deploy
```

Without `needs`, every job starts in parallel.

With `needs`, jobs execute sequentially.

---

# What are Job Outputs?

Outputs allow one job to pass information to another job.

Example

```
Generate Version
        │
        ▼
 Deploy Job
```

Common Uses

- Docker Image Tags
- Release Versions
- Artifact Names
- Deployment URLs

---

# Environment Variable Levels

| Level | Example |
|--------|----------|
| Workflow | APP_NAME |
| Job | ENVIRONMENT |
| Step | VERSION |

Priority

```
Workflow
    ↓
Job
    ↓
Step
```

Step variables override Job variables.

Job variables override Workflow variables.

---

# Conditionals Learned

Run only on main

```yaml
if: github.ref == 'refs/heads/main'
```

Run when previous step fails

```yaml
if: failure()
```

Run when previous step succeeds

```yaml
if: success()
```

Continue even after failure

```yaml
continue-on-error: true
```

Push only

```yaml
if: github.event_name == 'push'
```

---

# Workflow Files Created

```
.github/workflows/

├── multi-job.yml
├── env-vars.yml
├── job-output.yml
├── conditionals.yml
└── smart-pipeline.yml
```

---

# Screenshots

Added screenshots of

- Multi Job Workflow Graph
- Environment Variables Output
- Job Outputs
- Conditional Workflow
- Smart Pipeline Graph

---

# Key Learnings

- Jobs execute independently unless connected with `needs`.
- Steps are individual commands inside a job.
- Environment variables can be declared at Workflow, Job, and Step levels.
- Job Outputs allow data sharing across jobs.
- GitHub Context provides runtime information like branch, commit, and actor.
- Conditionals make workflows dynamic.
- Parallel jobs reduce total pipeline execution time.

---

# Interview Notes

### What is a Job?

A Job is a collection of steps executed on a runner.

---

### What is a Step?

A Step is a single command or action executed inside a Job.

---

### What is `needs`?

Creates dependency between jobs.

---

### What are Job Outputs?

A mechanism to transfer data between jobs.

---

### What are Environment Variables?

Variables that store reusable configuration values during workflow execution.

---

### Why use Conditionals?

Conditionals allow workflows to make decisions based on branches, events, job status, or runtime information.

---

# Conclusion

Day 43 introduced the concepts that make GitHub Actions workflows production-ready. By combining multiple jobs, dependencies, outputs, environment variables, and conditional execution, I learned how real-world CI/CD pipelines coordinate tasks efficiently, share data between jobs, and execute different actions based on workflow events.