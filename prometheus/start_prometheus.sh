#!/bin/bash

# Define the URL to change the SonarQube password
SONARQUBE_URL="http://${SONARQUBE_USER}:${SONARQUBE_OLD_PASSWORD}@${SONARQUBE_HOST}:${SONARQUBE_PORT}/api/users/change_password?login=${SONARQUBE_USER}&previousPassword=${SONARQUBE_OLD_PASSWORD}&password=${SONARQUBE_NEW_PASSWORD}"
echo "${SONARQUBE_URL}"
# Execute the wget command to change the SonarQube password
wget_output=$(wget --post-data='' "$SONARQUBE_URL" -O - 2>&1)
wget_status=$?

# Check if the wget command was successful
if [[ $wget_status -ne 0 ]]; then
  echo "❌ Error: SonarQube password has either already been changed or there was an issue with wget."
  echo "  Possible reason: The new password might be the same as the previous password."
  echo "wget failed with status $wget_status. Output:"
  echo "$wget_output"
else
  echo "✅ SonarQube password changed successfully."
fi

# Start the Prometheus service
echo "🚀 Starting Prometheus..."
exec prometheus --config.file=/etc/prometheus/prometheus.yml
