#!/bin/zsh
# Script universal para redirigir build al proyecto correspondiente

PROJECT_NAME=$(basename "$PWD")
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR/Template"
PROJECT_DIR="$SCRIPT_DIR/$PROJECT_NAME"

if [ ! -d "$PROJECT_DIR" ] && [ -d "$TEMPLATE_DIR" ]; then
  cp -r "$TEMPLATE_DIR" "$PROJECT_DIR"
  for f in "$PROJECT_DIR"/*; do mv "$f" "$PROJECT_DIR/$(basename "$f" | sed "s/Template/$PROJECT_NAME/g")"; done
  echo "[INFO] Proyecto $PROJECT_NAME creado automáticamente a partir de Template."
fi

PROJECT_BUILD_PATH="tools/simple-app-manager/macos/$PROJECT_NAME/build.sh"

if [ -f "$PROJECT_BUILD_PATH" ]; then
  exec ./$PROJECT_BUILD_PATH "$@"
else
  echo "❌ No se encontró $PROJECT_BUILD_PATH. ¿El proyecto está inicializado?"
  exit 1
fi 