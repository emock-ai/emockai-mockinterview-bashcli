#!/bin/bash
# bin/mock_interview.sh

CONFIG_FILE="../etc/emockai.cfg"

# Load configuration
if [[ -f "$CONFIG_FILE" ]]; then
    source "$CONFIG_FILE"
else
    echo "Configuration file not found!"
    exit 1
fi

# Load interview questions
if [[ -f "$QUESTION_FILE" ]]; then
    source "$QUESTION_FILE"
else
    echo "Interview questions file not found!"
    exit 1
fi

# Function to log messages
log_message() {
    local message="$1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $message" >> "$LOG_FILE"
}

# Function to conduct the interview
conduct_interview() {
    echo "Welcome to the mock interview session."
    log_message "Interview started."

    for question in "${QUESTIONS[@]}"; do
        echo "Question: $question"
        log_message "Asked: $question"
        read -p "Your answer: " answer
        log_message "Answered: $answer"
    done

    echo "Interview session completed."
    log_message "Interview completed."
}

# Execute the interview
conduct_interview
