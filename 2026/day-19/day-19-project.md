# Day 19 – Shell Scripting Project: Log Rotation, Backup & Crontab

## Introduction

In real-world production environments, servers generate large amounts of logs and data every day. If these logs and backups are not managed properly, they can consume disk space, affect application performance, and even cause outages.

The objective of this project was to automate common system administration tasks using Shell Scripting.

During this project, I implemented:

* Automated Log Rotation
* Automated Backup Creation
* Scheduled Execution using Cron Jobs
* Maintenance Logging
* Error Handling using Strict Mode (`set -euo pipefail`)

These are common tasks performed by DevOps Engineers, System Administrators, and Site Reliability Engineers (SREs) in production environments.

---

# Task 1: Log Rotation Script

## Objective

The goal was to automate log maintenance by:

* Compressing old log files
* Removing very old compressed logs
* Reducing disk space usage
* Improving server hygiene

---

## log_rotate.sh

```bash
#!/bin/bash

set -euo pipefail

LOG_DIR="$1"

if [ ! -d "$LOG_DIR" ]; then
    echo "Error: Directory does not exist"
    exit 1
fi

compressed_count=0
deleted_count=0

while IFS= read -r file
do
    gzip "$file"
    ((compressed_count++))
done < <(find "$LOG_DIR" -name "*.log" -mtime +7)

while IFS= read -r file
do
    rm -f "$file"
    ((deleted_count++))
done < <(find "$LOG_DIR" -name "*.gz" -mtime +30)

echo "Compressed Files: $compressed_count"
echo "Deleted Files: $deleted_count"
```

---

## Explanation

### Compress Old Logs

```bash
find "$LOG_DIR" -name "*.log" -mtime +7
```

Finds all log files older than 7 days.

---

### Compress Using Gzip

```bash
gzip filename.log
```

Converts:

```text
app.log
```

into

```text
app.log.gz
```

which consumes significantly less storage.

---

### Delete Old Archives

```bash
find "$LOG_DIR" -name "*.gz" -mtime +30
```

Deletes compressed files older than 30 days.

---

## Sample Output

```text
Compressed Files: 15
Deleted Files: 6
```

---

# Task 2: Backup Automation Script

## Objective

The goal was to automate backup creation and retention.

The script should:

* Create timestamped backups
* Verify successful creation
* Display backup size
* Remove old backups

---

## backup.sh

```bash
#!/bin/bash

set -euo pipefail

SOURCE_DIR="$1"
BACKUP_DIR="$2"

if [ ! -d "$SOURCE_DIR" ]; then
    echo "Source directory does not exist"
    exit 1
fi

mkdir -p "$BACKUP_DIR"

TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)

BACKUP_FILE="$BACKUP_DIR/backup-$TIMESTAMP.tar.gz"

tar -czf "$BACKUP_FILE" "$SOURCE_DIR"

SIZE=$(du -h "$BACKUP_FILE" | cut -f1)

echo "Backup Created Successfully"
echo "Archive: $BACKUP_FILE"
echo "Size: $SIZE"

find "$BACKUP_DIR" -name "*.tar.gz" -mtime +14 -delete
```

---

## Explanation

### Create Timestamp

```bash
date +%Y-%m-%d_%H-%M-%S
```

Example:

```text
2026-06-05_10-30-45
```

---

### Create Archive

```bash
tar -czf backup.tar.gz directory
```

Where:

* c = create
* z = gzip compression
* f = filename

---

### Backup Retention Policy

```bash
find "$BACKUP_DIR" -name "*.tar.gz" -mtime +14 -delete
```

Deletes backups older than 14 days.

---

## Sample Output

```text
Backup Created Successfully

Archive:
backup-2026-06-05_10-30-45.tar.gz

Size:
120 MB
```

---

# Task 3: Cron Jobs

## What is Cron?

Cron is a Linux scheduler used to automate repetitive tasks.

Examples:

* Backups
* Monitoring
* Health Checks
* Cleanup Tasks
* Log Rotation

---

## View Existing Cron Jobs

```bash
crontab -l
```

---

## Cron Syntax

```text
* * * * * command
│ │ │ │ │
│ │ │ │ └── Day of Week
│ │ │ └──── Month
│ │ └────── Day of Month
│ └──────── Hour
└────────── Minute
```

---

## Run Log Rotation Daily at 2 AM

```bash
0 2 * * * /home/ubuntu/scripts/log_rotate.sh /var/log/myapp
```

---

## Run Backup Every Sunday at 3 AM

```bash
0 3 * * 0 /home/ubuntu/scripts/backup.sh /home/ubuntu/data /backup
```

---

## Run Health Check Every 5 Minutes

```bash
*/5 * * * * /home/ubuntu/scripts/health_check.sh
```

---

# Task 4: Scheduled Maintenance Script

## Objective

Combine backup and log rotation into a single maintenance workflow.

---

## Features

* Log Rotation
* Backup Creation
* Timestamped Logs
* Automated Execution
* Error Handling

---

## maintenance.sh

```bash
#!/bin/bash

set -euo pipefail

LOG_FILE="/var/log/maintenance.log"

log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') : $1" >> "$LOG_FILE"
}

main() {

    log_message "Maintenance Started"

    /home/ubuntu/scripts/log_rotate.sh /var/log/myapp

    /home/ubuntu/scripts/backup.sh /home/ubuntu/data /backup

    log_message "Maintenance Completed"

}

main
```

---

## Cron Entry

```bash
0 1 * * * /home/ubuntu/scripts/maintenance.sh
```

Runs every day at 1:00 AM.

---

# Sample Maintenance Log

```text
2026-06-05 01:00:00 : Maintenance Started

2026-06-05 01:00:05 : Log Rotation Completed

2026-06-05 01:00:15 : Backup Completed

2026-06-05 01:00:15 : Maintenance Completed
```

---

# Key Learnings

## 1. Automation Saves Time

Manual maintenance tasks can be completely automated using shell scripts and cron jobs.

---

## 2. Log Rotation is Critical

Without log cleanup, disk utilization can grow rapidly and impact server performance.

---

## 3. Backups are Non-Negotiable

A system without backups is a disaster waiting to happen.

---

## 4. Cron is a DevOps Superpower

Cron enables reliable scheduling of operational tasks without human intervention.

---

## 5. Strict Mode Improves Reliability

Using:

```bash
set -euo pipefail
```

helps catch errors early and prevents silent failures.

---

# Conclusion

This project demonstrated how Shell Scripting can be used to automate real-world operational tasks such as log rotation, backup management, and scheduled maintenance. These tasks form the foundation of production system administration and are widely used across DevOps, SRE, and Infrastructure Engineering teams.
