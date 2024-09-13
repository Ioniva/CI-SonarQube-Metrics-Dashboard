#!/bin/sh

# Define the URL
URL="http://localhost:9000/api/system/status"

# Use curl to fetch the status and check if SonarQube is up
if curl -s "$URL" | grep -q '"status":"UP"'; then
    echo "SonarQube is up and running!"
    exit 0
else
    echo "SonarQube is not up yet."
    exit 1
fi
