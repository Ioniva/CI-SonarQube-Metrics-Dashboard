#!/bin/sh

# Define the path to the .env file
ENV_FILE="./.env"

# Check if the .env file exists and load variables
if [ -f "$ENV_FILE" ]; then
  set -o allexport
  source "$ENV_FILE"
  set +o allexport
else
  echo "Error: The file $ENV_FILE is missing."
  exit 1
fi

# Directory for templates and configuration file
TEMPLATE_DIR="./templates"
CONFIG_FILE="./config_mappings.config"

# Check if envsubst is available
if ! command -v envsubst > /dev/null 2>&1; then
  echo "Error: envsubst is not installed. Please install it and try again."
  exit 1
fi

# Read the configuration file and process each mapping
while IFS='=' read -r template_name output_path; do
  # Skip empty lines and comments
  [ -z "$template_name" ] || [ "${template_name:0:1}" = "#" ] && continue

  # Separate file name and output directory
  output_dir=$(dirname "$output_path")
  output_file=$(basename "$output_path")

  # Check if both names are defined
  if [ -n "$template_name" ] && [ -n "$output_path" ]; then
    template_file="$TEMPLATE_DIR/$template_name"
    output_file_path="$output_dir/$output_file"

    # Create the output directory if it doesn't exist
    mkdir -p "$output_dir"

    # Check if the template file exists
    if [ -f "$template_file" ]; then
      # Generate the output file using envsubst
      envsubst < "$template_file" > "$output_file_path"

      if [ $? -eq 0 ]; then
        echo "File $output_file_path generated successfully."
      else
        echo "Error generating the file $output_file_path."
        exit 1
      fi
    else
      echo "Error: The template file $template_file is missing."
      exit 1
    fi
  else
    echo "Error: Incorrect configuration in $CONFIG_FILE."
    exit 1
  fi
done < "$CONFIG_FILE"
