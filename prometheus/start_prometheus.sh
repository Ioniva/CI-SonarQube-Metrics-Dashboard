#!/bin/bash

# Perform the wget operation
wget_output=$(wget --post-data='' "http://${SONARQUBE_USER}:${SONARQUBE_OLD_PASSWORD}@${SONARQUBE_HOST}:${SONARQUBE_PORT}/api/users/change_password?login=${SONARQUBE_USER}&previousPassword=${SONARQUBE_OLD_PASSWORD}&password=${SONARQUBE_NEW_PASSWORD}" -O - 2>&1)
wget_status=$?

# Check if wget was successful and log the output
if [ $wget_status -ne 0 ]; then
  echo "the sonarqube password is already changed, or wget error."
  # echo "wget failed with status $wget_status. Output:"
  # echo "$wget_output"
  # exit 1
else
  echo "wget succeeded."
fi

# Start Prometheus
echo "Starting Prometheus..."
exec prometheus --config.file=/etc/prometheus/prometheus.yml
