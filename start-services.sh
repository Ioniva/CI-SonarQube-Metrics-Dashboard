#!/bin/bash

# Ejecutar tu script de configuración
./generate_config.sh

# Luego, ejecutar docker-compose up
docker compose -f "docker-compose.yml" up -d --build 
