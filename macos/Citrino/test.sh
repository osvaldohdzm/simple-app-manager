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
# Configurar logging
# ───────────────────────────────

# Carpeta de logs
LOG_DIR="$PROJECT_ROOT/logs"
mkdir -p "$LOG_DIR"

# Archivo con timestamp
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOG_FILE="$LOG_DIR/flutter_run_$TIMESTAMP.log"

# ───────────────────────────────
# Ejecutar flutter run en segundo plano
# ───────────────────────────────

echo "🚀 Ejecutando 'flutter run' en segundo plano..."
echo "📄 Guardando salida en: $LOG_FILE"

flutter flutter run -d "$DEVICE_ID" -v > "$LOG_FILE" 2>&1 &

echo "🟢 Prueba iniciada correctamente. Este script ya terminó y no bloqueará procesos externos."
