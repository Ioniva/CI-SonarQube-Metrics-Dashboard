#!/bin/sh

# Define the URLs using environment variables
HEALTH_URL="http://${SONARQUBE_HOST}:${SONARQUBE_PORT}/api/system/health"
STATUS_URL="http://${SONARQUBE_HOST}:${SONARQUBE_PORT}/api/system/status"

# Function to check if SonarQube is healthy
check_health() {
    echo "Checking if SonarQube is fully healthy at $HEALTH_URL..."
    # Loop until SonarQube returns "GREEN" for health status
    until curl -s "$HEALTH_URL" | grep -q '"status":"GREEN"'; do
        echo "SonarQube is not fully healthy yet. Retrying in 10 seconds..."
        sleep 10
    done
    echo "SonarQube is fully healthy!"
}

# Function to check the SonarQube status
check_status() {
    echo "Checking SonarQube status at $STATUS_URL..."
    # Loop until SonarQube is up and running
    until curl -s "$STATUS_URL" | grep -q '"status":"UP"'; do
        echo "SonarQube is not up yet. Retrying in 10 seconds..."
        sleep 10
    done
    echo "SonarQube is up and running!"
}

# Check health and status of SonarQube
check_health
check_status

# Exit with success status
exit 0
