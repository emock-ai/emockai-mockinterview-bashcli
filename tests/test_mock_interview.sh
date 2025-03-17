#!/bin/bash
# tests/test_mock_interview.sh

# Enable strict error handling.
set -euo pipefail

echo "Starting test for mock_interview.sh..."

# Run the main interview script and check its exit code.
if ../bin/mock_interview.sh; then
    echo "Test passed: mock_interview.sh executed successfully."
else
    echo "Test failed: mock_interview.sh encountered an error."
    exit 1
fi
