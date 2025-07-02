#!/bin/zsh
# Script universal para redirigir publish al proyecto correspondiente

PROJECT_NAME=$(basename "$PWD")
PROJECT_PUBLISH_PATH="tools/simple-app-manager/macos/$PROJECT_NAME/publish.sh"

if [ -f "$PROJECT_PUBLISH_PATH" ]; then
  exec ./$PROJECT_PUBLISH_PATH "$@"
else
  echo "❌ No se encontró $PROJECT_PUBLISH_PATH. ¿El proyecto está inicializado?"
  exit 1
fi 