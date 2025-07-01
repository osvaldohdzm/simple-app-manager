#!/bin/zsh
# Script universal para redirigir publish al proyecto correspondiente

PROJECT_NAME=$(basename "$PWD")
if [ -f "$PROJECT_NAME/publish.sh" ]; then
  exec ./$PROJECT_NAME/publish.sh "$@"
else
  echo "❌ No se encontró $PROJECT_NAME/publish.sh. ¿El proyecto está inicializado?"
  exit 1
fi 