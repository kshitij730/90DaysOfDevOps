# Day 05 – Linux Troubleshooting Runbook

## Target Process

**Process:** bash

**Reason:** The sandbox environment does not provide a full systemd setup, so Bash processes were used as the target for troubleshooting and health checks.

---

## Environment Basics

### Command 1: Check Kernel and System Information

```bash
uname -a
```

Output:

```text
Linux terminal-92732a74 6.1.0-9-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.1.27-1 (2023-05-08) x86_64 x86_64 x86_64 GNU/Linux
```

Observation:
- Linux kernel version 6.1.0-9-amd64.
- 64-bit architecture (x86_64).
- Useful for confirming the system environment before troubleshooting.

---

### Command 2: Check Operating System Details

```bash
cat /etc/os-release
```

Output:

```text
PRETTY_NAME="Ubuntu 22.04.5 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.5 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy
```

Observation:
- Operating system is Ubuntu 22.04.5 LTS.
- Debian-based distribution.
- Suitable for server and DevOps workloads.

---

## Filesystem Sanity

### Command 3: Create Temporary Directory

```bash
mkdir /tmp/runbook-demo
```

Observation:
- Created a temporary workspace for testing filesystem operations.

---

### Command 4: Copy and Verify File

```bash
cp /etc/hosts /tmp/runbook-demo/hosts-copy && ls -l /tmp/runbook-demo
```

Output:

```text
total 4
-rw-r--r-- 1 sandbox sandbox 212 May 22 14:02 hosts-copy
```

Observation:
- Successfully copied `/etc/hosts`.
- File permissions and ownership appear normal.

---

## Snapshot: CPU & Memory

### Command 5: Check Resource Usage of Target Process

```bash
ps -o pid,pcpu,pmem,comm -p 1,13
```

Output:

```text
    PID %CPU %MEM COMMAND
      1  0.0  0.0 bash
     13  0.0  0.0 bash
```

Observation:
- Two Bash processes are running.
- CPU usage is 0%.
- Memory usage is negligible.
- No evidence of resource pressure.

---

### Command 6: Check System Memory

```bash
free -h
```

Output:

```text
              total        used        free      shared  buff/cache   available
Mem:            31Gi       722Mi        29Gi       3.0Mi       1.1Gi        30Gi
Swap:             0B          0B          0B
```

Observation:
- Total memory: 31 GiB.
- Only 722 MiB in use.
- Approximately 29 GiB free.
- No swap configured.
- Memory health is excellent.

---

## Snapshot: Disk & IO

### Command 7: Check Disk Usage

```bash
df -h
```

Output:

```text
Filesystem      Size  Used Avail Use% Mounted on
overlay         197G  4.4G  185G   3% /
tmpfs            64M     0   64M   0% /dev
/dev/vda1       197G  4.4G  185G   3% /etc/hosts
shm              64M     0   64M   0% /dev/shm
tmpfs            16G     0   16G   0% /proc/asound
tmpfs            16G     0   16G   0% /proc/acpi
tmpfs            16G     0   16G   0% /sys/firmware
```

Observation:
- Root filesystem usage is only 3%.
- Approximately 185 GB available.
- No disk space concerns detected.

---

### Command 8: Check Log Directory Size

```bash
du -sh /var/log
```

Output:

```text
776K    /var/log
```

Observation:
- Log storage consumption is minimal.
- No indication of excessive log growth.

---

## Snapshot: Network

### Command 9: Check Network Utilities

```bash
ss -tulpn
```

Output:

```text
bash: ss: command not found
```

Observation:
- `ss` utility is unavailable in the sandbox.
- Alternative tools must be used.

---

### Command 10: Check Listening Network Services

```bash
netstat -tulpn
```

Output:

```text
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
```

Observation:
- No listening server processes detected.
- No unexpected open ports visible.

---

### Command 11: Verify External Connectivity

```bash
curl -I https://google.com
```

Output:

```text
HTTP/2 301
location: https://www.google.com/
content-type: text/html; charset=UTF-8
date: Fri, 22 May 2026 14:05:38 GMT
server: gws
content-length: 220
```

Observation:
- Outbound internet connectivity is working.
- DNS resolution and HTTPS connectivity are functioning correctly.
- HTTP 301 redirect is expected behavior.

---

## Logs Reviewed

### Command 12: Review Package Activity Logs

```bash
tail -n 20 /var/log/dpkg.log
```

Observation:
- Recent package activity shows Docker CLI, Docker Compose Plugin, and Docker Buildx Plugin installations.
- No package installation failures observed in the reviewed entries.

---

## Quick Findings

- Bash processes are healthy and consuming negligible resources.
- Memory utilization is very low.
- Disk usage is only 3%.
- No network services are actively listening.
- External network connectivity is functional.
- Package management logs show successful package installation activity.
- Sandbox environment has limited troubleshooting tools and does not provide full systemd functionality.

---

## If This Worsens

1. **Collect deeper diagnostics**
   - Run `top`, `htop`, `vmstat`, or `iostat`.
   - Capture resource usage over time.

2. **Increase troubleshooting visibility**
   - Review additional logs under `/var/log`.
   - Enable more verbose application logging if available.

3. **Perform process-level investigation**
   - Use `strace`, `lsof`, and detailed process inspection.
   - Identify blocked system calls, file handles, or abnormal resource consumption.

---

## Conclusion

This troubleshooting drill captured system health across CPU, memory, disk, network, and logs. No critical issues were identified. The environment appears healthy, with low resource utilization and working network connectivity.