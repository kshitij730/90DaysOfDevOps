# Day 46 – Reusable Workflows & Composite Actions

## Objective

Learn how to create reusable GitHub Actions workflows using `workflow_call` and build custom composite actions to avoid repeating the same automation across repositories.

---

# Task 1 – Understanding Reusable Workflows

## 1. What is a Reusable Workflow?

A reusable workflow is a GitHub Actions workflow that can be called by other workflows instead of being executed directly. It allows teams to write common CI/CD logic once and reuse it across multiple repositories or workflows.

---

## 2. What is the `workflow_call` trigger?

`workflow_call` is a special trigger that makes a workflow reusable. Unlike triggers such as `push` or `pull_request`, a workflow using `workflow_call` only runs when another workflow calls it.

Example:

```yaml
on:
  workflow_call:
```

---

## 3. How is calling a reusable workflow different from using a regular action (`uses:`)?

| Reusable Workflow                       | Regular Action                                          |
| --------------------------------------- | ------------------------------------------------------- |
| Runs one or more jobs                   | Runs only inside a step                                 |
| Can use multiple runners                | Executes within the current job                         |
| Can define inputs, secrets, and outputs | Usually performs a single task                          |
| Lives inside `.github/workflows/`       | Lives inside an action directory or external repository |

---

## 4. Where must a reusable workflow file live?

Reusable workflows must be stored inside:

```text
.github/workflows/
```

Example:

```text
.github/workflows/reusable-build.yml
```

---

# Task 2 – Reusable Workflow

File:

```text
.github/workflows/reusable-build.yml
```

```yaml
name: Reusable Build

on:
  workflow_call:
    inputs:
      app_name:
        required: true
        type: string

      environment:
        required: true
        default: staging
        type: string

    secrets:
      docker_token:
        required: true

    outputs:
      build_version:
        description: Generated Build Version
        value: ${{ jobs.build.outputs.build_version }}

jobs:
  build:
    runs-on: ubuntu-latest

    outputs:
      build_version: ${{ steps.version.outputs.build_version }}

    steps:
      - name: Checkout Repository
        uses: actions/checkout@v4

      - name: Print Build Information
        run: |
          echo "Building ${{ inputs.app_name }} for ${{ inputs.environment }}"
          echo "Docker token is set: ${{ secrets.docker_token != '' }}"

      - name: Generate Build Version
        id: version
        run: |
          VERSION="v1.0-${GITHUB_SHA::7}"
          echo "build_version=$VERSION" >> $GITHUB_OUTPUT
```

---

## Output

The reusable workflow:

* Accepts inputs
* Accepts secrets
* Generates a build version
* Returns the version to the caller workflow

---

# Task 3 – Caller Workflow

File:

```text
.github/workflows/call-build.yml
```

```yaml
name: Call Reusable Workflow

on:
  push:
    branches:
      - main

jobs:
  build:
    uses: ./.github/workflows/reusable-build.yml

    with:
      app_name: "my-web-app"
      environment: "production"

    secrets:
      docker_token: ${{ secrets.DOCKER_TOKEN }}

  show-version:
    needs: build

    runs-on: ubuntu-latest

    steps:
      - name: Display Build Version
        run: |
          echo "Build Version = ${{ needs.build.outputs.build_version }}"
```

---

## Workflow Execution

```text
Push to main
      │
      ▼
call-build.yml
      │
      ▼
reusable-build.yml
      │
      ▼
Generate build version
      │
      ▼
Return output
      │
      ▼
show-version job prints version
```

---

# Task 4 – Reusable Workflow Output

The reusable workflow generates:

```text
v1.0-<short-sha>
```

Example:

```text
v1.0-a32fc18
```

The caller workflow accesses it using:

```yaml
${{ needs.build.outputs.build_version }}
```

---

# Task 5 – Composite Action

Directory:

```text
.github/actions/setup-and-greet/
```

File:

```text
action.yml
```

```yaml
name: Setup and Greet

description: Prints greeting and runner information

inputs:
  name:
    required: true

  language:
    required: false
    default: en

outputs:
  greeted:
    value: ${{ steps.output.outputs.greeted }}

runs:
  using: composite

  steps:
    - shell: bash
      run: |
        if [ "${{ inputs.language }}" = "en" ]; then
          echo "Hello ${{ inputs.name }}"
        else
          echo "Namaste ${{ inputs.name }}"
        fi

    - shell: bash
      run: |
        echo "Date: $(date)"
        echo "Runner OS: $RUNNER_OS"

    - id: output
      shell: bash
      run: |
        echo "greeted=true" >> $GITHUB_OUTPUT
```

---

# Workflow Using Composite Action

File:

```text
.github/workflows/composite-demo.yml
```

```yaml
name: Composite Action Demo

on:
  workflow_dispatch:

jobs:
  greet:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Run Composite Action
        uses: ./.github/actions/setup-and-greet

        with:
          name: Josh
          language: en

      - name: Finish
        run: echo "Composite Action Executed Successfully"
```

---

# Task 6 – Reusable Workflow vs Composite Action

| Feature                      | Reusable Workflow                                       | Composite Action                               |
| ---------------------------- | ------------------------------------------------------- | ---------------------------------------------- |
| Triggered by                 | `workflow_call`                                         | `uses:` in a step                              |
| Can contain jobs?            | ✅ Yes                                                   | ❌ No                                           |
| Can contain multiple steps?  | ✅ Yes                                                   | ✅ Yes                                          |
| Lives where?                 | `.github/workflows/`                                    | `.github/actions/<action-name>/`               |
| Can accept secrets directly? | ✅ Yes                                                   | ❌ No (pass as inputs or environment variables) |
| Best for                     | Complete CI/CD pipelines and reusable job orchestration | Reusing common step sequences inside a job     |

---

# Repository Structure

```text
github-actions-practice/
│
├── .github
│   ├── workflows
│   │   ├── reusable-build.yml
│   │   ├── call-build.yml
│   │   └── composite-demo.yml
│   │
│   └── actions
│       └── setup-and-greet
│           └── action.yml
│
└── 2026
    └── day-46
        └── day-46-reusable-workflows.md
```

---

# Verification Checklist

* ✅ Created a reusable workflow using `workflow_call`
* ✅ Passed inputs to the reusable workflow
* ✅ Passed repository secret (`DOCKER_TOKEN`)
* ✅ Generated and returned workflow outputs
* ✅ Created a caller workflow
* ✅ Created a custom composite action
* ✅ Executed the composite action successfully
* ✅ Compared reusable workflows and composite actions
* ✅ Added documentation for Day 46

---

# Screenshot

> **Add a screenshot here after running the workflow.**

Example:

```text
GitHub Repository
    ↓
Actions
    ↓
Call Reusable Workflow
    ↓
build
    ↓
show-version
```

*(Insert the screenshot of the Actions page showing the caller workflow invoking the reusable workflow.)*

---

# Key Learnings

* Reusable workflows eliminate duplicated CI/CD logic across repositories.
* `workflow_call` allows one workflow to invoke another like a function.
* Inputs, secrets, and outputs make reusable workflows flexible and configurable.
* Composite actions are ideal for bundling frequently used steps into a single reusable action.
* Reusable workflows orchestrate entire jobs, whereas composite actions simplify repeated step sequences within a job.
