# Day 23 – Git Branching & Working with GitHub

## Introduction

After learning the fundamentals of Git such as repositories, staging, commits, and commit history, the next step is understanding one of Git's most powerful features: **Branching**.

Branches allow developers to work on new features, bug fixes, and experiments without affecting the main codebase. This is the foundation of modern software development and DevOps workflows.

In this exercise, I learned how to create branches, switch between them, push code to GitHub, pull changes, and understand the difference between cloning and forking repositories.

---

# Task 1: Understanding Branches

## 1. What is a Branch in Git?

A branch is an independent line of development in Git.

It allows developers to work on features or fixes separately from the main codebase without affecting the stable version of the project.

---

## 2. Why Use Branches Instead of Committing Everything to Main?

If all developers commit directly to `main`, there is a higher risk of introducing bugs and breaking production code.

Branches provide:

* Isolation
* Safer development
* Easier collaboration
* Better code review workflows

---

## 3. What is HEAD in Git?

`HEAD` is a pointer that indicates the current branch and commit you are working on.

Example:

```bash
HEAD -> master
```

This means Git is currently pointing to the latest commit on the `master` branch.

---

## 4. What Happens When You Switch Branches?

Git updates your working directory to match the files and commits stored in that branch.

Files unique to another branch may disappear, while files existing in the target branch become available.

---

# Task 2: Branching Commands

## List Branches

```bash
git branch
```

Output:

```bash
* master
```

---

## Create Branch

```bash
git branch feature-1
```

---

## Switch to Branch

```bash
git checkout feature-1
```

or

```bash
git switch feature-1
```

---

## Create and Switch in One Command

```bash
git checkout -b feature-2
```

or

```bash
git switch -c feature-2
```

---

## Difference Between git checkout and git switch

### git checkout

Can:

* Switch branches
* Restore files
* Checkout commits

Example:

```bash
git checkout feature-1
```

---

### git switch

Introduced to simplify branch switching.

Example:

```bash
git switch feature-1
```

Recommended for branch operations.

---

## Create Commit on feature-1

```bash
git switch feature-1

echo "Feature 1 Notes" >> feature.txt

git add .

git commit -m "Add feature-1 notes"
```

---

## Verify Commit Doesn't Exist on Main

```bash
git switch master

ls
```

The `feature.txt` file will not appear because it only exists in the feature branch.

---

## Delete Branch

```bash
git branch -d feature-2
```

Force Delete:

```bash
git branch -D feature-2
```

---

# New Commands Added to git-commands.md

```bash
git branch

git checkout

git checkout -b

git switch

git switch -c

git branch -d

git branch -D
```

---

# Task 3: Push to GitHub

## Create GitHub Repository

Create:

```text
devops-git-practice
```

without README.

---

## Connect Local Repository

```bash
git remote add origin https://github.com/username/devops-git-practice.git
```

Verify:

```bash
git remote -v
```

---

## Push Main Branch

```bash
git push -u origin master
```

---

## Push Feature Branch

```bash
git switch feature-1

git push -u origin feature-1
```

---

## Verify Branches on GitHub

GitHub should display:

```text
main
feature-1
```

under the branch selector.

---

## Difference Between Origin and Upstream

### Origin

Your own repository.

Example:

```text
https://github.com/yourusername/repository
```

---

### Upstream

Original repository from which a fork was created.

Example:

```text
https://github.com/original-owner/repository
```

---

# Task 4: Pull Changes from GitHub

## Make Change on GitHub

Edit:

```text
git-commands.md
```

directly from GitHub.

Commit changes.

---

## Pull Changes Locally

```bash
git pull origin master
```

---

## Difference Between Fetch and Pull

### git fetch

Downloads changes from remote.

Does NOT merge them.

```bash
git fetch origin
```

---

### git pull

Downloads and automatically merges changes.

```bash
git pull origin master
```

---

# Task 5: Clone vs Fork

## Clone Repository

```bash
git clone https://github.com/example/project.git
```

Creates a local copy.

---

## Fork Repository

Fork using GitHub UI.

Then clone your fork:

```bash
git clone https://github.com/yourusername/project.git
```

---

## Difference Between Clone and Fork

### Clone

Git operation.

Creates a local copy of a repository.

---

### Fork

GitHub feature.

Creates a copy under your GitHub account.

---

## When to Use Clone?

When:

* You already have repository access
* Internal team projects
* Company projects

---

## When to Use Fork?

When:

* Contributing to open-source projects
* You don't have direct write access

---

## Keeping Fork Updated

Add upstream:

```bash
git remote add upstream https://github.com/original-owner/project.git
```

Verify:

```bash
git remote -v
```

Fetch updates:

```bash
git fetch upstream
```

Merge updates:

```bash
git merge upstream/main
```

---

# Key Learnings

## 1. Branches Enable Safe Development

Branches allow experimentation without affecting stable code.

---

## 2. GitHub and Git Work Together

Git handles version control locally.

GitHub provides collaboration and remote repository hosting.

---

## 3. Forking is Essential for Open Source

Most open-source contributions begin with a fork, followed by cloning, development, and pull requests.

---

# Git Commands Learned Today

```bash
git branch

git checkout

git checkout -b

git switch

git switch -c

git branch -d

git remote add origin

git remote -v

git push

git fetch

git pull

git clone
```

---

# Conclusion

Today I learned how developers collaborate safely using Git branches and GitHub. Understanding branching, remotes, pushing, pulling, cloning, and forking is a major step toward working on real-world software projects and DevOps workflows.

These concepts are the foundation of modern CI/CD pipelines, Infrastructure as Code repositories, and collaborative software development.
