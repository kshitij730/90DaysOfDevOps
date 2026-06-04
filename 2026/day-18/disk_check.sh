#!/bin/bash

check_disk() {
    echo "========== DISK USAGE =========="
    df -h /
}

check_memory() {
    echo
    echo "========== MEMORY USAGE =========="
    free -h
}

check_disk
check_memory
