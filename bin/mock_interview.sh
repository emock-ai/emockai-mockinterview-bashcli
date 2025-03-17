#!/bin/bash
# mock_interview.sh - A refined and modular solution for conducting mock interview sessions.

# Enable strict error handling.
set -euo pipefail

# Global Variables (adjust paths as needed)
CONFIG_FILE="../etc/emockai.cfg"    # For text-based configuration
LOG_FILE="${LOG_FILE:-interview.log}" # Default log file (can be set in CONFIG_FILE)
QUESTION_FILE="${QUESTION_FILE:-questions.sh}"  # This file should define a QUESTIONS array

# Audio Interview globals
REPO_DIR="emockai-mockinterview-bashcli"
RECORDINGS_DIR="recordings"
AUDIO_QUESTIONS_FILE="questions.txt"

#######################################
# Log a message with a timestamp.
# Globals:
#   LOG_FILE
# Arguments:
#   Message string
# Returns:
#   None
#######################################
log_message() {
    local message="$1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $message" >> "$LOG_FILE"
}

#######################################
# Load configuration for text-based interview.
# Exits if configuration file is missing.
#######################################
load_config() {
    if [[ -f "$CONFIG_FILE" ]]; then
        source "$CONFIG_FILE"
        log_message "Configuration loaded from $CONFIG_FILE"
    else
        echo "Error: Configuration file not found at $CONFIG_FILE" >&2
        exit 1
    fi
}

#######################################
# Load interview questions for text mode.
# Expects a QUESTIONS array to be defined.
#######################################
load_text_questions() {
    if [[ -f "$QUESTION_FILE" ]]; then
        source "$QUESTION_FILE"
        if [[ -z "${QUESTIONS:-}" ]]; then
            echo "Error: QUESTIONS array not defined in $QUESTION_FILE" >&2
            exit 1
        fi
    else
        echo "Error: Interview questions file not found at $QUESTION_FILE" >&2
        exit 1
    fi
}

#######################################
# Conduct a text-based interview session.
#######################################
conduct_text_interview() {
    echo "Welcome to the mock interview session (Text-Based)."
    log_message "Text-based interview started."

    for question in "${QUESTIONS[@]}"; do
        echo "Question: $question"
        log_message "Asked: $question"
        read -rp "Your answer: " answer
        log_message "Answered: $answer"
    done

    echo "Interview session completed."
    log_message "Text-based interview completed."
}

#######################################
# Install audio dependencies if missing.
#######################################
install_audio_dependencies() {
    echo "🔧 Installing necessary audio dependencies..."
    if ! command -v arecord &>/dev/null; then
        echo "Installing arecord..."
        sudo apt update && sudo apt install -y alsa-utils
    fi
    if ! command -v aplay &>/dev/null; then
        echo "Installing aplay..."
        sudo apt update && sudo apt install -y alsa-utils
    fi
    if ! command -v arecord &>/dev/null || ! command -v aplay &>/dev/null; then
        echo "Error: Audio dependency installation failed." >&2
        exit 1
    fi
}

#######################################
# Clone the repository if it doesn't exist.
#######################################
setup_repo() {
    if [ ! -d "$REPO_DIR" ]; then
        echo "Cloning repository..."
        git clone https://github.com/emock-ai/emockai-mockinterview-bashcli.git "$REPO_DIR"
    fi
    cd "$REPO_DIR" || exit
}

#######################################
# Create the recordings directory if needed.
#######################################
setup_recordings_dir() {
    mkdir -p "$RECORDINGS_DIR"
}

#######################################
# Prepare a default questions file for the audio interview.
#######################################
setup_audio_questions_file() {
    if [ ! -f "$AUDIO_QUESTIONS_FILE" ]; then
        echo "Preparing default questions file..."
        cat > "$AUDIO_QUESTIONS_FILE" <<'EOL'
Tell me about yourself.
What are your strengths and weaknesses?
Why do you want this job?
Explain a challenging situation you've faced and how you handled it.
Where do you see yourself in 5 years?
EOL
    fi
}

#######################################
# Record an answer for a given question number.
# Arguments:
#   Question ID (number)
#######################################
record_answer() {
    local question_id="$1"
    local filename="$RECORDINGS_DIR/answer_${question_id}.wav"
    echo "🎤 Recording your answer for Question #$question_id. Press Ctrl+C to stop recording."
    arecord -f cd -t wav "$filename"
    echo "✅ Answer saved as: $filename"
}

#######################################
# Play back all recorded answers.
#######################################
play_all_answers() {
    echo "🎧 Playing back all recorded answers..."
    for file in "$RECORDINGS_DIR"/*.wav; do
        [ -f "$file" ] || continue
        echo "🔊 Playing: $file"
        aplay "$file"
    done
}

#######################################
# Conduct an audio-based interview session.
#######################################
conduct_audio_interview() {
    echo "Welcome to the mock interview session (Audio-Based)."
    log_message "Audio-based interview started."
    
    setup_audio_questions_file

    local question_id=1
    while IFS= read -r question || [ -n "$question" ]; do
        echo "🔹 Question #$question_id: $question"
        log_message "Asked (audio): $question"
        record_answer "$question_id"
        ((question_id++))
    done < "$AUDIO_QUESTIONS_FILE"
    
    play_all_answers
    log_message "Audio-based interview completed."
}

#######################################
# Display usage instructions.
#######################################
usage() {
    echo "Usage: $0 [--text | --audio]"
    echo "  --text    Run a text-based interview session"
    echo "  --audio   Run an audio-based interview session (requires recording/playback hardware)"
    exit 1
}

#######################################
# Main entry point: choose the interview mode based on the command-line argument.
#######################################
main() {
    if [ "$#" -ne 1 ]; then
        usage
    fi

    case "$1" in
        --text)
            load_config
            load_text_questions
            conduct_text_interview
            ;;
        --audio)
            install_audio_dependencies
            setup_repo
            setup_recordings_dir
            conduct_audio_interview
            ;;
        *)
            usage
            ;;
    esac
}

# Execute the main function with command-line arguments.
main "$@"
