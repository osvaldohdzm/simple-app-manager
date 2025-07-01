#!/bin/zsh
# Script universal para redirigir clean al proyecto correspondiente

PROJECT_NAME=$(basename "$PWD")
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR/Template"
if [ ! -d "$PROJECT_NAME" ] && [ -d "$TEMPLATE_DIR" ]; then
  cp -r "$TEMPLATE_DIR" "$PROJECT_NAME"
  for f in "$PROJECT_NAME"/*; do mv "$f" "$PROJECT_NAME/$(basename "$f" | sed "s/Template/$PROJECT_NAME/g")"; done
  echo "[INFO] Proyecto $PROJECT_NAME creado automáticamente a partir de Template."
fi
if [ -f "$PROJECT_NAME/clean.sh" ]; then
  exec ./$PROJECT_NAME/clean.sh "$@"
else
  echo "❌ No se encontró $PROJECT_NAME/clean.sh. ¿El proyecto está inicializado?"
  exit 1
fi 