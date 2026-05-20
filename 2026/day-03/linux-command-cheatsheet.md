# Day 03 – Linux Commands Cheat Sheet

## Process Management

| Command | What it does |
|---------|-------------|
| `ps aux` | List all running processes |
| `top` | Live view of CPU and memory usage |
| `kill <PID>` | Stop a process by its ID |
| `kill -9 <PID>` | Force kill a process (cannot be ignored) |
| `pgrep nginx` | Find PID of a process by name |
| `jobs` | List background jobs in current shell |
| `Ctrl + Z` | Pause a running process |
| `bg` | Resume a paused process in background |

---

## File System

| Command | What it does |
|---------|-------------|
| `pwd` | Show current directory path |
| `ls -la` | List files with details and hidden files |
| `cd /etc` | Navigate to a directory |
| `mkdir myfolder` | Create a new directory |
| `rm -rf myfolder` | Delete a folder and everything inside it |
| `cp file1 file2` | Copy a file |
| `mv file1 file2` | Move or rename a file |
| `cat file.txt` | Print file contents to terminal |
| `tail -f /var/log/syslog` | Watch a log file in real time |
| `grep "error" file.txt` | Search for a word inside a file |
| `find / -name "nginx.conf"` | Search for a file by name |
| `chmod 755 script.sh` | Change file permissions |

---

## Networking

| Command | What it does |
|---------|-------------|
| `ping google.com` | Check if a host is reachable |
| `ip addr` | Show network interfaces and IP addresses |
| `curl http://localhost:8080` | Make an HTTP request from terminal |
| `dig google.com` | DNS lookup for a domain |

---

## Quick Reference

```bash
# Find what is using port 8080
ss -tulnp | grep 8080

# Check disk space
df -h

# Check memory usage
free -h
```

---

*Day 03 of #90DaysOfDevOps — Kshitij Sharma*