#!/bin/bash

# ==============================================================================
#  Script para Subir un APK renombrado a Google Drive usando rclone
#
#  Este script busca el archivo release generado por Flutter en modo release,
#  lo renombra como 'emerald-release.apk' y lo sube a la raíz de Google Drive.
# ==============================================================================

# --- Configuración ---

# 1. Nombre del "remote" de rclone para tu Google Drive.
RCLONE_REMOTE_NAME="gdrive"

# 2. Ruta absoluta del archivo generado por Flutter en modo release.
SOURCE_FILE="/Users/osvaldohm/Desktop/Emerald/android/app/build/outputs/apk/release/app-release.apk"
# 3. Nombre con el que se subirá el archivo a Google Drive.
TARGET_FILENAME="emerald-release.apk"

GDRIVE_FOLDER_PATH="Z Temporal/apks_releases"

# --- Lógica del Script ---

echo "🚀 Iniciando proceso de subida a Google Drive como '$TARGET_FILENAME'..."
echo "-------------------------------------------------"

# 1. Verificar si 'rclone' está instalado
if ! command -v rclone &> /dev/null; then
    echo "❌ Error: Comando 'rclone' no encontrado. Instálalo y configúralo primero."
    exit 1
fi

# 2. Verificar si el archivo fuente existe
if [ ! -f "$SOURCE_FILE" ]; then
    echo "❌ Error: No se encontró el archivo en la ruta especificada:"
    echo "   $SOURCE_FILE"
    exit 1
fi

echo "✅ Archivo encontrado: $(basename "$SOURCE_FILE")"

# 3. Crear archivo temporal con el nuevo nombre
TEMP_FILE="/tmp/$TARGET_FILENAME"
cp "$SOURCE_FILE" "$TEMP_FILE"

# 4. Subir a Google Drive con el nuevo nombre
DESTINATION_PATH="$RCLONE_REMOTE_NAME:$GDRIVE_FOLDER_PATH"
echo "🛰️  Subiendo a Google Drive como: $DESTINATION_PATH"
rclone copy "$TEMP_FILE" "$DESTINATION_PATH" -P

# 5. Verificar y limpiar
if [ $? -eq 0 ]; then
    echo "-------------------------------------------------"
    echo "✅🎉 ¡Éxito! El archivo fue subido como '$TARGET_FILENAME'."
    rm -f "$TEMP_FILE"
else
    echo "-------------------------------------------------"
    echo "❌ Error: Falló la subida con rclone."
    echo "   Revisa el mensaje de error anterior para más detalles."
fi
