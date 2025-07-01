#!/bin/zsh
# Script universal para redirigir clean al proyecto correspondiente

PROJECT_NAME=$(basename "$PWD")
if [ -f "$PROJECT_NAME/clean.sh" ]; then
  exec ./$PROJECT_NAME/clean.sh "$@"
else
  echo "❌ No se encontró $PROJECT_NAME/clean.sh. ¿El proyecto está inicializado?"
  exit 1
fi 