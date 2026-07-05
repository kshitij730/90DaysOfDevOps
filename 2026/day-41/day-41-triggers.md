# Day 41 – Triggers & Matrix Builds

## Objective

Today I explored different ways to trigger GitHub Actions workflows and learned how matrix builds execute the same job across multiple environments in parallel.

---

# Task 1 – Pull Request Trigger

Created:

.github/workflows/pr-check.yml

```yaml
name: Pull Request Check

on:
  pull_request:
    branches:
      - main
    types:
      - opened
      - synchronize

jobs:
  pr-check:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout Repository
        uses: actions/checkout@v4

      - name: Print PR Branch
        run: echo "PR check running for branch: ${{ github.head_ref }}"
```

### Verification

- Created a new branch
- Added a commit
- Pushed the branch
- Opened a Pull Request
- Workflow executed automatically
- Workflow appeared in the Pull Request Checks section

---

# Task 2 – Scheduled Workflow

Added cron schedule.

```yaml
on:
  schedule:
    - cron: '0 0 * * *'
```

Runs:

Every day at **00:00 UTC**

### Cron Question

Every Monday at 9:00 AM UTC

```text
0 9 * * 1
```

---

# Task 3 – Manual Workflow

Created:

.github/workflows/manual.yml

```yaml
name: Manual Workflow

on:
  workflow_dispatch:
    inputs:
      environment:
        description: "Deployment Environment"
        required: true
        default: staging

jobs:
  manual-job:
    runs-on: ubuntu-latest

    steps:
      - name: Print Selected Environment
        run: echo "Environment = ${{ github.event.inputs.environment }}"
```

### Verification

Opened:

Actions → Manual Workflow → Run Workflow

Selected:

staging

Output:

```
Environment = staging
```

---

# Task 4 – Matrix Builds

Created:

.github/workflows/matrix.yml

```yaml
name: Matrix Build

on:
  push:

jobs:
  build:

    runs-on: ${{ matrix.os }}

    strategy:
      matrix:
        os:
          - ubuntu-latest
          - windows-latest

        python-version:
          - "3.10"
          - "3.11"
          - "3.12"

    steps:

      - uses: actions/checkout@v4

      - name: Setup Python
        uses: actions/setup-python@v5
        with:
          python-version: ${{ matrix.python-version }}

      - name: Show Python Version
        run: python --version
```

### Result

Operating Systems:

- Ubuntu
- Windows

Python Versions:

- 3.10
- 3.11
- 3.12

Total Jobs:

2 × 3 = **6 Jobs**

All jobs ran simultaneously.

---

# Task 5 – Exclude & Fail Fast

Updated matrix.

```yaml
strategy:

  fail-fast: false

  matrix:

    os:
      - ubuntu-latest
      - windows-latest

    python-version:
      - "3.10"
      - "3.11"
      - "3.12"

    exclude:
      - os: windows-latest
        python-version: "3.10"
```

### Jobs Remaining

5 Jobs

### Testing Failure

Added:

```yaml
- name: Force Failure
  run: exit 1
```

Observed:

- One job failed
- Remaining matrix jobs continued executing because

```
fail-fast: false
```

After removing the failing step, all jobs passed successfully.

---

# fail-fast

### fail-fast: true

Default behavior.

If one matrix job fails, GitHub cancels the remaining running jobs.

### fail-fast: false

All matrix jobs continue running even if one fails.

Useful for collecting results from every environment.

---

# What I Learned

- Pull Request triggers
- Scheduled workflows
- Manual workflows
- Workflow inputs
- Matrix strategy
- Parallel job execution
- Excluding matrix combinations
- fail-fast behavior
- Cron expressions

---

# Screenshots

(Add screenshots of:)

- Pull Request workflow
- Manual workflow
- Matrix build
- Failed matrix run
- Successful matrix run