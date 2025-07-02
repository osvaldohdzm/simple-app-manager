#!/bin/zsh

# Function to install adb if not present
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

# Step 1: Ensure adb is installed
install_adb

# Step 2: Detect connected devices
DEVICE_LINE=$(adb devices | grep -w "device" | head -n 1)

# Extraer el ID del dispositivo (IP o USB)
DEVICE_ID=$(echo "$DEVICE_LINE" | awk '{print $1}')

if [ -z "$DEVICE_ID" ]; then
  echo "❌ No se encontró ningún dispositivo Android conectado."
  exit 1
fi

echo "✅ Dispositivo encontrado: $DEVICE_ID"

# Step 3: Ejecutar comandos
flutter clean
flutter pub get
flutter run -d "$DEVICE_ID"