#!/bin/bash
# setup.sh

# Create necessary directories
mkdir -p bin etc src tests logs

# Set execute permissions for scripts
chmod +x bin/mock_interview.sh
chmod +x src/interview_questions.sh
chmod +x tests/test_mock_interview.sh

echo "Setup completed."
