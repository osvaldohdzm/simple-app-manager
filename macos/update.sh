#!/bin/zsh
# Script universal para redirigir update al proyecto correspondiente

PROJECT_NAME=$(basename "$PWD")
PROJECT_UPDATE_PATH="tools/simple-app-manager/macos/$PROJECT_NAME/update.sh"

if [ -f "$PROJECT_UPDATE_PATH" ]; then
  exec ./$PROJECT_UPDATE_PATH "$@"
else
  echo "❌ No se encontró $PROJECT_UPDATE_PATH. ¿El proyecto está inicializado?"
  exit 1
fi 