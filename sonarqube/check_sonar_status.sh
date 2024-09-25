#!/bin/bash

# Define the URLs using environment variables
STATUS_URL="http://${SONARQUBE_HOST}:${SONARQUBE_PORT}/api/system/status"

# Fetch system status from the API and check if the status is "UP"
if wget -qO- "$STATUS_URL" | grep -q '"status": *"UP"'; then
    exit 0  # Healthy
else
    exit 1  # Unhealthy
fi
