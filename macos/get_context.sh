#!/bin/zsh
# Script universal para redirigir get_context al proyecto correspondiente

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_NAME=$(basename "$PWD")
PROJECT_DIR="$SCRIPT_DIR/$PROJECT_NAME"
if [ -f "$PROJECT_DIR/get_context.sh" ]; then
  exec "$PROJECT_DIR/get_context.sh" "$@"
else
  echo "❌ No se encontró $PROJECT_DIR/get_context.sh. ¿El proyecto está inicializado?"
  exit 1
fi 