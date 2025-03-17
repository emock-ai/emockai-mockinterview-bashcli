#!/bin/bash
# setup.sh

# Enable strict mode for robust error handling.
set -euo pipefail

echo "Starting setup..."

# Define necessary directories.
directories=("bin" "etc" "src" "tests" "logs")

for dir in "${directories[@]}"; do
    mkdir -p "$dir"
    echo "Directory '$dir' ensured."
done

# List of scripts to set executable permissions.
scripts=("bin/mock_interview.sh" "src/interview_questions.sh" "tests/test_mock_interview.sh")

for script in "${scripts[@]}"; do
    if [[ -f "$script" ]]; then
        chmod +x "$script"
        echo "Executable permission set on $script"
    else
        echo "Warning: $script not found; skipping permission change."
    fi
done

echo "Setup completed successfully."
