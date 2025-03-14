#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change to the script directory
cd "$SCRIPT_DIR"

# Run the bot
python3 bot.py

# Log the execution
echo "Bot executed at $(date)" >> "$SCRIPT_DIR/bot_log.txt"
