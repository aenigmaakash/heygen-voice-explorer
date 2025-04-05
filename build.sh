#!/bin/bash
set -e

# Load environment variables from .env file if it exists
if [ -f .env ]; then
  echo "Loading environment variables from .env file"
  export $(grep -v '^#' .env | xargs)
fi

echo "Building Docker image for Heygen Voice Explorer..."
docker build -t heygen-voice-explorer:latest .

echo "Build completed successfully!" 