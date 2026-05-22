# Day 04 Linux Practice

## Process Checks

### Command 1: Display Running Processes

Command:

```bash
ps aux | head
```

Output:

```text
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
sandbox        1  0.0  0.0   4628  3656 pts/0    Ss+  13:46   0:00 /bin/bash
sandbox       13  0.0  0.0   4628  3668 pts/1    Ss   13:46   0:00 /bin/bash
sandbox       25  0.0  0.0   7064  1556 pts/1    R+   13:47   0:00 ps aux
sandbox       26  0.0  0.0   2804  1012 pts/1    S+   13:47   0:00 head
```

Observation:
- `ps aux` displays all running processes.
- PID 1 is the primary Bash process in the sandbox.
- The `ps aux` and `head` commands appear because they were active during execution.

---

### Command 2: Find Bash Process IDs

Command:

```bash
pgrep bash
```

Output:

```text
1
13
```

Observation:
- Two Bash shell processes are currently running.
- `pgrep` searches for processes by name and returns their Process IDs (PIDs).

---

## Service Checks

### Command 3: List Available Services

Command:

```bash
service --status-all
```

Output:

```text
[ ? ]  hwclock.sh
[ - ]  procps
```

Observation:
- The sandbox contains only a few available services.
- `hwclock.sh` shows an unknown status (`?`).
- `procps` is inactive (`-`).
- This environment does not use a full systemd setup.

---

### Command 4: Check Service Status

Command:

```bash
service procps status
```

Output:

```text
No output returned
```

Observation:
- No status information was returned.
- Service management is limited in this sandbox environment.

---

## Log Checks

### Command 5: View Kernel Logs

Command:

```bash
dmesg | tail -20
```

Output:

```text
dmesg: read kernel buffer failed: Operation not permitted
```

Observation:
- Access to kernel logs is restricted for non-root users.
- Root privileges are required to read the kernel ring buffer.

---

### Command 6: List Available Log Files

Command:

```bash
ls /var/log
```

Output:

```text
alternatives.log
apt
bootstrap.log
btmp
dpkg.log
faillog
lastlog
wtmp
```

Observation:
- Several system log files are available.
- `dpkg.log` contains package installation and configuration activity.

---

### Command 7: View Package Management Logs

Command:

```bash
tail -n 20 /var/log/dpkg.log
```

Output:

```text
2026-05-13 05:58:14 status unpacked docker-buildx-plugin:amd64 0.33.0-1~ubuntu.22.04~jammy
2026-05-13 05:58:14 install docker-ce-cli:amd64 <none> 5:29.4.3-1~ubuntu.22.04~jammy
2026-05-13 05:58:14 status half-installed docker-ce-cli:amd64 5:29.4.3-1~ubuntu.22.04~jammy
2026-05-13 05:58:15 status unpacked docker-ce-cli:amd64 5:29.4.3-1~ubuntu.22.04~jammy
2026-05-13 05:58:15 install docker-compose-plugin:amd64 <none> 5.1.3-1~ubuntu.22.04~jammy
2026-05-13 05:58:15 status half-installed docker-compose-plugin:amd64 5.1.3-1~ubuntu.22.04~jammy
2026-05-13 05:58:16 status unpacked docker-compose-plugin:amd64 5.1.3-1~ubuntu.22.04~jammy
2026-05-13 05:58:16 startup packages configure
2026-05-13 05:58:16 configure docker-buildx-plugin:amd64 0.33.0-1~ubuntu.22.04~jammy <none>
2026-05-13 05:58:16 status unpacked docker-buildx-plugin:amd64 0.33.0-1~ubuntu.22.04~jammy
2026-05-13 05:58:16 status half-configured docker-buildx-plugin:amd64 0.33.0-1~ubuntu.22.04~jammy
2026-05-13 05:58:16 status installed docker-buildx-plugin:amd64 0.33.0-1~ubuntu.22.04~jammy
2026-05-13 05:58:16 configure docker-compose-plugin:amd64 5.1.3-1~ubuntu.22.04~jammy <none>
2026-05-13 05:58:16 status unpacked docker-compose-plugin:amd64 5.1.3-1~ubuntu.22.04~jammy
2026-05-13 05:58:16 status half-configured docker-compose-plugin:amd64 5.1.3-1~ubuntu.22.04~jammy
2026-05-13 05:58:16 status installed docker-compose-plugin:amd64 5.1.3-1~ubuntu.22.04~jammy
2026-05-13 05:58:16 configure docker-ce-cli:amd64 5:29.4.3-1~ubuntu.22.04~jammy <none>
2026-05-13 05:58:16 status unpacked docker-ce-cli:amd64 5:29.4.3-1~ubuntu.22.04~jammy
2026-05-13 05:58:16 status half-configured docker-ce-cli:amd64 5:29.4.3-1~ubuntu.22.04~jammy
2026-05-13 05:58:16 status installed docker-ce-cli:amd64 5:29.4.3-1~ubuntu.22.04~jammy
```

Observation:
- The log records package installation and configuration events.
- Docker CLI, Docker Compose Plugin, and Docker Buildx Plugin were installed successfully.

---

## Mini Troubleshooting

### Issue

Unable to inspect services using `systemctl` and unable to read kernel logs using `dmesg`.

### Troubleshooting Steps

1. Checked running processes using `ps aux`.
2. Verified Bash processes using `pgrep bash`.
3. Listed available services using `service --status-all`.
4. Attempted to check service status with `service procps status`.
5. Tried reading kernel logs using `dmesg`.
6. Investigated available log files under `/var/log`.
7. Examined package activity through `dpkg.log`.

### Findings

- The sandbox environment is not running a full systemd setup.
- Service management capabilities are limited.
- Kernel log access is restricted for non-root users.
- Package installation history can still be inspected through log files.

---

## What I Learned

- How to inspect running processes using `ps` and `pgrep`.
- How to check available services in a minimal Linux environment.
- How Linux permissions affect access to kernel logs.
- How to investigate system activity using files in `/var/log`.
- Basic troubleshooting workflow using process, service, and log inspection commands.