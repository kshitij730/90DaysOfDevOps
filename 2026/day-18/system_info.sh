#!/bin/bash

set -euo pipefail

print_header() {
    echo
    echo "========================================"
    echo "$1"
    echo "========================================"
}

system_info() {
    print_header "SYSTEM INFORMATION"
    hostnamectl | head -10
}

uptime_info() {
    print_header "SYSTEM UPTIME"
    uptime
}

disk_usage() {
    print_header "TOP 5 DISK USAGE DIRECTORIES"
    du -sh /* 2>/dev/null | sort -hr | head -5
}

memory_usage() {
    print_header "MEMORY USAGE"
    free -h
}

cpu_usage() {
    print_header "TOP 5 CPU CONSUMING PROCESSES"
    ps aux --sort=-%cpu | head -6
}

main() {
    system_info
    uptime_info
    disk_usage
    memory_usage
    cpu_usage
}

main