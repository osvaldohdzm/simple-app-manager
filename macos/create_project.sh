#!/bin/zsh 
# Script para crear manualmente la estructura de un nuevo proyecto a partir de Template

PROJECT_NAME=$(basename "$PWD")
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR/Template"
if [ ! -d "$PROJECT_NAME" ] && [ -d "$TEMPLATE_DIR" ]; then
  cp -r "$TEMPLATE_DIR" "$PROJECT_NAME"
  for f in "$PROJECT_NAME"/*; do mv "$f" "$PROJECT_NAME/$(basename "$f" | sed "s/Template/$PROJECT_NAME/g")"; done
  echo "[INFO] Proyecto $PROJECT_NAME creado automáticamente a partir de Template."
else
  echo "[INFO] El proyecto $PROJECT_NAME ya existe o no se encontró la carpeta Template."
fi 