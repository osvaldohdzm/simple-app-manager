#!/bin/zsh
# Script universal para redirigir get_context al proyecto correspondiente

PROJECT_NAME=$(basename "$PWD")
if [ -f "$PROJECT_NAME/get_context.sh" ]; then
  exec ./$PROJECT_NAME/get_context.sh "$@"
else
  echo "❌ No se encontró $PROJECT_NAME/get_context.sh. ¿El proyecto está inicializado?"
  exit 1
fi 