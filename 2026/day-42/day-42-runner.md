# Day 42 – GitHub Hosted & Self Hosted Runners

## Objective

Learn how GitHub Actions executes workflows using hosted and self-hosted runners.

---

# Task 1 — GitHub Hosted Runners

Created one workflow containing three jobs.

| Runner |
|----------|
| Ubuntu Latest |
| Windows Latest |
| macOS Latest |

Each job prints:

- Operating System
- Hostname
- Current User

### What is a GitHub Hosted Runner?

A GitHub Hosted Runner is a temporary virtual machine provided and managed entirely by GitHub. Every workflow gets a fresh machine which is automatically destroyed after the job finishes.

---

# Task 2 — Explore Installed Software

Verified pre-installed software.

```
Docker
Python
Node.js
Git
```

Example Commands

```bash
docker --version
python3 --version
node --version
git --version
```

### Why Pre-installed Tools Matter

- Faster CI execution
- No setup time
- Standard environment
- Less maintenance

---

# Task 3 — Self Hosted Runner

Configured a self-hosted runner on Ubuntu EC2.

Steps:

1. Repository Settings
2. Actions
3. Runners
4. New Self Hosted Runner
5. Linux
6. Download
7. Configure
8. Run

Verified runner status:

✅ Idle

---

# Task 4 — Workflow on Self Hosted Runner

Workflow:

- prints hostname
- prints working directory
- creates runner-test.txt
- verifies file exists

Result:

Successfully executed on my EC2 instance.

---

# Task 5 — Runner Labels

Added custom label:

```
my-linux-runner
```

Workflow:

```yaml
runs-on:
  - self-hosted
  - my-linux-runner
```

### Why Labels?

Labels help GitHub choose the correct runner when multiple self-hosted runners are available.

Examples:

- production
- testing
- gpu
- ubuntu
- docker
- my-linux-runner

---

# Task 6 — Comparison

| Feature | GitHub Hosted | Self Hosted |
|-----------|--------------|-------------|
| Managed By | GitHub | User |
| Cost | Free minutes / Paid | Infrastructure Cost |
| Tools | Pre-installed | User Installs |
| Good For | General CI/CD | Custom workloads |
| Persistence | Temporary | Persistent |
| Custom Software | Limited | Unlimited |
| Security | GitHub Managed | User Responsible |

---

# Screenshots

- Hosted Runner Success
- Self Hosted Runner Idle
- Self Hosted Workflow Success

---

# Key Learnings

- GitHub Hosted Runners are ephemeral virtual machines.
- Self Hosted Runners execute workflows on your own hardware or cloud VM.
- Labels help target specific runners.
- Pre-installed software significantly reduces pipeline execution time.
- Self Hosted runners provide complete control over the execution environment.