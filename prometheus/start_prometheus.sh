#!/bin/bash
# Define the URL for changing the SonarQube password
SONARQUBE_URL="http://${SONARQUBE_USER}:${SONARQUBE_OLD_PASSWORD}@${SONARQUBE_HOST}:${SONARQUBE_PORT}/api/users/change_password?login=${SONARQUBE_USER}&previousPassword=${SONARQUBE_OLD_PASSWORD}&password=${SONARQUBE_NEW_PASSWORD}"

# Execute the wget command to change the SonarQube password
wget_output=$(wget --post-data='' "$SONARQUBE_URL" -O - 2>&1)
wget_status=$?

# Check if wget command was successful
if [[ $wget_status -ne 0 ]]; then
  echo "Error: SonarQube password is already changed or there was a wget error."
  echo "wget failed with status $wget_status. Output:"
  echo "$wget_output"
else
  echo "SonarQube password changed successfully."
fi

# Start Prometheus service
echo "Starting Prometheus..."
exec prometheus --config.file=/etc/prometheus/prometheus.yml
