#!/bin/bash

set -e

mkdir /tmp/devops-test || echo "Directory already exists"

cd /tmp/devops-test || {
    echo "Failed to enter directory"
    exit 1
}

touch demo.txt || {
    echo "Failed to create file"
    exit 1
}

echo "Script completed successfully"
