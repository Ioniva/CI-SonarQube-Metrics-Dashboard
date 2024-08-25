#!/bin/sh

# Definir la ruta al archivo .env
ENV_FILE="./.env"

# Comprobar si el archivo .env existe y cargar variables
if [ -f "$ENV_FILE" ]; then
  set -o allexport
  source "$ENV_FILE"
  set +o allexport
else
  echo "Error: No se encuentra el archivo $ENV_FILE"
  exit 1
fi

# Directorio de plantillas y archivo de configuración
TEMPLATE_DIR="./templates"
CONFIG_FILE="./config_mappings.config"

# Comprobar si envsubst está disponible
if ! command -v envsubst > /dev/null 2>&1; then
  echo "Error: envsubst no está instalado. Por favor, instálalo y vuelve a intentarlo."
  exit 1
fi

# Leer el archivo de configuración y procesar cada mapeo
while IFS='=' read -r template_name output_path; do
  # Ignorar líneas vacías y comentarios
  [ -z "$template_name" ] || [ "${template_name:0:1}" = "#" ] && continue

  # Separar nombre del archivo y directorio de salida
  output_dir=$(dirname "$output_path")
  output_file=$(basename "$output_path")

  # Comprobar si ambos nombres están definidos
  if [ -n "$template_name" ] && [ -n "$output_path" ]; then
    template_file="$TEMPLATE_DIR/$template_name"
    output_file_path="$output_dir/$output_file"
    
    # Crear el directorio de salida si no existe
    mkdir -p "$output_dir"
    
    # Comprobar si el archivo de plantilla existe
    if [ -f "$template_file" ]; then
      # Generar el archivo de salida utilizando envsubst
      envsubst < "$template_file" > "$output_file_path"
      
      if [ $? -eq 0 ]; then
        echo "Archivo $output_file_path generado correctamente."
      else
        echo "Error al generar el archivo $output_file_path."
        exit 1
      fi
    else
      echo "Error: No se encuentra el archivo de plantilla $template_file"
      exit 1
    fi
  else
    echo "Error: Configuración incorrecta en $CONFIG_FILE"
    exit 1
  fi
done < "$CONFIG_FILE"
