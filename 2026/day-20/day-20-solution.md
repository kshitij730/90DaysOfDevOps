# Day 20 – Bash Scripting Challenge: Log Analyzer & Report Generator

## Introduction

Logs are one of the most valuable sources of information in any production environment.

Whether you're troubleshooting application failures, investigating security incidents, monitoring infrastructure health, or identifying performance bottlenecks, logs provide critical insights into what is happening inside a system.

In this project, I built a Bash-based Log Analyzer that automates the process of:

* Validating log files
* Counting errors
* Identifying critical events
* Finding the most common errors
* Generating detailed reports
* Archiving processed logs

This project simulates a real-world DevOps/System Administration use case.

---

# Task 1: Input Validation

## Objective

The script should:

* Accept a log file as an argument
* Check if an argument was provided
* Verify that the file exists
* Exit gracefully if validation fails

---

# log_analyzer.sh

```bash
#!/bin/bash

set -euo pipefail

if [ $# -eq 0 ]; then
    echo "Usage: $0 <log_file>"
    exit 1
fi

LOG_FILE="$1"

if [ ! -f "$LOG_FILE" ]; then
    echo "Error: File '$LOG_FILE' does not exist"
    exit 1
fi
```

---

## Example

```bash
./log_analyzer.sh sample_log.log
```

---

# Task 2: Error Count

## Objective

Count all lines containing:

* ERROR
* Failed

---

```bash
ERROR_COUNT=$(grep -Ei "ERROR|Failed" "$LOG_FILE" | wc -l)

echo "Total Errors Found: $ERROR_COUNT"
```

---

## Example Output

```text
Total Errors Found: 47
```

---

# Task 3: Critical Events

## Objective

Find all CRITICAL events and display line numbers.

---

```bash
CRITICAL_EVENTS=$(grep -n "CRITICAL" "$LOG_FILE" || true)
```

---

## Example Output

```text
--- Critical Events ---

84: 2026-08-01 10:15:23 CRITICAL Disk space below threshold

217: 2026-08-01 14:32:01 CRITICAL Database connection lost
```

---

# Task 4: Top 5 Error Messages

## Objective

Identify the most frequently occurring error messages.

---

```bash
TOP_ERRORS=$(grep "ERROR" "$LOG_FILE" \
| awk '{$1=$2=$3=""; print}' \
| sort \
| uniq -c \
| sort -rn \
| head -5)
```

---

## Example Output

```text
--- Top 5 Error Messages ---

45 Connection timed out

32 File not found

28 Permission denied

15 Disk I/O error

9 Out of memory
```

---

# Task 5: Summary Report Generation

## Objective

Generate a report containing:

* Analysis Date
* Log File Name
* Total Lines Processed
* Error Count
* Top Errors
* Critical Events

---

```bash
REPORT_FILE="log_report_$(date +%Y-%m-%d).txt"

TOTAL_LINES=$(wc -l < "$LOG_FILE")

{
echo "====================================="
echo "        LOG ANALYSIS REPORT"
echo "====================================="
echo
echo "Date: $(date)"
echo "Log File: $LOG_FILE"
echo "Total Lines: $TOTAL_LINES"
echo "Total Errors: $ERROR_COUNT"

echo
echo "----- Top 5 Errors -----"
echo "$TOP_ERRORS"

echo
echo "----- Critical Events -----"
echo "$CRITICAL_EVENTS"

} > "$REPORT_FILE"
```

---

## Example Report

### log_report_2026-08-01.txt

```text
=====================================
LOG ANALYSIS REPORT
=====================================

Date:
Fri Aug 01 10:45:12 UTC 2026

Log File:
sample_log.log

Total Lines:
1250

Total Errors:
47

----- Top 5 Errors -----

45 Connection timed out
32 File not found
28 Permission denied
15 Disk I/O error
9 Out of memory

----- Critical Events -----

84: CRITICAL Disk space below threshold

217: CRITICAL Database connection lost
```

---

# Task 6: Archive Processed Logs

## Objective

Move processed logs to an archive directory after analysis.

---

```bash
mkdir -p archive

mv "$LOG_FILE" archive/

echo "Log archived successfully."
```

---

## Example Output

```text
Log archived successfully.

Location:
archive/sample_log.log
```

---

# Complete Script

```bash
#!/bin/bash

set -euo pipefail

if [ $# -eq 0 ]; then
    echo "Usage: $0 <log_file>"
    exit 1
fi

LOG_FILE="$1"

if [ ! -f "$LOG_FILE" ]; then
    echo "Error: File '$LOG_FILE' not found"
    exit 1
fi

ERROR_COUNT=$(grep -Ei "ERROR|Failed" "$LOG_FILE" | wc -l)

CRITICAL_EVENTS=$(grep -n "CRITICAL" "$LOG_FILE" || true)

TOP_ERRORS=$(grep "ERROR" "$LOG_FILE" \
| awk '{$1=$2=$3=""; print}' \
| sort \
| uniq -c \
| sort -rn \
| head -5)

TOTAL_LINES=$(wc -l < "$LOG_FILE")

REPORT_FILE="log_report_$(date +%Y-%m-%d).txt"

{
echo "====================================="
echo "LOG ANALYSIS REPORT"
echo "====================================="
echo "Date: $(date)"
echo "Log File: $LOG_FILE"
echo "Total Lines: $TOTAL_LINES"
echo "Total Errors: $ERROR_COUNT"

echo
echo "----- Top 5 Errors -----"
echo "$TOP_ERRORS"

echo
echo "----- Critical Events -----"
echo "$CRITICAL_EVENTS"

} > "$REPORT_FILE"

echo "Report Generated Successfully"
echo "Report File: $REPORT_FILE"

mkdir -p archive

mv "$LOG_FILE" archive/

echo "Log archived successfully."
```

---

# Commands & Tools Used

| Tool    | Purpose                   |
| ------- | ------------------------- |
| grep    | Search patterns           |
| grep -n | Show line numbers         |
| awk     | Extract error messages    |
| sort    | Sort data                 |
| uniq -c | Count occurrences         |
| wc -l   | Count lines               |
| mv      | Move files                |
| mkdir   | Create directories        |
| date    | Generate report timestamp |

---

# What I Learned

## 1. Logs are Data

Production logs contain valuable information about application health, failures, and performance.

---

## 2. Bash Can Automate Real Operational Tasks

Using Bash, we can automate analysis, reporting, monitoring, and maintenance workflows.

---

## 3. Combining Linux Utilities is Powerful

Tools like grep, awk, sort, uniq, and wc can be combined to perform complex log analysis with very little code.

---

# Conclusion

This project demonstrated how Bash scripting can be used to automate log analysis, identify critical incidents, generate reports, and archive processed logs. These are common tasks performed by DevOps Engineers, System Administrators, and SRE teams in real production environments.
