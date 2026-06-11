# Day 22 – Introduction to Git: Your First Repository

## What is Git?

Git is a distributed version control system used to track changes in files, collaborate with teams, and maintain project history.

In DevOps, Git is one of the most important tools because almost everything revolves around version control:

* Infrastructure as Code (Terraform)
* CI/CD Pipelines
* Kubernetes Manifests
* Application Source Code
* Configuration Management

Think of Git as a time machine for your code.

---

# Task 1: Install and Configure Git

## Verify Git Installation

```bash
git --version
```

Example Output:

```bash
git version 2.43.0
```

---

## Configure Git Username

```bash
git config --global user.name "Your Name"
```

Example:

```bash
git config --global user.name "kshitij730"
```

---

## Configure Git Email

```bash
git config --global user.email "yourmail@example.com"
```

Example:

```bash
git config --global user.email "kshitijsharma730@gmail.com"
```

---

## Verify Configuration

```bash
git config --list
```

Output:

```bash
user.name=kshitij730
user.email=kshitijsharma730@gmail.com
core.repositoryformatversion=0
core.filemode=true
core.bare=false
core.logallrefupdates=true
```

---

# Task 2: Create Your Git Project

## Create Directory

```bash
mkdir devops-git-practice
```

Move into directory:

```bash
cd devops-git-practice
```

---

## Initialize Repository

```bash
git init
```

Output:

```bash
Initialized empty Git repository
```

---

## Check Status

```bash
git status
```

Example:

```bash
On branch master

No commits yet

nothing to commit (create/copy files and use "git add" to track)
```

---

## Explore .git Directory

```bash
ls -la
```

Output:

```bash
total 12
drwxrwxr-x  3 kshitij kshitij 4096 Jun 11 14:32 .
drwxr-x--- 11 kshitij kshitij 4096 Jun 11 14:32 ..
drwxrwxr-x  7 kshitij kshitij 4096 Jun 11 14:32 .git
```

Explore:

```bash
cd .git
ls
```

You will see:

```bash
HEAD  
branches  
config  
description  
hooks  
info  
objects  
refs
```

### Purpose

| Component  | Purpose |
|------------|----------|
| HEAD       | Points to the current branch or latest commit you are working on. Git uses HEAD to know your current position in the repository. |
| branches   | Stores references to local branches (older Git versions; now mostly managed under refs/heads). |
| config     | Contains repository-specific Git configuration such as username, email, remotes, and settings. |
| description| Used by GitWeb and other repository browsing tools to describe the repository. Usually not important for local development. |
| hooks      | Contains hook scripts that automate actions before or after Git events like commits, pushes, and merges. |
| info       | Stores additional repository information such as exclude patterns that apply only to the local repository. |
| objects    | The most important directory. Stores all Git objects including commits, trees, blobs (file contents), and tags. |
| refs       | Stores references to branches and tags. Includes refs/heads (branches) and refs/tags (tags). |

---

# Task 3: Create Git Commands Reference

Create:

```bash
touch git-commands.md
```

---

# git-commands.md

```markdown
# Git Commands Cheat Sheet

## Setup & Configuration

### Check Git Version

git --version

Displays installed Git version.

Example:

git --version

---

### Configure Username

git config --global user.name "Kshitij Sharma"

Sets Git username.

---

### Configure Email

git config --global user.email "kshitij@gmail.com"

Sets Git email address.

---

## Basic Workflow

### Initialize Repository

git init

Creates a new Git repository.

---

### Stage Changes

git add filename

Adds file to staging area.

Example:

git add git-commands.md

---

### Commit Changes

git commit -m "Initial commit"

Creates a snapshot of staged changes.

---

## Viewing Changes

### Check Status

git status

Shows current repository state.

---

### View History

git log

Shows commit history.

---

### Compact History

git log --oneline

Displays history in one-line format.
```

---

# Task 4: Stage and Commit

## Stage File

```bash
git add git-commands.md
```

---

## Check Staged Changes

```bash
git status
```

Output:

```bash
On branch master

No commits yet

Changes to be committed:
  (use "git rm --cached <file>..." to unstage)
        new file:   git-commands.md
```

---

## First Commit

```bash
git commit -m "Add initial Git command reference"
```

---

## View Commit History

```bash
git log
```

---

# Task 5: Build Commit History

## Second Update

Add:

```bash
git diff
```

Commit:

```bash
git add .
git commit -m "Add diff command documentation"
```

---

## Third Update

Add:

```bash
git show
```

Commit:

```bash
git add .
git commit -m "Document git show command"
```

---

## Fourth Update

Add:

```bash
git branch
```

Commit:

```bash
git add .
git commit -m "Add branch management commands"
```

---

## View Compact History

```bash
git log --oneline
```

Example:

```bash
84b79ca (HEAD -> master) Add repository information commands
1b62465 Add git history and diff commands
5049bb9 Add basic git workflow commands
6715112 Add Git setup commands
9b4d3f3 practice git commands
```

---

# Task 6: day-22-notes.md

## What is the difference between git add and git commit?

`git add` moves changes from the working directory into the staging area.

`git commit` saves the staged changes permanently into Git history.

---

## What does the staging area do?

The staging area acts as a preparation zone before committing.

It allows developers to choose exactly which changes should be included in a commit.

---

## What information does git log show?

`git log` shows:

* Commit ID
* Author
* Date
* Commit Message

It helps track project history.

---

## What is the .git folder?

The `.git` directory contains all repository metadata including commits, branches, configuration, and history.

Without it, the project is no longer a Git repository.

---

## Difference Between Working Directory, Staging Area, and Repository

### Working Directory

Where files are actively edited.

### Staging Area

Temporary area where selected changes wait before commit.

### Repository

Permanent Git history containing all commits and snapshots.

---

# Key Learnings

### 1. Git Tracks Everything

Every commit creates a snapshot that can be restored later.

### 2. Staging Area Gives Control

Git allows selective commits instead of committing every change.

### 3. Commit Messages Matter

Good commit messages make project history easier to understand and maintain.

---

# Git Commands Used Today

```bash
git --version
git config --global user.name
git config --global user.email
git config --list
git init
git status
git add
git commit
git log
git log --oneline
ls -la
```

---

# Submission Commands

```bash
mkdir -p 2026/day-22

git add .

git commit -m "Complete Day 22 Git Fundamentals"

git push origin main
```
