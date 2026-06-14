# Day 25 – Git Reset vs Revert & Branching Strategies

## Introduction

Mistakes are inevitable in software development.

The real skill is not avoiding mistakes — it's knowing how to recover from them safely.

Today I explored two important Git concepts:

* Git Reset
* Git Revert

Along with understanding how real engineering teams organize their repositories using different branching strategies.

These concepts are critical because they directly impact collaboration, release management, and production stability.

---

# Task 1: Git Reset

## Create Three Commits

```bash
echo "Commit A" > file.txt
git add .
git commit -m "Commit A"

echo "Commit B" >> file.txt
git add .
git commit -m "Commit B"

echo "Commit C" >> file.txt
git add .
git commit -m "Commit C"
```

History:

```bash
git log --oneline
```

```text
A1B2C3 Commit C
D4E5F6 Commit B
G7H8I9 Commit A
```

---

# 1. Git Reset --soft

```bash
git reset --soft HEAD~1
```

Result:

```text
Commit C removed from history

Changes remain staged
```

Check:

```bash
git status
```

Output:

```text
Changes to be committed
```

### Use Case

When you want to modify the last commit message or combine commits.

---

# 2. Git Reset --mixed

```bash
git reset --mixed HEAD~1
```

Result:

```text
Commit removed

Changes remain in working directory

Nothing staged
```

Check:

```bash
git status
```

Output:

```text
Changes not staged for commit
```

### Use Case

When you want to keep your work but re-stage selectively.

---

# 3. Git Reset --hard

```bash
git reset --hard HEAD~1
```

Result:

```text
Commit removed

Changes removed

Working directory restored
```

### Use Case

Discarding unwanted work completely.

---

# Difference Between Soft, Mixed & Hard

| Command | Commit History | Staging Area | Working Directory |
| ------- | -------------- | ------------ | ----------------- |
| --soft  | Reset          | Preserved    | Preserved         |
| --mixed | Reset          | Cleared      | Preserved         |
| --hard  | Reset          | Cleared      | Deleted           |

---

## Which One is Destructive?

```bash
git reset --hard
```

Because it permanently removes changes from both the staging area and working directory.

---

## Should You Use Reset on Pushed Commits?

Generally:

❌ No

Because it rewrites history and can break collaboration.

Exception:

Only when working alone and you fully understand the consequences.

---

# Git Reflog – Your Safety Net

Even after a hard reset:

```bash
git reflog
```

shows previous Git states.

Example:

```text
HEAD@{0}: reset: moving to HEAD~1

HEAD@{1}: commit: Commit C

HEAD@{2}: commit: Commit B
```

Recover:

```bash
git reset --hard HEAD@{1}
```

---

# Task 2: Git Revert

Create:

```text
Commit X
Commit Y
Commit Z
```

History:

```text
X → Y → Z
```

---

## Revert Commit Y

Find hash:

```bash
git log --oneline
```

Example:

```text
a1b2c3 Commit Z

d4e5f6 Commit Y

g7h8i9 Commit X
```

Revert:

```bash
git revert d4e5f6
```

Git creates:

```text
Revert "Commit Y"
```

New History:

```text
X → Y → Z → Revert Y
```

---

## Is Commit Y Still There?

✅ Yes

Git does not remove it.

Instead, Git creates a new commit that reverses its changes.

---

# Reset vs Revert

| Feature                  | Git Reset                    | Git Revert             |
| ------------------------ | ---------------------------- | ---------------------- |
| Purpose                  | Move branch pointer backward | Create opposite commit |
| Removes history          | Yes                          | No                     |
| Rewrites history         | Yes                          | No                     |
| Safe for shared branches | No                           | Yes                    |
| Collaboration friendly   | No                           | Yes                    |
| Used for                 | Local cleanup                | Production fixes       |

---

## Why is Revert Safer?

Because it preserves project history.

Other developers' commits remain untouched.

No history rewriting occurs.

---

# When to Use Reset vs Revert

### Use Reset

✔ Local development

✔ Unpushed commits

✔ Cleaning commit history

---

### Use Revert

✔ Shared branches

✔ Production code

✔ Team collaboration

✔ Public repositories

---

# Task 4: Branching Strategies

Modern teams use different branching models depending on team size and release process.

---

# 1. GitFlow

## Structure

```text
main
 │
develop
 │
 ├── feature/*
 ├── release/*
 └── hotfix/*
```

---

## Workflow

Feature Branch

↓

Develop Branch

↓

Release Branch

↓

Main Branch

---

## Used In

* Enterprise teams
* Large products
* Scheduled releases

---

## Pros

✅ Structured

✅ Stable releases

✅ Supports multiple versions

---

## Cons

❌ Complex

❌ More branch management

❌ Slower development

---

# 2. GitHub Flow

## Structure

```text
main
 │
 ├── feature-1
 ├── feature-2
 └── feature-3
```

---

## Workflow

Feature Branch

↓

Pull Request

↓

Review

↓

Merge to Main

↓

Deploy

---

## Used In

* SaaS products
* Startups
* Continuous Deployment

---

## Pros

✅ Simple

✅ Fast

✅ Easy collaboration

---

## Cons

❌ Less release control

---

# 3. Trunk-Based Development

## Structure

```text
main
 │
 ├─ Short-lived Branch
 ├─ Short-lived Branch
 └─ Direct Merge
```

---

## Workflow

Small changes

↓

Frequent commits

↓

Continuous Integration

↓

Continuous Deployment

---

## Used In

* Google
* Netflix
* Facebook
* Modern DevOps Teams

---

## Pros

✅ Faster releases

✅ Reduced merge conflicts

✅ Better CI/CD

---

## Cons

❌ Requires strong testing

❌ Demands discipline

---

# Which Strategy Would I Choose?

## Startup Shipping Fast

✅ GitHub Flow

Simple and fast.

---

## Large Enterprise Team

✅ GitFlow

Better release management.

---

## Modern Cloud-Native Product

✅ Trunk-Based Development

Works best with CI/CD pipelines.

---

# Favorite Open Source Example

### Kubernetes

Uses a model close to:

```text
GitHub Flow + Release Branches
```

Development happens continuously while release branches maintain stable versions.

---

# New Commands Learned Today

```bash
git reset --soft HEAD~1

git reset --mixed HEAD~1

git reset --hard HEAD~1

git reflog

git revert <commit-hash>
```

---

# Key Learnings

## 1. Reset Rewrites History

Useful locally but dangerous for shared branches.

---

## 2. Revert is Production Friendly

Creates a new commit instead of removing history.

---

## 3. Git Reflog Can Save You

Even after a hard reset, recovery is often possible.

---

## 4. Different Teams Need Different Workflows

There is no universal branching strategy.

The best strategy depends on release frequency, team size, and deployment model.

---

# Conclusion

Today I learned how to safely undo mistakes in Git and explored the branching strategies used by startups, enterprises, and large-scale cloud-native companies.

Understanding Reset, Revert, GitFlow, GitHub Flow, and Trunk-Based Development is an important step toward working confidently in real-world development and DevOps environments.
