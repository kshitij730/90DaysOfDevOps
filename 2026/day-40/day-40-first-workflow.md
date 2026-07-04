# Day 40 – Your First GitHub Actions Workflow

## Objective
Today I created my first GitHub Actions workflow and executed a CI pipeline in the cloud.

---

# Task 1 – Repository Setup

Created a new public GitHub repository:

github-actions-practice

Repository structure:

.github/
└── workflows/
    └── hello.yml

---

# Task 2 – Hello Workflow

## Workflow File

```yaml
name: Hello GitHub Actions

on:
  push:

jobs:
  greet:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout Repository
        uses: actions/checkout@v4

      - name: Print Greeting
        run: echo "Hello from GitHub Actions!"
```

## Result

- Repository pushed successfully
- Workflow triggered automatically
- GitHub Actions executed the job
- Pipeline completed successfully with a green checkmark

---

# Task 3 – Understanding Workflow Anatomy

| Key | Purpose |
|------|----------|
| on | Defines what event triggers the workflow |
| jobs | Collection of jobs executed by the workflow |
| runs-on | Specifies the runner operating system |
| steps | Individual tasks executed inside a job |
| uses | Uses an existing GitHub Action |
| run | Executes shell commands |
| name | Gives a readable name to the workflow or step |

---

# Task 4 – Enhanced Workflow

Updated workflow:

```yaml
name: Hello GitHub Actions

on:
  push:

jobs:
  greet:
    runs-on: ubuntu-latest

    steps:

      - name: Checkout Repository
        uses: actions/checkout@v4

      - name: Print Greeting
        run: echo "Hello from GitHub Actions!"

      - name: Show Date and Time
        run: date

      - name: Show Current Branch
        run: echo "Branch: ${{ github.ref_name }}"

      - name: List Repository Files
        run: ls -la

      - name: Display Runner OS
        run: echo "Runner OS: $RUNNER_OS"
```

## Output

Successfully displayed:

- Greeting message
- Current date and time
- Branch name
- Repository files
- Runner operating system

---

# Task 5 – Failed Pipeline

Added this step intentionally:

```yaml
- name: Intentional Failure
  run: exit 1
```

Result:

- Workflow failed
- GitHub marked the pipeline with a red ❌
- Remaining steps were skipped

After removing the failing command and pushing again, the workflow completed successfully.

---

# Observations

- Every push automatically starts a new workflow.
- GitHub provides free cloud runners for public repositories.
- Each workflow consists of jobs, and each job contains multiple steps.
- A single failed step causes the job to fail.
- Workflow logs make debugging easy.

---

# What I Learned

- Creating GitHub Actions workflows
- Workflow syntax
- Push event triggers
- GitHub-hosted runners
- Built-in GitHub variables
- Running Linux commands in workflows
- Reading workflow logs
- Understanding failed pipeline behavior

---

# Screenshot

(Add screenshot of the successful GitHub Actions workflow here.)
