#!/bin/zsh
# Script universal para redirigir test al proyecto correspondiente

PROJECT_NAME=$(basename "$PWD")
PROJECT_TEST_PATH="tools/simple-app-manager/macos/$PROJECT_NAME/test.sh"

if [ -f "$PROJECT_TEST_PATH" ]; then
  exec ./$PROJECT_TEST_PATH "$@"
else
  echo "❌ No se encontró $PROJECT_TEST_PATH. ¿El proyecto está inicializado?"
  exit 1
fi 