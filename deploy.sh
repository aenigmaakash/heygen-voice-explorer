#!/bin/bash
set -e

# Load environment variables from .env file if it exists
if [ -f .env ]; then
  echo "Loading environment variables from .env file"
  export $(grep -v '^#' .env | xargs)
fi

# Check if API key is set
if [ -z "$VUE_APP_HEYGEN_API_KEY" ]; then
  echo "Error: VUE_APP_HEYGEN_API_KEY is not set. Please set it in .env file or export it."
  exit 1
fi

echo "Deploying Heygen Voice Explorer..."

# Bring down any existing containers
docker-compose down

# Pull images if using pre-built images or build locally
docker-compose build

# Start the application
docker-compose up -d

echo "Deployment completed successfully!"
echo "The application is now running at http://localhost:3000" 