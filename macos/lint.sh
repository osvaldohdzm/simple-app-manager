#!/bin/zsh
# Script universal para redirigir lint al proyecto correspondiente

PROJECT_NAME=$(basename "$PWD")
PROJECT_LINT_PATH="tools/simple-app-manager/macos/$PROJECT_NAME/lint.sh"

if [ -f "$PROJECT_LINT_PATH" ]; then
  exec ./$PROJECT_LINT_PATH "$@"
else
  echo "❌ No se encontró $PROJECT_LINT_PATH. ¿El proyecto está inicializado?"
  exit 1
fi 