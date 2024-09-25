#!/bin/bash

# Fetch system status from the API and check if the status is "UP"
if wget -qO- http://localhost:9000/api/system/status | grep -q '"status": *"UP"'; then
    exit 0  # Healthy
else
    exit 1  # Unhealthy
fi
