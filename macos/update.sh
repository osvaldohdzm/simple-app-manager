#!/bin/zsh
# Script universal para redirigir update al proyecto correspondiente

PROJECT_NAME=$(basename "$PWD")
if [ -f "$PROJECT_NAME/update.sh" ]; then
  exec ./$PROJECT_NAME/update.sh "$@"
else
  echo "❌ No se encontró $PROJECT_NAME/update.sh. ¿El proyecto está inicializado?"
  exit 1
fi 