# Day 07 – Linux File System Hierarchy & Scenario-Based Practice

## Part 1: Linux File System Hierarchy

### 1. `/` (Root Directory)

Purpose:
- The root directory is the starting point of the Linux file system.
- Every file and directory exists under this location.

Command:

```bash
ls -l /
```

Output:

```text
total 52
lrwxrwxrwx   1 root root    7 Apr 10 02:21 bin -> usr/bin
drwxr-xr-x   2 root root 4096 Apr 18  2022 boot
drwxr-xr-x   5 root root  380 May 22 13:46 dev
drwxr-xr-x   1 root root 4096 May 13 05:58 etc
drwxr-xr-x   1 root root 4096 May 13 05:58 home
lrwxrwxrwx   1 root root    7 Apr 10 02:21 lib -> usr/lib
lrwxrwxrwx   1 root root    9 Apr 10 02:21 lib32 -> usr/lib32
lrwxrwxrwx   1 root root    9 Apr 10 02:21 lib64 -> usr/lib64
drwxr-xr-x   2 root root 4096 Apr 10 02:21 media
drwxr-xr-x   2 root root 4096 Apr 10 02:21 mnt
drwxr-xr-x   2 root root 4096 Apr 10 02:21 opt
drwx------   2 root root 4096 Apr 10 02:31 root
drwxrwxrwt   1 root root 4096 May 22 14:00 tmp
drwxr-xr-x   1 root root 4096 Apr 10 02:21 usr
drwxr-xr-x   1 root root 4096 Apr 10 02:31 var
```

Files/Folders Observed:
- `etc`
- `var`

I would use this when:
- Navigating the complete Linux filesystem structure.

---

### 2. `/home`

Purpose:
- Stores personal files and directories for normal users.

Command:

```bash
ls -l /home
```

Output:

```text
total 4
drwxr-x--- 1 sandbox sandbox 4096 May 22 14:10 sandbox
```

Files/Folders Observed:
- `sandbox`

I would use this when:
- Accessing user files, scripts, and project folders.

---

### 3. `/root`

Purpose:
- Home directory of the root (administrator) user.
- Contains files used by system administrators.

I would use this when:
- Performing administrative tasks with root privileges.

---

### 4. `/etc`

Purpose:
- Stores system-wide configuration files.

Command:

```bash
ls -l /etc | head
```

Output:

```text
total 496
drwxr-xr-x 3 root root    4096 May 13 05:57 X11
-rw-r--r-- 1 root root    3028 Apr 10 02:22 adduser.conf
drwxr-xr-x 1 root root    4096 May 13 05:57 alternatives
drwxr-xr-x 3 root root    4096 May 13 05:57 apache2
drwxr-xr-x 1 root root    4096 Apr 10 02:22 apt
-rw-r--r-- 1 root root    2319 Jan  6  2022 bash.bashrc
```

Files/Folders Observed:
- `apache2`
- `apt`

I would use this when:
- Troubleshooting services or modifying configuration settings.

---

### 5. `/var/log`

Purpose:
- Stores application and system log files.
- One of the most important directories for DevOps troubleshooting.

Command:

```bash
ls -l /var/log
```

Output:

```text
total 676
-rw-r--r-- 1 root root  15516 May 13 05:57 alternatives.log
drwxr-xr-x 1 root root   4096 May 13 05:58 apt
-rw-r--r-- 1 root root  64549 Apr 10 02:22 bootstrap.log
-rw-rw---- 1 root utmp      0 Apr 10 02:21 btmp
-rw-r--r-- 1 root root 276956 May 13 05:58 dpkg.log
-rw-r--r-- 1 root root  32032 May 13 05:58 faillog
-rw-rw-r-- 1 root utmp 292292 May 13 05:58 lastlog
-rw-rw-r-- 1 root utmp      0 Apr 10 02:21 wtmp
```

Files/Folders Observed:
- `dpkg.log`
- `bootstrap.log`

I would use this when:
- Investigating application failures or system issues.

---

### 6. `/tmp`

Purpose:
- Stores temporary files created by users and applications.

Command:

```bash
ls -l /tmp | head
```

Output:

```text
total 4
drwxr-xr-x 2 sandbox sandbox 4096 May 22 14:02 runbook-demo
```

Files/Folders Observed:
- `runbook-demo`

I would use this when:
- Testing scripts or storing temporary files.

---

### 7. `/bin`

Purpose:
- Contains essential command binaries.
- In this system it is linked to `/usr/bin`.

Observed:
- `/bin -> usr/bin`

I would use this when:
- Running basic Linux commands.

---

### 8. `/usr/bin`

Purpose:
- Contains most executable user commands.

Observed:
- `/bin` points to `/usr/bin`.

