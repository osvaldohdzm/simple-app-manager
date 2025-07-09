#!/bin/zsh
# Script universal para redirigir abort al proyecto correspondiente

PROJECT_NAME=$(basename "$PWD")
PROJECT_ABORT_PATH="tools/simple-app-manager/macos/$PROJECT_NAME/abort.sh"

if [ -f "$PROJECT_ABORT_PATH" ]; then
  exec ./$PROJECT_ABORT_PATH "$@"
else
  echo "❌ No se encontró $PROJECT_ABORT_PATH. ¿El proyecto está inicializado?"
  exit 1
fi 