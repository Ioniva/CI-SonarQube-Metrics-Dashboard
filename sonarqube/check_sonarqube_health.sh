#!/bin/sh

# Define the URLs using environment variables
STATUS_URL="http://${SONARQUBE_HOST}:${SONARQUBE_PORT}/api/system/status"

# Function to check the SonarQube status
check_status() {
    echo "Checking SonarQube status at $STATUS_URL..."
    # Loop until SonarQube is up and running
    until wget -qO- "$STATUS_URL" | grep -q '"status":"UP"'; do
        echo "SonarQube is not up yet. Retrying in 10 seconds..."
        sleep 10
    done
    echo "SonarQube is up and running!"
}

# Check status of SonarQube
check_status

# Exit with success status
exit 0
