#!/bin/zsh

# ───────────────────────────────
# Configuración e inicialización
# ───────────────────────────────

# Función para instalar adb si no está presente
install_adb() {
  if ! command -v adb &> /dev/null; then
    echo "⚠️  ADB no encontrado. Instalando con Homebrew..."
    if ! command -v brew &> /dev/null; then
      echo "❌ Homebrew es necesario pero no está instalado. Por favor instálalo primero."
      exit 1
    fi
    brew install android-platform-tools
  else
    echo "✅ ADB ya está instalado."
  fi
}

# Asegurar que adb esté instalado
install_adb

# Detectar dispositivo Android conectado
DEVICE_LINE=$(adb devices | grep -w "device" | head -n 1)
DEVICE_ID=$(echo "$DEVICE_LINE" | awk '{print $1}')

if [ -z "$DEVICE_ID" ]; then
  echo "❌ No se encontró ningún dispositivo Android conectado."
  exit 1
fi

echo "✅ Dispositivo detectado: $DEVICE_ID"

# ───────────────────────────────
# Preparar el entorno
# ───────────────────────────────

# Ruta al root del proyecto
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
PROJECT_ROOT=$(cd "$SCRIPT_DIR/../../../.." && pwd)
cd "$PROJECT_ROOT" || exit 1

# Limpiar y actualizar dependencias
flutter clean
flutter pub get

# ───────────────────────────────
# Ejecutar flutter run interactivo
# ───────────────────────────────

echo "🚀 Ejecutando 'flutter run' en modo interactivo..."
echo "ℹ️  Usa 'r' para hot reload, 'R' para hot restart, 'q' para salir."

flutter run --debug -d "$DEVICE_ID"
