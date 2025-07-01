#!/bin/zsh 
# Script para crear manualmente la estructura de un nuevo proyecto a partir de Template

PROJECT_NAME=$(basename "$PWD")
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR/Template"
PROJECT_DIR="$SCRIPT_DIR/$PROJECT_NAME"
if [ ! -d "$PROJECT_DIR" ] && [ -d "$TEMPLATE_DIR" ]; then
  cp -r "$TEMPLATE_DIR" "$PROJECT_DIR"
  for f in "$PROJECT_DIR"/*; do mv "$f" "$PROJECT_DIR/$(basename "$f" | sed "s/Template/$PROJECT_NAME/g")"; done
  chmod +x "$PROJECT_DIR"/*.sh
  echo "[INFO] Proyecto $PROJECT_NAME creado automáticamente a partir de Template en $PROJECT_DIR."
fi 