I would use this when:
- Executing installed Linux utilities.

---

### 9. `/opt`

Purpose:
- Stores optional third-party applications.

Command:

```bash
ls -l /opt
```

Output:

```text
total 0
```

Observation:
- No optional software is currently installed.

I would use this when:
- Managing manually installed applications.

---

## Hands-On Tasks

### Find Largest Log Files

Command:

```bash
du -sh /var/log/* 2>/dev/null | sort -h | tail -5
```

Output:

```text
32K     /var/log/faillog
64K     /var/log/bootstrap.log
100K    /var/log/apt
272K    /var/log/dpkg.log
288K    /var/log/lastlog
```

Observation:
- `lastlog` and `dpkg.log` are the largest files.
- These are useful locations when troubleshooting login activity or package installations.

---

### View Hostname Configuration

Command:

```bash
cat /etc/hostname
```

Output:

```text
terminal-92732a74
```

Observation:
- The hostname uniquely identifies the machine.

---

### Check Home Directory

Command:

```bash
ls -la ~
```

Output:

```text
total 36
drwxr-x--- 1 sandbox sandbox 4096 May 22 14:10 .
drwxr-xr-x 1 root    root    4096 May 13 05:58 ..
-rw-r--r-- 1 sandbox sandbox  220 Jan  6  2022 .bash_logout
-rw-r--r-- 1 sandbox sandbox 4152 May 13 05:58 .bashrc
-rw-r--r-- 1 sandbox sandbox  807 Jan  6  2022 .profile
-rw-r--r-- 1 sandbox sandbox 3475 May 13 05:58 git-help.txt
-rw-r--r-- 1 sandbox sandbox  310 May 22 14:17 notes.txt
```

Observation:
- Hidden configuration files such as `.bashrc` and `.profile` are present.
- `notes.txt` created during Day 06 practice is visible.

---

# Part 2: Scenario-Based Practice

## Scenario 1 – Service Not Starting

Problem:
A service called `myapp` failed after reboot.

### Step 1

```bash
systemctl status myapp
```

Why:
- Check whether the service is running, stopped, or failed.

### Step 2

```bash
journalctl -u myapp -n 50
```

Why:
- Review recent logs for startup errors.

### Step 3

```bash
systemctl is-enabled myapp
```

Why:
- Verify whether the service is configured to start automatically.

### Step 4

```bash
systemctl restart myapp
```

Why:
- Attempt a restart after investigating logs.

### What I Learned

Always verify status first, review logs second, and then restart if required.

---

## Scenario 2 – High CPU Usage

Problem:
Application server becomes slow.

### Step 1

```bash
top
```

Why:
- View real-time CPU and memory consumption.

### Step 2

```bash
ps aux --sort=-%cpu | head -10
```

Output:

```text
USER         PID %CPU %MEM COMMAND
sandbox        1  0.0  0.0 /bin/bash
sandbox       13  0.0  0.0 /bin/bash
```

Why:
- Identify processes consuming the most CPU.

### Step 3

```bash
ps -p <PID> -f
```

Why:
- View detailed process information.

### Step 4

```bash
kill -15 <PID>
```

Why:
- Gracefully terminate a problematic process if necessary.

### What I Learned

Always identify the resource-consuming process before taking action.

---

## Scenario 3 – Finding Service Logs

Problem:
Developer asks for Docker service logs.

### Step 1

```bash
systemctl status docker
```

Why:
- Confirm service state.

### Step 2

```bash
journalctl -u docker -n 50
```

Why:
- Review recent Docker logs.

### Step 3

```bash
journalctl -u docker -f
```

Why:
- Follow logs in real time.

### Step 4

```bash
journalctl -u docker --since "1 hour ago"
```

Why:
- Review logs from a specific period.

### What I Learned

Systemd-managed services are commonly investigated using `journalctl`.

---

## Scenario 4 – File Permission Issue

Problem:
`backup.sh` returns "Permission denied".

### Step 1

```bash
ls -l /home/user/backup.sh
```

Why:
- Check existing permissions.

### Step 2

```bash
chmod +x /home/user/backup.sh
```

Why:
- Add execute permission.

### Step 3

```bash
ls -l /home/user/backup.sh
```

Why:
- Confirm permissions changed successfully.

### Step 4

```bash
./backup.sh
```

Why:
- Test execution.

### What I Learned

Linux scripts require execute permissions (`x`) before they can run directly.

---

# Key Takeaways

- `/etc` contains system configuration files.
- `/var/log` is the primary location for troubleshooting logs.
- `/tmp` is used for temporary files and testing.
- `systemctl` and `journalctl` are important service troubleshooting tools.
- `ps` and `top` help identify resource-heavy processes.
- File permissions directly affect script execution.