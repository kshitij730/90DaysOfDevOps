# Day 38 – YAML Basics

## Objective
Today I learned the fundamentals of YAML, the language used to define CI/CD pipelines, Kubernetes manifests, Docker Compose files, GitHub Actions workflows, and many DevOps configuration files.

---

# Task 1: Key-Value Pairs

## person.yaml

```yaml
name: Your Name
role: DevOps Engineer
experience_years: 1
learning: true
```

### Verification

```bash
cat person.yaml
```

Output displays clean formatting using spaces only.

---

# Task 2: Lists

Updated **person.yaml**

```yaml
name: Your Name
role: DevOps Engineer
experience_years: 1
learning: true

tools:
  - Docker
  - Git
  - GitHub
  - Linux
  - AWS

hobbies: [Coding, Reading, Cricket]
```

## Notes

YAML supports lists in two formats:

### Block Style

```yaml
tools:
  - Docker
  - Git
  - AWS
```

### Inline Style

```yaml
hobbies: [Coding, Reading, Cricket]
```

---

# Task 3: Nested Objects

## server.yaml

```yaml
server:
  name: web-server
  ip: 192.168.1.10
  port: 8080

database:
  host: localhost
  name: devops_db
  credentials:
    user: admin
    password: admin123
```

### Verification

When a **tab** was used instead of spaces:

```yaml
server:
	name: web-server
```

Validation failed because YAML only supports spaces.

---

# Task 4: Multi-line Strings

Updated **server.yaml**

```yaml
server:
  name: web-server
  ip: 192.168.1.10
  port: 8080

database:
  host: localhost
  name: devops_db
  credentials:
    user: admin
    password: admin123

startup_script_pipe: |
  sudo apt update
  sudo apt install nginx -y
  sudo systemctl start nginx

startup_script_fold: >
  sudo apt update
  sudo apt install nginx -y
  sudo systemctl start nginx
```

## Difference

### `|` Literal Block

- Preserves line breaks.
- Best for shell scripts and configuration files.

### `>` Folded Block

- Converts multiple lines into one continuous line.
- Useful for long descriptions or messages.

---

# Task 5: YAML Validation

Installed yamllint

```bash
sudo apt update
sudo apt install yamllint -y
```

Validation

```bash
yamllint person.yaml
yamllint server.yaml
```

### Broken Indentation

```yaml
server:
name: web-server
```

Error:

```
mapping values are not allowed here
```

After correcting indentation, validation passed successfully.

---

# Task 6: Spot the Difference

Correct YAML

```yaml
name: devops
tools:
  - docker
  - kubernetes
```

Broken YAML

```yaml
name: devops
tools:
- docker
  - kubernetes
```

### What's wrong?

The list items are inconsistently indented.

YAML expects list items under `tools` to use consistent indentation.

Correct version:

```yaml
tools:
  - docker
  - kubernetes
```

---

# Commands Used

```bash
cat person.yaml

cat server.yaml

yamllint person.yaml

yamllint server.yaml
```

---

# What I Learned

- YAML is indentation-sensitive and uses spaces only.
- Lists can be written using block style or inline style.
- Nested objects and multi-line strings make YAML readable and suitable for Infrastructure as Code and CI/CD pipelines.

---

## Conclusion

Successfully learned the basics of YAML syntax, created multiple YAML files, validated them using `yamllint`, understood indentation rules, nested objects, lists, and multi-line strings. These concepts provide the foundation for writing GitHub Actions workflows, Kubernetes manifests, Docker Compose files, and other CI/CD configurations.