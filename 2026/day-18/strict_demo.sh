#!/bin/bash

set -euo pipefail

echo "Strict Mode Enabled"

echo "$MY_VAR"

false

echo "This line will never execute"
