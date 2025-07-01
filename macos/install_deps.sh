#!/bin/bash
# Instala las dependencias necesarias para los scripts universales

if ! command -v yq &>/dev/null; then
  echo "Instalando yq..."
  if command -v brew &>/dev/null; then
    brew install yq
  else
    echo "Por favor instala yq manualmente: https://github.com/mikefarah/yq"
    exit 1
  fi
else
  echo "yq ya está instalado."
fi

echo "Dependencias instaladas." 
# Copiar estructura de Template al crear un nuevo proyecto
if [ ! -d "$(dirname "$0")/$PROJECT_NAME" ]; then
  cp -r "$(dirname "$0")/Template" "$(dirname "$0")/$PROJECT_NAME"
  for f in "$(dirname "$0")/$PROJECT_NAME"/*; do mv "$f" "$(dirname "$0")/$PROJECT_NAME/$(basename "$f" | sed "s/Template/$PROJECT_NAME/g")"; done
  echo "[INFO] Proyecto $PROJECT_NAME creado a partir de Template."
fi

# Validar y/o automatizar la inclusión en project_flows.yaml
if ! yq e ".proyectos.$PROJECT_NAME" project_flows.yaml &>/dev/null; then
  echo "[INFO] El proyecto $PROJECT_NAME no está en project_flows.yaml. Añadiendo entrada básica..."
  yq e ".proyectos.$PROJECT_NAME = {build: \"build_$PROJECT_NAME\", clean: \"clean_$PROJECT_NAME\", deploy: \"deploy_$PROJECT_NAME\", abort: \"abort_$PROJECT_NAME\", publish: \"publish_$PROJECT_NAME\"}" -i project_flows.yaml
  echo "[INFO] Proyecto $PROJECT_NAME añadido a project_flows.yaml."
fi

