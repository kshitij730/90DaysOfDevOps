# Day 49 – DevSecOps: Adding Security to My CI/CD Pipeline

**Repository:** https://github.com/kshitij730/github-actions-capstone

## Objective

The goal of Day 49 was to improve the CI/CD pipeline by integrating security checks into every stage of the software delivery process. Instead of checking security after deployment, security scans now run automatically during Pull Requests and before deployment to production.

This follows the **DevSecOps** approach where development, operations, and security work together to identify and fix vulnerabilities as early as possible.

---

# What is DevSecOps?

DevSecOps is the practice of integrating security into every phase of the DevOps lifecycle. Rather than performing security testing only after an application is deployed, automated security checks become part of the CI/CD pipeline.

In this project, security scans now run automatically whenever code is pushed or a Pull Request is created. This helps detect vulnerabilities, insecure dependencies, and leaked secrets before they reach production.

---

# Tasks Completed

## Task 1 – Docker Image Vulnerability Scanning (Trivy)

I integrated **Trivy** into the GitHub Actions pipeline to scan Docker images after they are built and before deployment.

### Features Implemented

* Docker image vulnerability scanning
* Detection of Operating System vulnerabilities
* Detection of application library vulnerabilities
* HIGH and CRITICAL severity filtering
* Automatic pipeline failure if serious vulnerabilities are found
* Trivy report generation as an artifact

Example configuration:

```yaml
- name: Scan Docker Image
  uses: aquasecurity/trivy-action@master
  with:
    image-ref: scan-target:latest
    format: table
    severity: HIGH,CRITICAL
    exit-code: "1"
```

### Outcome

* Vulnerabilities are detected automatically.
* Deployment stops when HIGH or CRITICAL vulnerabilities exist.
* Developers receive immediate feedback during CI.

**Screenshot**

> *(Insert screenshot of the Trivy scan from the GitHub Actions workflow.)*

---

# Task 2 – GitHub Secret Scanning

GitHub Secret Scanning was enabled through the repository security settings.

### Secret Scanning

Secret Scanning continuously monitors commits for accidentally committed secrets like:

* AWS Keys
* GitHub Tokens
* API Keys
* Database Passwords
* Private Keys

Whenever a secret is detected, GitHub immediately generates a security alert.

---

## Push Protection

Push Protection extends Secret Scanning by blocking pushes before they reach GitHub.

Instead of only reporting leaked credentials, GitHub prevents them from being committed.

### Difference Between Secret Scanning and Push Protection

| Secret Scanning                              | Push Protection                       |
| -------------------------------------------- | ------------------------------------- |
| Detects leaked secrets after they are pushed | Blocks secrets before they are pushed |
| Creates Security Alerts                      | Prevents the push completely          |
| Helps identify leaked credentials            | Prevents accidental exposure          |

### Example

If an AWS Access Key is committed:

* Secret Scanning creates a security alert.
* Push Protection blocks the push completely until the secret is removed.

---

# Task 3 – Dependency Vulnerability Review

The Pull Request pipeline now includes GitHub's Dependency Review Action.

```yaml
- name: Dependency Review
  uses: actions/dependency-review-action@v4
  with:
    fail-on-severity: critical
```

### What it checks

* Newly added packages
* Dependency vulnerabilities
* Known CVEs
* License issues

### Pipeline Behaviour

If a Pull Request introduces a dependency containing a **Critical** vulnerability, the workflow fails automatically.

This prevents insecure packages from being merged into the main branch.

---

# Task 4 – Least Privilege Permissions

Workflow permissions were restricted to follow the Principle of Least Privilege.

Instead of giving every workflow full repository access, only the permissions required for each workflow are granted.

Example:

```yaml
permissions:
  contents: read
```

For Pull Request workflows:

```yaml
permissions:
  contents: read
  pull-requests: write
```

### Why this is important

If a third-party GitHub Action becomes compromised, limited permissions reduce the damage it can cause.

Without restricted permissions, a malicious action could:

* Push code
* Delete branches
* Create releases
* Modify workflows
* Steal repository contents

Using minimal permissions significantly improves repository security.

---

# Secure CI/CD Pipeline

```
Developer Opens Pull Request
           │
           ▼
      Build & Test
           │
           ▼
 Dependency Review Scan
           │
           ▼
     PR Checks Passed
           │
           ▼
      Merge to Main
           │
           ▼
      Build & Test
           │
           ▼
      Docker Build
           │
           ▼
 Trivy Image Vulnerability Scan
           │
     ┌─────┴─────┐
     │           │
 Vulnerable    Secure
     │           │
 Pipeline      Docker Push
  Failed          │
                  ▼
              Deployment
                  │
                  ▼
             Production

Background Security

✔ GitHub Secret Scanning

✔ Push Protection

✔ Restricted Workflow Permissions
```

---

# Security Tools Used

| Tool                     | Purpose                             |
| ------------------------ | ----------------------------------- |
| GitHub Actions           | CI/CD Automation                    |
| Trivy                    | Docker Image Vulnerability Scanning |
| Dependency Review Action | Dependency Security Checks          |
| GitHub Secret Scanning   | Detect Leaked Secrets               |
| Push Protection          | Prevent Secret Leaks                |
| Docker                   | Containerization                    |
| GitHub Secrets           | Secure Credential Storage           |

---

# Challenges Faced

While implementing DevSecOps, I encountered several issues:

* Trivy workflow version compatibility issues.
* Flake8 formatting errors in the Python application.
* SonarCloud authentication problems due to incorrect configuration and token validation.
* GitHub Actions workflow syntax errors caused by incorrect YAML indentation.
* Reusable workflow secret forwarding issues.
* Dependency and Docker scan configuration problems.

Each issue was resolved by updating workflow configurations, correcting YAML syntax, fixing Python formatting, and configuring GitHub Secrets correctly.

---

# Key Learnings

* Security should be integrated into CI/CD from the beginning instead of after deployment.
* Automated vulnerability scanning helps identify risks early.
* Docker images should always be scanned before deployment.
* Dependency Review prevents insecure packages from entering the project.
* Secret Scanning protects repositories from accidentally leaked credentials.
* Push Protection prevents secrets from ever reaching GitHub.
* GitHub Secrets should always be used instead of hardcoding credentials.
* Restricting workflow permissions improves overall pipeline security.
* DevSecOps makes software delivery both faster and more secure.

---

# Repository

GitHub Repository:

**https://github.com/kshitij730/github-actions-capstone**

---

# Conclusion

This project successfully transformed a standard CI/CD pipeline into a DevSecOps pipeline by integrating automated security practices. Docker images are scanned using Trivy, dependencies are checked for known vulnerabilities, GitHub protects against leaked secrets, and workflow permissions follow the Principle of Least Privilege.

As a result, security is now an automated part of the development lifecycle rather than a manual activity performed after deployment. This approach improves software quality, reduces security risks, and ensures that only secure code is deployed to production.
