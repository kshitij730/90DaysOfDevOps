# Day 03 – Linux Commands Cheat Sheet

## Process Management

| Command | What it does |
|---------|-------------|
| `ps aux` | List all running processes |
| `top` | Live view of CPU and memory usage |
| `kill <PID>` | Stop a process by its ID |
| `kill -9 <PID>` | Force kill a process (cannot be ignored) |
| `pgrep nginx` | Find PID of a process by name |
| `Ctrl + Z` | Pause a running process |
| `bg` | Resume a paused process in background |
| `fg` | Bring background process back to foreground |

---

## File System

| Command | What it does |
|---------|-------------|
| `pwd` | Show current directory path |
| `ls -la` | List files with details and hidden files |
| `cd /etc` | Navigate to a directory |
| `mkdir myfolder` | Create a new directory |
| `rm -rf myfolder` | Delete a folder and everything inside (careful!) |
| `cp file1 file2` | Copy a file |
| `mv file1 file2` | Move or rename a file |
| `cat file.txt` | Print file contents to terminal |
| `tail -f /var/log/syslog` | Watch a log file in real time |
| `grep "error" file.txt` | Search for a word inside a file |
| `find / -name "nginx.conf"` | Search for a file by name |
| `chmod 755 script.sh` | Change file permissions |
| `whoami` | Show current logged in user |
| `free -h` | Show RAM usage in human readable format |

---

## Networking

| Command | What it does |
|---------|-------------|
| `cat /etc/hosts` | View hostname to IP mappings |
| `cat /etc/resolv.conf` | View DNS server config |
| `curl http://localhost:8080` | Make HTTP request to a local service |

> Note: Commands like `ping`, `ip`, `ss`, `dig` may not be available in restricted sandboxes.  
> On a real server/VM these work fine: `ping google.com`, `ip addr`, `ss -tulnp`

---

## Quick Reference

```bash
# Check disk space
df -h

# See who is logged in
whoami

# Read a file
cat filename.txt

# Create an empty file
touch newfile.txt

# See last 10 lines of a file
tail -10 filename.txt
```

---

*Day 03 of #90DaysOfDevOps — Kshitij Sharma*
