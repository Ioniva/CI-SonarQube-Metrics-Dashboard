#!/bin/sh

# Define the URL using environment variables
URL="http://${SONARQUBE_HOST}:${SONARQUBE_PORT}/api/system/health"

# Wait for SonarQube to be fully healthy
echo "Checking if SonarQube is fully healthy at $URL..."

# Loop until SonarQube returns "GREEN" for health status
until curl -s "$URL" | grep -q '"status":"GREEN"'; do
    echo "SonarQube is not fully healthy yet. Retrying in 10 seconds..."
    sleep 10
done

# Once SonarQube is fully healthy
echo "SonarQube is fully healthy and ready!"
exit 0
