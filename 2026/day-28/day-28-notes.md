# Day 28 – Revision Day (Days 1–27)

## Introduction

Today was a revision day focused on reviewing everything learned during the first 27 days of the #90DaysOfDevOps journey.

Instead of learning new concepts, I revisited Linux fundamentals, Shell Scripting, Git, GitHub, Networking, AWS basics, and Volume Management to identify weak areas and strengthen my understanding.

---

# Task 1: Self-Assessment Checklist

## Linux

| Topic                              | Status                |
| ---------------------------------- | --------------------- |
| File & Directory Management        | ✅ Can do confidently  |
| Process Management                 | ✅ Can do confidently  |
| systemd Services                   | ✅ Can do confidently  |
| Vim/Nano Editing                   | ✅ Can do confidently  |
| CPU, Memory & Disk Troubleshooting | ✅ Can do confidently  |
| Linux File System Hierarchy        | ✅ Can do confidently  |
| User & Group Management            | ✅ Can do confidently  |
| File Permissions                   | ✅ Can do confidently  |
| Ownership Management               | ✅ Can do confidently  |
| LVM Management                     | ⚠️ Need more practice |
| Network Troubleshooting Commands   | ✅ Can do confidently  |
| DNS, IP, Subnetting & Ports        | ⚠️ Need more practice |

---

## Shell Scripting

| Topic                 | Status                |
| --------------------- | --------------------- |
| Variables & Arguments | ✅                     |
| Conditionals          | ✅                     |
| Loops                 | ✅                     |
| Functions             | ✅                     |
| grep, awk, sed        | ⚠️ Need more practice |
| Error Handling        | ✅                     |
| Crontab Scheduling    | ✅                     |

---

## Git & GitHub

| Topic                | Status                |
| -------------------- | --------------------- |
| Git Basics           | ✅                     |
| Branching            | ✅                     |
| Push & Pull          | ✅                     |
| Clone vs Fork        | ✅                     |
| Merge                | ✅                     |
| Rebase               | ⚠️ Need more practice |
| Stash                | ✅                     |
| Cherry Pick          | ⚠️ Need more practice |
| Squash Merge         | ✅                     |
| Reset & Revert       | ✅                     |
| Branching Strategies | ✅                     |
| GitHub CLI           | ✅                     |

---

# Task 2: Revisited Topics

## 1. LVM (Logical Volume Management)

### Re-learned

* Physical Volume (PV) → actual disks
* Volume Group (VG) → pool of storage
* Logical Volume (LV) → usable partition

### Important Commands

```bash
pvcreate
vgcreate
lvcreate
lvextend
resize2fs
```

### Key Learning

LVM provides flexibility to resize storage without repartitioning disks.

---

## 2. Git Rebase

### Re-learned

```bash
git switch feature-branch
git rebase main
```

Rebase moves feature branch commits on top of the latest main branch commits.

### Key Learning

Rebase creates cleaner linear history but should not be used on shared branches.

---

## 3. AWK & Text Processing

### Revisited

```bash
awk '{print $1}'
```

Print first column.

```bash
awk -F: '{print $1}' /etc/passwd
```

Change field separator.

### Key Learning

AWK is extremely powerful for log analysis and automation tasks.

---

# Task 3: Quick-Fire Questions

## 1. What does chmod 755 script.sh do?

Gives:

* Owner → Read, Write, Execute (7)
* Group → Read, Execute (5)
* Others → Read, Execute (5)

---

## 2. Difference between Process and Service?

Process:
A running program.

Service:
A background process managed by systemd.

Example:

```bash
nginx
sshd
docker
```

---

## 3. Find process using port 8080

```bash
sudo lsof -i :8080
```

or

```bash
sudo ss -tulpn | grep 8080
```

---

## 4. What does set -euo pipefail do?

```bash
set -e
```

Exit on command failure.

```bash
set -u
```

Treat undefined variables as errors.

```bash
set -o pipefail
```

Detect failures in pipelines.

---

## 5. Difference between git reset --hard and git revert?

### git reset --hard

Removes commits and changes.

### git revert

Creates a new commit that reverses changes.

---

## 6. Best branching strategy for 5 developers shipping weekly?

GitHub Flow.

Simple and efficient.

---

## 7. What does git stash do?

Temporarily saves uncommitted work.

Used when switching tasks without committing incomplete changes.

---

## 8. Schedule a script daily at 3 AM

```bash
0 3 * * * /path/script.sh
```

---

## 9. Difference between git fetch and git pull?

### git fetch

Downloads changes only.

### git pull

Downloads and merges changes.

---

## 10. What is LVM?

Logical Volume Management allows flexible disk management and online storage resizing.

Benefits:

* Resize volumes
* Extend storage
* Better management

---

# Task 4: Repository Check

Completed:

✅ Day 1–27 pushed to GitHub

✅ git-commands.md updated

✅ Shell Scripting Cheat Sheet completed

✅ GitHub Profile updated

✅ Repository structure verified

---

# Task 5: Teach It Back

## Explaining Git Branching to a Beginner

Imagine a Git repository is a road.

The main branch is the highway everyone uses.

When a developer wants to build a new feature, they create a separate road called a branch.

They can work freely on that branch without affecting the main highway.

Once the feature is completed and tested, the branch is merged back into the main branch.

This allows multiple developers to work simultaneously without interfering with each other's work.

Git branching is one of the most important concepts in collaborative software development because it enables safe experimentation and parallel development.

---

# Key Takeaways from Days 1–27

### Linux

Built strong foundations in administration, users, permissions, storage, and troubleshooting.

### Shell Scripting

Learned automation using variables, loops, functions, error handling, cron jobs, and real-world projects.

### Git & GitHub

Learned version control, collaboration workflows, branching, rebasing, stashing, GitHub CLI, and repository management.

### Cloud & DevOps

Developed understanding of AWS, networking fundamentals, volume management, and DevOps practices.

---

# Conclusion

The first 28 days have helped me build a solid foundation in Linux, Shell Scripting, Git, GitHub, AWS fundamentals, and DevOps practices. The revision highlighted a few areas that need more practice, particularly LVM, Git Rebase, Cherry Pick, and advanced text processing, which I will continue strengthening as I progress through the challenge.

🚀 Onward to the next phase of the #90DaysOfDevOps journey.
