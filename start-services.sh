#!/bin/bash

# Run your configuration script
./generate_config.sh

# Check if the configuration script ran successfully
if [ $? -ne 0 ]; then
  echo "❌ Error: The configuration script did not run successfully."
  exit 1
fi

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
  echo "❌ Error: Docker is not running. Please check that Docker is started."
  exit 1
fi

# Run docker-compose up
docker compose -f "docker-compose.yml" up -d --build

# Check if docker-compose up ran successfully
if [ $? -ne 0 ]; then
  echo "❌ Error: docker-compose up did not run successfully."
  exit 1
fi

# Message indicating successful completion
echo "✅ Configuration and deployment completed successfully."
