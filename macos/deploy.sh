#!/bin/zsh
# Script universal para redirigir deploy al proyecto correspondiente

PROJECT_NAME=$(basename "$PWD")
if [ -f "$PROJECT_NAME/deploy.sh" ]; then
  exec ./$PROJECT_NAME/deploy.sh "$@"
else
  echo "❌ No se encontró $PROJECT_NAME/deploy.sh. ¿El proyecto está inicializado?"
  exit 1
fi 