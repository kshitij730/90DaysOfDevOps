# Day 24 – Advanced Git: Merge, Rebase, Stash & Cherry-Pick

## Introduction

Git is much more than just commits and branches.

In real-world software development and DevOps workflows, engineers constantly work on multiple features, bug fixes, hotfixes, and releases simultaneously. To manage these workflows effectively, Git provides powerful capabilities such as:

* Merge
* Rebase
* Squash Merge
* Stash
* Cherry-Pick

Understanding these concepts is essential for collaborating on large projects and maintaining a clean Git history.

---

# Task 1: Git Merge

## Create Feature Branch

```bash
git switch master

git switch -c feature-login
```

---

## Add Commits

```bash
echo "Login Page" > login.txt

git add .

git commit -m "Add login page"

echo "Login validation" >> login.txt

git add .

git commit -m "Add login validation"
```

---

## Merge into Main

```bash
git switch master

git merge feature-login
```

### Result

Git performs:

```text
Fast Forward Merge
```

because no new commits were added to main after creating feature-login.

---

## What is Fast Forward Merge?

A fast-forward merge occurs when Git can simply move the main branch pointer forward without creating an extra merge commit.

Example:

```text
A---B---C (main)
         \
          D---E (feature)
```

After merge:

```text
A---B---C---D---E (main)
```

No merge commit is created.

---

## Merge Commit Example

Create another branch:

```bash
git switch -c feature-signup
```

Make commits:

```bash
echo "Signup Page" > signup.txt

git add .

git commit -m "Add signup page"
```

---

Move main ahead:

```bash
git switch master

echo "README Update" >> README.md

git add .

git commit -m "Update README"
```

---

Now merge:

```bash
git merge feature-signup
```

Git creates:

```text
Merge Commit
```

because both branches moved independently.

---

## What is a Merge Commit?

A merge commit combines two independent histories.

Example:

```text
        D---E
       /
A---B---C
       \
        F---G
```

After merge:

```text
        D---E
       /     \
A---B---C------M
       \
        F---G
```

---

## Merge Conflict

A merge conflict occurs when Git cannot automatically determine which changes should be kept.

Example:

Branch 1:

```text
Version A
```

Branch 2:

```text
Version B
```

Git asks you to resolve manually.

---

# Task 2: Git Rebase

## Create Branch

```bash
git switch master

git switch -c feature-dashboard
```

---

## Add Commits

```bash
git commit -m "Dashboard UI"

git commit -m "Dashboard API"

git commit -m "Dashboard Metrics"
```

---

## Move Main Forward

```bash
git switch master

git commit -m "Main branch update"
```

---

## Rebase

```bash
git switch feature-dashboard

git rebase master
```

---

## What Does Rebase Do?

Rebase rewrites commit history by moving your commits on top of another branch.

Before:

```text
A---B---C (main)
     \
      D---E---F
```

After:

```text
A---B---C---D'---E'---F'
```

Git recreates your commits.

---

## Merge vs Rebase

### Merge

Preserves complete history.

```text
Branch structure remains visible.
```

---

### Rebase

Creates cleaner linear history.

```text
Looks like work happened sequentially.
```

---

## Why Not Rebase Shared Commits?

Because rebase changes commit hashes.

If other developers already pulled those commits:

```text
History diverges
Conflicts increase
Collaboration becomes difficult
```

---

## When to Use Rebase?

Use:

* Before opening Pull Requests
* Cleaning local history
* Syncing feature branch with main

Avoid:

* Rewriting shared history

---

# Task 3: Squash Merge vs Regular Merge

## Create Branch

```bash
git switch -c feature-profile
```

Create multiple commits:

```bash
git commit -m "Profile UI"

git commit -m "Fix typo"

git commit -m "Fix CSS"

git commit -m "Update layout"
```

---

## Squash Merge

```bash
git switch master

git merge --squash feature-profile
```

Commit:

```bash
git commit -m "Add complete profile feature"
```

---

## Result

Instead of:

```text
Commit 1
Commit 2
Commit 3
Commit 4
```

Git creates:

```text
Single Commit
```

---

## What is Squash Merge?

Combines multiple commits into one commit.

Benefits:

* Cleaner history
* Easier review
* Better release tracking

---

## Trade-Off

You lose detailed commit history.

---

## Regular Merge

```bash
git merge feature-settings
```

All commits remain visible.

---

# Task 4: Git Stash

## Create Uncommitted Changes

```bash
echo "Work in progress" >> notes.txt
```

---

## Save Work

```bash
git stash
```

Output:

```text
Saved working directory
```

---

## Switch Branch

```bash
git switch master
```

Now working directory becomes clean.

---

## View Stashes

```bash
git stash list
```

Example:

```text
stash@{0}
stash@{1}
stash@{2}
```

---

## Apply Latest Stash

```bash
git stash pop
```

---

## Apply Without Removing

```bash
git stash apply
```

---

## Apply Specific Stash

```bash
git stash apply stash@{1}
```

---

## Difference Between Pop and Apply

### git stash pop

Apply + remove stash.

---

### git stash apply

Apply but keep stash.

---

## Real-World Use Case

Imagine:

* Working on Feature A
* Production issue arrives

Instead of committing unfinished work:

```bash
git stash
```

Switch branch.

Fix issue.

Return later.

Restore work.

---

# Task 5: Cherry-Pick

## Create Branch

```bash
git switch -c feature-hotfix
```

Create commits:

```bash
git commit -m "Hotfix 1"

git commit -m "Hotfix 2"

git commit -m "Hotfix 3"
```

---

## View Commit Hashes

```bash
git log --oneline
```

Example:

```text
a1b2c3 Hotfix 1

d4e5f6 Hotfix 2

g7h8i9 Hotfix 3
```

---

## Cherry-Pick Only One Commit

```bash
git switch main

git cherry-pick d4e5f6
```

---

## Result

Only:

```text
Hotfix 2
```

appears on main.

---

## What Does Cherry-Pick Do?

Cherry-pick copies a specific commit from one branch and applies it to another.

---

## Real-World Use Cases

* Production hotfixes
* Backporting bug fixes
* Applying selective changes

---

## Risks

Can create:

* Duplicate commits
* Merge conflicts
* Confusing history

if overused.

---

# New Git Commands Learned Today

```bash
git merge

git merge --squash

git rebase

git stash

git stash list

git stash pop

git stash apply

git cherry-pick

git log --oneline --graph --all
```

---

# Key Learnings

## 1. Merge Preserves History

Merging keeps the complete branch structure and collaboration history intact.

---

## 2. Rebase Creates Cleaner History

Rebasing rewrites commits to create a linear commit history.

---

## 3. Stash Helps During Context Switching

Stash is extremely useful when urgent work interrupts ongoing development.

---

## 4. Cherry-Pick is a Surgical Tool

Cherry-pick allows applying only specific commits without merging an entire branch.

---

## 5. Squash Merge Keeps Repositories Clean

Squashing combines multiple small commits into a single meaningful commit.

---

# Conclusion

Today I explored advanced Git workflows used daily by software engineers, DevOps engineers, and platform teams. Understanding merge, rebase, stash, squash merge, and cherry-pick is essential for maintaining clean repositories, collaborating effectively, and managing complex development workflows.
