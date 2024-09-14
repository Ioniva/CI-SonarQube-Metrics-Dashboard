#!/bin/bash

# Run your configuration script
./generate_config.sh

# Then, run docker-compose up
docker compose -f "docker-compose.yml" up -d --build
