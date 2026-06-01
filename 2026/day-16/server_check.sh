#!/bin/bash

SERVICE="nginx"

read -p "Do you want to check the status? (y/n): " choice

if [ "$choice" = "y" ]; then
    echo "Checking service status..."

    if systemctl is-active --quiet "$SERVICE"; then
        echo "$SERVICE is active."
    else
        echo "$SERVICE is not active."
    fi

elif [ "$choice" = "n" ]; then
    echo "Skipped."
else
    echo "Invalid choice."
fi