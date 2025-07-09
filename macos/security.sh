#!/bin/zsh
# Script universal para redirigir security al proyecto correspondiente

PROJECT_NAME=$(basename "$PWD")
PROJECT_SECURITY_PATH="tools/simple-app-manager/macos/$PROJECT_NAME/security.sh"

if [ -f "$PROJECT_SECURITY_PATH" ]; then
  exec ./$PROJECT_SECURITY_PATH "$@"
else
  echo "❌ No se encontró $PROJECT_SECURITY_PATH. ¿El proyecto está inicializado?"
  exit 1
fi 