# Day 02 – Linux Architecture, Processes, and systemd

## Linux Core Components

### 1. Kernel
- The **heart of Linux** — sits between hardware and software
- Manages: CPU scheduling, memory, I/O, device drivers
- User programs never talk to hardware directly — they ask the kernel via **system calls**

### 2. User Space
- Everything that runs outside the kernel (your shell, apps, services)
- Communicates with kernel via **glibc / system calls**
- Split into: shell → libraries → applications

### 3. init / systemd
- **PID 1** — the very first process started by the kernel on boot
- Responsible for starting all other processes and services
- Modern Linux uses **systemd** (replaces old SysV init)

---

## How Processes Are Created

- Every process is **forked** from a parent process (`fork()` system call)
- Child gets a copy of parent's memory space
- `exec()` replaces the child's memory with a new program
- The chain: `kernel → systemd (PID 1) → all other processes`

```
kernel
  └── systemd (PID 1)
        ├── sshd
        ├── nginx
        ├── your-app
        └── bash → python script
```

---

## Process States

| State | Meaning |
|-------|---------|
| **R** – Running | Actively using CPU or waiting in run queue |
| **S** – Sleeping | Waiting for I/O or an event (interruptible) |
| **D** – Disk Sleep | Waiting for I/O, cannot be killed (uninterruptible) |
| **Z** – Zombie | Process finished but parent hasn't read its exit status yet |
| **T** – Stopped | Paused (via Ctrl+Z or `SIGSTOP`) |

> Zombie processes are harmless in small numbers but indicate a bug in the parent process if they pile up.

---

## What systemd Does

- Starts and stops **services** (units) in the correct order
- Handles **dependencies** between services (e.g., network must be up before sshd)
- Manages **logs** via `journald`
- Enables **parallelism** at boot (faster startup than old init)

### Key systemd Unit Types
- `.service` — a background daemon (nginx, docker, sshd)
- `.socket` — socket-based activation
- `.timer` — cron replacement

---

## 5 Daily Commands

```bash
# 1. Check status of any service
systemctl status nginx

# 2. Start / Stop / Restart a service
systemctl restart docker

# 3. View live process list (CPU + Memory)
top        # or: htop (better UI)

# 4. List all processes with details
ps aux | grep nginx

# 5. View system logs (tail last 50 lines)
journalctl -u nginx -n 50 --no-pager
```

---

## One Thing to Remember

> In DevOps, 80% of production incidents come down to:  
> a crashed process, a misconfigured service, or a log you didn't read.  
> Linux gives you the tools — systemd, ps, journalctl — to solve all three.

---

*Day 02 of #90DaysOfDevOps — Kshitij Sharma*