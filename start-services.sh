#!/bin/bash

# ---------------------------- Section: Usage Function ----------------------------
# Function to display usage information
usage() {
  echo "Options:"
  echo "  --skip, -s    Skip health check for specific services (comma-separated)"
  echo "  --help, -h    Display this help message"
  exit 1
}

# ---------------------------- Section: Option Parsing ----------------------------
# Initialize the variable for skipping services
SKIP_SERVICES=""

# Parse options using a cleaner approach
while [[ $# -gt 0 ]]; do
  case "$1" in
  --skip | -s)
    if [[ -n "$2" && ! "$2" =~ ^- ]]; then
      SKIP_SERVICES="$2"
      shift 2
    else
      echo "❌ Error: --skip | -s requires a comma-separated list of services."
      usage
    fi
    ;;
  --help | -h)
    usage
    ;;
  *)
    echo "❌ Error: Invalid option '$1'."
    usage
    ;;
  esac
done

# Convert comma-separated SKIP_SERVICES into an array
IFS=',' read -r -a SKIP_SERVICES_ARRAY <<<"$SKIP_SERVICES"

# ---------------------------- Section: Configuration Script ----------------------------
# Run your configuration script
echo "⚙️  Running configuration scripts..."
./generate_config.sh

# Check if the configuration script ran successfully
if [ $? -ne 0 ]; then
  echo "❌ Error: The configuration script did not run successfully."
  exit 1
fi

# ---------------------------- Section: Docker Setup ----------------------------
# Check if Docker is running
if ! docker info >/dev/null 2>&1; then
  echo "❌ Error: Docker is not running. Please start Docker."
  exit 1
fi

# Run docker-compose up
echo "🚀 Starting Docker services..."
docker compose -f "docker-compose.yml" up -d --build

# Check if docker-compose up ran successfully
if [ $? -ne 0 ]; then
  echo "❌ Error: docker-compose up did not run successfully."
  exit 1
fi

# ---------------------------- Section: Service Check ----------------------------
# Get the list of all services defined in the docker-compose.yml
ALL_SERVICES=$(docker compose -f "docker-compose.yml" config --services)

echo -e "🔄 Checking the status of services..."

# Function to check if a service is in the skip list
skip_service() {
  local service=$1
  for skipped in "${SKIP_SERVICES_ARRAY[@]}"; do
    if [[ "$skipped" == "$service" ]]; then
      return 0 # Found in skip list
    fi
  done
  return 1 # Not found
}

# Track the number of services that are running
RUNNING_COUNT=0
CHECKED_COUNT=0
TOTAL_SERVICES=$(echo "$ALL_SERVICES" | wc -w)

# Check the status of each service
for SERVICE in $ALL_SERVICES; do
  # Skip the service if it's in the SKIP_SERVICES_ARRAY list
  if skip_service "$SERVICE"; then
    echo "⚠️  Skipping check for service: $SERVICE"
    continue
  fi

  # Get the container ID of the service
  CONTAINER_ID=$(docker compose -f "docker-compose.yml" ps -q "$SERVICE")

  if [[ -z "$CONTAINER_ID" ]]; then
    echo "❌ Error: Container for service '$SERVICE' not found."
    exit 1
  fi

  # Check if the service is running
  SERVICE_STATE=$(docker inspect --format "{{.State.Status}}" "$CONTAINER_ID")

  if [ "$SERVICE_STATE" != "running" ]; then
    echo "❌ Error: Service '$SERVICE' is not running. Current state: $SERVICE_STATE"
    exit 1
  else
    echo "✅ Service '$SERVICE' is running."
    ((RUNNING_COUNT++))
  fi
  ((CHECKED_COUNT++))
done

# ---------------------------- Section: Final Output ----------------------------
# Final message based on the checks
if [ "$RUNNING_COUNT" -eq "$CHECKED_COUNT" ]; then
  echo -e "\n🎉 All checked services are running successfully! (${RUNNING_COUNT}/${CHECKED_COUNT} services checked)\n"
else
  echo -e "\n⚠️  Some services are not running as expected. Please check logs or configuration.\n"
fi

echo "✅ Configuration and deployment completed successfully."
