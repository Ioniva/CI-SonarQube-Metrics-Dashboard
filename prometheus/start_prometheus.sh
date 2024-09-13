#!/bin/bash

# Define la URL para cambiar la contraseña de SonarQube
SONARQUBE_URL="http://${SONARQUBE_USER}:${SONARQUBE_OLD_PASSWORD}@${SONARQUBE_HOST}:${SONARQUBE_PORT}/api/users/change_password?login=${SONARQUBE_USER}&previousPassword=${SONARQUBE_OLD_PASSWORD}&password=${SONARQUBE_NEW_PASSWORD}"

# Espera 1 minuto antes de ejecutar el comando wget
echo "Esperando 1 minuto antes de cambiar la contraseña de SonarQube..."
sleep 120

# Ejecuta el comando wget para cambiar la contraseña de SonarQube
wget_output=$(wget --post-data='' "$SONARQUBE_URL" -O - 2>&1)
wget_status=$?

# Verifica si el comando wget fue exitoso
if [[ $wget_status -ne 0 ]]; then
  echo "Error: La contraseña de SonarQube ya ha sido cambiada o hubo un error con wget."
  echo "wget falló con el estado $wget_status. Salida:"
  echo "$wget_output"
else
  echo "La contraseña de SonarQube se cambió con éxito."
fi

# Inicia el servicio de Prometheus
echo "Iniciando Prometheus..."
exec prometheus --config.file=/etc/prometheus/prometheus.yml
