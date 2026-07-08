# Day 44 – Secrets, Artifacts & Running Real Tests in CI

## 🎯 Objective

Today's goal was to understand how GitHub Actions handles sensitive data securely, stores build artifacts, executes real tests, and speeds up workflows using dependency caching.

---

# Task 1 – GitHub Secrets

## Repository Secrets Created

From:

```
Repository
→ Settings
→ Secrets and Variables
→ Actions
→ New Repository Secret
```

Created the following secrets:

- MY_SECRET_MESSAGE
- DOCKER_USERNAME
- DOCKER_TOKEN

---

## Workflow File

```yaml
name: GitHub Secrets Demo

on:
  push:

jobs:
  secrets-demo:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout Repository
        uses: actions/checkout@v4

      - name: Verify Secret Exists
        run: |
          if [ -n "${{ secrets.MY_SECRET_MESSAGE }}" ]; then
            echo "The secret is set: true"
          else
            echo "The secret is set: false"
          fi

      - name: Use Secret as Environment Variable
        env:
          SECRET_VALUE: ${{ secrets.MY_SECRET_MESSAGE }}
        run: |
          echo "Secret accessed successfully."
```

---

## Output

```
The secret is set: true
Secret accessed successfully.
```

---

## What happens if we print a secret?

If we use

```yaml
run: echo "${{ secrets.MY_SECRET_MESSAGE }}"
```

GitHub automatically replaces the value with

```
***
```

to protect sensitive information.

---

## Why should secrets never be printed?

Secrets may contain:

- Passwords
- API Keys
- Docker Tokens
- Cloud Credentials

Printing them exposes confidential information in workflow logs.

GitHub masks secrets automatically, but developers should never intentionally print them.

---

# Task 2 – Secrets as Environment Variables

Instead of hardcoding values, secrets were passed securely.

```yaml
env:
  SECRET_VALUE: ${{ secrets.MY_SECRET_MESSAGE }}
```

The application can now use the value without exposing it anywhere in the repository.

---

# Task 3 – Upload Artifacts

Generated a report file during workflow execution.

---

## Workflow

```yaml
name: Upload Artifact

on:
  push:

jobs:
  upload:
    runs-on: ubuntu-latest

    steps:
      - name: Create Report
        run: |
          mkdir reports
          echo "CI Pipeline Passed Successfully" > reports/report.txt

      - name: Upload Report
        uses: actions/upload-artifact@v4
        with:
          name: ci-report
          path: reports/report.txt
```

---

## Generated File

```
reports/
└── report.txt
```

Contents

```
CI Pipeline Passed Successfully
```

---

## Verification

After workflow completion:

```
Actions
↓
Workflow Run
↓
Artifacts
↓
Download
```

Successfully downloaded the artifact from GitHub.

---

# Task 4 – Download Artifacts Between Jobs

A second job downloaded the uploaded artifact and displayed its contents.

---

## Workflow

```yaml
name: Download Artifact

on:
  push:

jobs:
  generate:
    runs-on: ubuntu-latest

    steps:
      - name: Generate Report
        run: |
          mkdir reports
          echo "Artifact transferred successfully." > reports/report.txt

      - name: Upload Artifact
        uses: actions/upload-artifact@v4
        with:
          name: report
          path: reports/report.txt

  consume:
    needs: generate
    runs-on: ubuntu-latest

    steps:
      - name: Download Artifact
        uses: actions/download-artifact@v4
        with:
          name: report

      - name: Display Content
        run: cat report.txt
```

---

## Output

```
Artifact transferred successfully.
```

---

## Real-world Use Cases

Artifacts are commonly used for:

- Test Reports
- Build Logs
- Coverage Reports
- Docker Images
- Compiled Applications
- APK Files
- Release Packages

---

# Task 5 – Running Real Tests in CI

Created a simple Python application.

---

## hello.py

```python
print("Hello from GitHub Actions CI!")
```

---

## requirements.txt

```
requests
```

---

## Workflow

```yaml
name: Python CI Test

on:
  push:

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Setup Python
        uses: actions/setup-python@v5
        with:
          python-version: "3.12"

      - name: Install Dependencies
        run: pip install -r requirements.txt

      - name: Run Script
        run: python hello.py
```

---

## Successful Output

```
Hello from GitHub Actions CI!
```

---

## Intentional Failure

Modified

```python
print("Hello")
```

to

```python
raise Exception("Pipeline Failed")
```

Result

```
❌ Workflow Failed
```

After fixing

```python
print("Pipeline Passed")
```

Workflow became

```
✅ Success
```

---

# Task 6 – Dependency Caching

Caching avoids downloading dependencies every workflow run.

---

## Workflow

```yaml
name: Cache Demo

on:
  push:

jobs:
  cache:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-python@v5
        with:
          python-version: "3.12"

      - name: Cache pip
        uses: actions/cache@v4
        with:
          path: ~/.cache/pip
          key: ${{ runner.os }}-pip-${{ hashFiles('requirements.txt') }}
          restore-keys: |
            ${{ runner.os }}-pip-

      - name: Install Dependencies
        run: pip install -r requirements.txt
```

---

## Observation

### First Run

```
Downloading packages...
Installing dependencies...
```

Execution time was higher.

---

### Second Run

```
Cache restored successfully.
```

Packages were reused.

Execution became noticeably faster.

---

## What is being cached?

Python packages downloaded by pip.

---

## Where is the cache stored?

GitHub stores the cache in its own cache storage associated with your repository.

---

# What I Learned

### GitHub Secrets

- Secure way to store passwords and API keys
- Never hardcode credentials
- GitHub automatically masks secrets in logs

---

### Artifacts

- Used to transfer files between jobs
- Downloadable after workflow completion
- Useful for reports and build outputs

---

### Real Testing

- CI executes actual application code
- Non-zero exit codes fail the workflow
- Easy way to automate testing

---

### Dependency Cache

- Speeds up workflows
- Saves installation time
- Restores packages automatically using cache keys

---

# Folder Structure

```
2026/
└── day-44/
    ├── day-44-secrets-artifacts.md
    ├── hello.py
    ├── requirements.txt
    └── workflows/
        ├── secrets.yml
        ├── artifact.yml
        ├── ci-test.yml
        └── cache.yml
```

---

# Screenshots to Include

- Repository Secrets page
- Secret workflow run
- Artifact upload
- Artifact download
- Python CI passing
- Failed workflow (red)
- Successful workflow (green)
- Cache workflow

---

# Conclusion

Day 44 introduced some of the most practical GitHub Actions features used in production CI/CD pipelines.

I learned how to:

- Securely store secrets
- Pass secrets as environment variables
- Upload and download artifacts between jobs
- Execute real Python scripts inside CI
- Handle workflow failures
- Improve pipeline performance using dependency caching

These concepts are essential for building secure, reliable, and efficient CI/CD pipelines in real-world DevOps projects.