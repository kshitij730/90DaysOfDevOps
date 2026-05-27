# Day 12 – Revision & Consolidation (Days 01–11)

## Purpose

Today was a revision day focused on reinforcing Linux and DevOps fundamentals learned during Days 01–11. Instead of learning new concepts, I reviewed previous exercises, repeated important commands, and identified areas that need more practice.

---

# 1. Mindset & Learning Plan Review

### Original Goal
- Build strong Linux fundamentals
- Learn DevOps tools step by step
- Practice hands-on instead of only watching tutorials
- Create a public learning record through GitHub and LinkedIn

### Review After 11 Days

What is working:
- Daily consistency
- Hands-on Linux practice
- Documentation of assignments
- Better understanding of Linux commands and troubleshooting

What I want to improve:
- Faster command recall without searching notes
- More confidence with permissions and ownership management
- More shell scripting practice
- More cloud deployment exercises

---

# 2. Processes & Services Revision

### Command 1

```bash
ps aux
```

Purpose:
- View running processes.

Observation:
- Displays all active processes with CPU and memory usage.
- Useful for identifying resource-heavy applications.

---

### Command 2

```bash
systemctl status nginx
```

Purpose:
- Verify whether Nginx service is running correctly.

Observation:
- Shows service state, uptime, process ID, and recent logs.
- First command I would use during troubleshooting.

---

### Command 3

```bash
journalctl -u nginx -n 20
```

Purpose:
- Review recent Nginx logs.

Observation:
- Helps identify startup failures and configuration issues.
- Provides historical service information.

---

# 3. File Skills Revision

### Create Directory

```bash
mkdir practice-directory
```

Purpose:
- Create a new directory.

---

### Copy File

```bash
cp notes.txt backup-notes.txt
```

Purpose:
- Create a backup copy of a file.

---

### Append Text

```bash
echo "Revision Day Notes" >> notes.txt
```

Purpose:
- Add new content to an existing file.

---

### Check Permissions

```bash
ls -l
```

Purpose:
- Verify ownership and permission settings.

---

### Change Permissions

```bash
chmod 755 script.sh
```

Purpose:
- Give execute permissions while maintaining controlled access.

---

# 4. Cheat Sheet Refresh (Top 5 Incident Commands)

## 1. ps aux

Why:
- Quickly identify running processes and resource usage.

---

## 2. top

Why:
- Real-time system monitoring.

---

## 3. df -h

Why:
- Check disk usage and available storage.

---

## 4. journalctl -u <service>

Why:
- Investigate service-related logs.

---

## 5. systemctl status <service>

Why:
- Verify service health and status immediately.

---

# 5. User & Group Management Revision

### Create User

```bash
sudo useradd testuser
```

### Verify User

```bash
id testuser
```

### Change Ownership

```bash
sudo chown testuser:testuser sample.txt
```

### Verify Ownership

```bash
ls -l sample.txt
```

Observation:
- Ownership changes are reflected immediately.
- Verification should always be performed after modifying permissions.

---

# Mini Self-Check

## 1. Which 3 commands save you the most time right now, and why?

### ps aux

- Quickly identifies running processes.
- Useful during troubleshooting.

### systemctl status

- Immediately shows service health.
- Displays recent logs and service state.

### df -h

- Quickly reveals storage problems.
- Easy way to detect full disks.

---

## 2. How do you check if a service is healthy?

Commands:

```bash
systemctl status nginx
```

```bash
journalctl -u nginx -n 20
```

```bash
ps aux | grep nginx
```

Reason:
- Verify service state.
- Check recent logs.
- Confirm process existence.

---

## 3. How do you safely change ownership and permissions without breaking access?

Example:

```bash
sudo chown ubuntu:ubuntu app.log
```

```bash
chmod 644 app.log
```

Verification:

```bash
ls -l app.log
```

Reason:
- Always verify ownership before changing permissions.
- Confirm changes using `ls -l`.

---

## 4. What will you focus on improving in the next 3 days?

1. Shell scripting fundamentals
2. Linux permissions and ownership management
3. Cloud server administration and deployments
4. Faster troubleshooting workflows
5. More command-line practice without notes

---

# Key Takeaways

- Consistency is improving command recall.
- Linux troubleshooting starts with processes, services, and logs.
- File permissions must always be verified after modification.
- Cloud deployments require both Linux and networking knowledge.
- Documentation helps reinforce learning and creates a reusable knowledge base.
- Practical exercises are significantly more effective than passive learning.

---

# Revision Summary

Days Reviewed: Day 01 – Day 11

Topics Reinforced:
- Linux Basics
- Linux Commands
- Processes & Services
- Log Analysis
- File Operations
- File Permissions
- User & Group Management
- Linux File System Hierarchy
- Shell Scripting Basics
- Cloud Server Deployment
- Troubleshooting Fundamentals

Status: ✅ Revision Complete