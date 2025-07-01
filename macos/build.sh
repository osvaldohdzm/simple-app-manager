#!/bin/zsh
# Script universal para redirigir build al proyecto correspondiente

PROJECT_NAME=$(basename "$PWD")
if [ -f "$PROJECT_NAME/build.sh" ]; then
  exec ./$PROJECT_NAME/build.sh "$@"
else
  echo "❌ No se encontró $PROJECT_NAME/build.sh. ¿El proyecto está inicializado?"
  exit 1
fi 