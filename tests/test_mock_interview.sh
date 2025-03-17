#!/bin/bash
# tests/test_mock_interview.sh

# Test if the main script runs without errors
../bin/mock_interview.sh
if [[ $? -eq 0 ]]; then
    echo "Test passed: mock_interview.sh executed successfully."
else
    echo "Test failed: mock_interview.sh encountered an error."
fi
