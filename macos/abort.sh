#!/bin/zsh
# Script universal para redirigir abort al proyecto correspondiente

PROJECT_NAME=$(basename "$PWD")
if [ -f "$PROJECT_NAME/abort.sh" ]; then
  exec ./$PROJECT_NAME/abort.sh "$@"
else
  echo "❌ No se encontró $PROJECT_NAME/abort.sh. ¿El proyecto está inicializado?"
  exit 1
fi 