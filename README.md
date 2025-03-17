> This `README.md` provides a clear and concise overview of the project, including setup instructions, usage guidelines, configuration options, testing procedures, and licensing information. 
---
---
# emockai-mockinterview-bashcli

## Overview

`emockai-mockinterview-bashcli` is a Bash CLI application designed to simulate mock interview sessions, aiding users in their interview preparation.

## Features

- Presents a series of interview questions.
- Records user responses.
- Logs interactions for review.

## Setup

1. **Clone the repository:**

   ```bash
   git clone https://github.com/emock-ai/emockai-mockinterview-bashcli.git
   ```

2. **Navigate to the project directory:**

   ```bash
   cd emockai-mockinterview-bashcli
   ```

3. **Run the setup script:**

   ```bash
   ./setup.sh
   ```

## Usage

Start a mock interview session:

```bash
./bin/mock_interview.sh
```

## Configuration

Modify `etc/emockai.cfg` to customize settings:

- `QUESTION_FILE`: Path to the interview questions file.
- `LOG_FILE`: Path to the log file.

## Testing

Execute tests to verify functionality:

```bash
./tests/test_mock_interview.sh
```

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.

*Github Org  - "@emock-ai"*
*Github Author Username - "@tmuhali"*

