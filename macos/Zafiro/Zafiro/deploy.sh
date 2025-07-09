#!/bin/zsh
# Despliegue específico para Zafiro (Flutter)
init_logging() {
  LOG_DIR="$PROJECT_ROOT/logs"
  mkdir -p "$LOG_DIR"
  LOG_FILE="$LOG_DIR/deployment_$(date +%Y%m%d_%H%M%S).log"
}

log_info() { echo "[INFO] $*"; }

init_logging
log_info "🔷 Despliegue para Zafiro iniciado"
log_info "Log: $LOG_FILE"

install_adb() {
  if ! command -v adb &>/dev/null; then
    echo "⚠️  ADB no encontrado. Instalando con Homebrew..."
    if ! command -v brew &>/dev/null; then
      echo "❌ Homebrew es necesario pero no está instalado."
      exit 1
    fi
    brew install android-platform-tools
  else
    echo "✅ ADB ya está instalado."
  fi
}

install_adb

local device_line=$(adb devices | grep -w "device" | head -n 1)
DEVICE_ID=$(echo "$device_line" | awk '{print $1}')

if [ -z "$DEVICE_ID" ]; then
  echo "❌ No se encontró ningún dispositivo Android conectado."
  exit 1
fi

echo "✅ Dispositivo encontrado: $DEVICE_ID"

echo "🧹 Limpiando proyecto..."
./Zafiro/clean.sh

echo "📦 Instalando dependencias..."
flutter pub get

echo "🚀 Ejecutando aplicación en dispositivo..."
flutter run -d "$DEVICE_ID" 