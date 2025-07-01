#!/bin/zsh
# Script universal para redirigir lint al proyecto correspondiente

PROJECT_NAME=$(basename "$PWD")
if [ -f "$PROJECT_NAME/lint.sh" ]; then
  exec ./$PROJECT_NAME/lint.sh "$@"
else
  echo "❌ No se encontró $PROJECT_NAME/lint.sh. ¿El proyecto está inicializado?"
  exit 1
fi 