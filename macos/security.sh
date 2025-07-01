#!/bin/zsh
# Script universal para redirigir security al proyecto correspondiente

PROJECT_NAME=$(basename "$PWD")
if [ -f "$PROJECT_NAME/security.sh" ]; then
  exec ./$PROJECT_NAME/security.sh "$@"
else
  echo "❌ No se encontró $PROJECT_NAME/security.sh. ¿El proyecto está inicializado?"
  exit 1
fi 